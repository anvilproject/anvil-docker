#!/usr/bin/env bash
# t4-coder.sh — local agentic coding on a single Tesla T4 (Ubuntu, CUDA 12.x, sudo)
#
#   Model:   Qwen3.6-35B-A3B, Unsloth dynamic GGUF UD-Q4_K_XL (~22 GB)
#   Server:  llama.cpp llama-server for sm_75, MoE experts partly in CPU RAM
#            (prebuilt in the image at /opt/llama/bin, otherwise built from source)
#   Harness: Pi (default) and/or OpenCode, pointed at http://127.0.0.1:8181/v1
#
# Usage:
#   ./t4-coder.sh install      # download model + configure harness (builds llama.cpp only if not prebuilt)
#   ./t4-coder.sh tune         # try several --n-cpu-moe values, save the fastest that fits
#   ./t4-coder.sh start        # launch llama-server in the background
#   ./t4-coder.sh status       # health, VRAM, last log lines
#   ./t4-coder.sh stop
#
# Overrides go in the environment and win over the saved config, e.g.
#   N_CPU_MOE=28 ./t4-coder.sh start      THINK=0 ./t4-coder.sh start
#   HARNESS=both ./t4-coder.sh install    TUNE_VALUES="20 22 24 26" ./t4-coder.sh tune
#
# Everything lives under $LLM_HOME (default ~/llm) so it sits on the Terra persistent
# disk. apt packages may need reinstalling if the cloud environment is recreated;
# just re-run `install` (it skips finished steps).
#
# Recommended VM sizing: >= 48 GB RAM (52 GB is comfortable), >= 80 GB free disk.

set -euo pipefail

LLM_HOME="${LLM_HOME:-$HOME/llm}"
CONFIG="$LLM_HOME/config.env"
# shellcheck source=/dev/null
[[ -f "$CONFIG" ]] && source "$CONFIG"   # written as ": ${VAR:=value}", so env vars win

HF_REPO="${HF_REPO:-unsloth/Qwen3.6-35B-A3B-GGUF}"
QUANT="${QUANT:-UD-Q4_K_XL}"
ALIAS="${ALIAS:-qwen3.6-35b-a3b}"
PORT="${PORT:-8181}"          # not 8080, which Terra sidecar services may hold
CTX="${CTX:-65536}"            # Qwen3.6's hybrid attention keeps KV small; 64K is cheap
N_CPU_MOE="${N_CPU_MOE:-24}"   # leading layers whose MoE experts stay in CPU RAM; `tune` refines
HARNESS="${HARNESS:-pi}"       # pi | opencode | both
THINK="${THINK:-1}"            # 1 = Qwen thinking mode (better plans), 0 = faster, no <think> tokens
LLAMA_CPP_REF="${LLAMA_CPP_REF:-master}"

SRC="$LLM_HOME/src/llama.cpp"
PREBUILT_DIR="${PREBUILT_DIR:-/opt/llama/bin}"   # set by the t4-coder Docker image
if [[ -x "$PREBUILT_DIR/llama-server" && "${FROM_SOURCE:-0}" != 1 ]]; then
  BIN="$PREBUILT_DIR"
else
  BIN="$SRC/build/bin"
fi
MODEL_DIR="$LLM_HOME/models/$(basename "$HF_REPO")"
LOG_DIR="$LLM_HOME/logs"
PIDFILE="$LLM_HOME/llama-server.pid"
NODE_DIR="$HOME/.local/node"
VENV="$LLM_HOME/venv"

log()  { printf '\033[1;34m[t4-coder]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[t4-coder] WARNING:\033[0m %s\n' "$*" >&2; }
die()  { printf '\033[1;31m[t4-coder] ERROR:\033[0m %s\n' "$*" >&2; exit 1; }

save_config() {
  mkdir -p "$LLM_HOME"
  {
    for v in HF_REPO QUANT ALIAS PORT CTX N_CPU_MOE HARNESS THINK; do
      printf ': "${%s:=%s}"\n' "$v" "${!v}"
    done
  } > "$CONFIG"
}

model_path() {
  find "$MODEL_DIR" -name "*${QUANT}*.gguf" ! -name '*mmproj*' 2>/dev/null | sort | head -1
}

# ---------------------------------------------------------------- checks
preflight() {
  command -v nvidia-smi >/dev/null || die "nvidia-smi not found; is the GPU attached to this environment?"
  local gpu; gpu=$(nvidia-smi --query-gpu=name,memory.total --format=csv,noheader | head -1)
  log "GPU: $gpu"
  [[ "$gpu" == *T4* ]] || warn "Not a T4; CUDA arch is set to 75 below, change CMAKE_CUDA_ARCHITECTURES if needed."

  local ram_gb disk_gb
  ram_gb=$(awk '/MemTotal/ {printf "%d", $2/1024/1024}' /proc/meminfo)
  mkdir -p "$LLM_HOME"
  disk_gb=$(df -BG --output=avail "$LLM_HOME" | tail -1 | tr -dc '0-9')
  log "RAM: ${ram_gb} GB, free disk under $LLM_HOME: ${disk_gb} GB"
  (( ram_gb >= 30 )) || warn "Under 30 GB RAM; offloaded experts plus page cache will be tight. 52 GB recommended."
  (( disk_gb >= 40 )) || die "Need ~40 GB free for the build and the 22 GB model."
}

find_nvcc() {
  for c in "$(command -v nvcc 2>/dev/null || true)" /usr/local/cuda/bin/nvcc /usr/local/cuda-12.8/bin/nvcc; do
    [[ -n "$c" && -x "$c" ]] && { echo "$c"; return 0; }
  done
  return 1
}

# ---------------------------------------------------------------- install steps
install_apt_deps() {
  log "Installing build dependencies (sudo apt)…"
  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq \
    build-essential cmake git curl ca-certificates pciutils xz-utils \
    libcurl4-openssl-dev libssl-dev python3 python3-venv python3-pip jq
}

ensure_cuda_toolkit() {
  if NVCC=$(find_nvcc); then
    log "nvcc: $NVCC ($("$NVCC" --version | grep -o 'release [0-9.]*'))"
    return
  fi
  warn "Driver present but no nvcc; installing cuda-toolkit-12-8 from NVIDIA's apt repo."
  . /etc/os-release
  local repo="ubuntu${VERSION_ID//./}"
  curl -fsSL -o /tmp/cuda-keyring.deb \
    "https://developer.download.nvidia.com/compute/cuda/repos/${repo}/x86_64/cuda-keyring_1.1-1_all.deb"
  sudo dpkg -i /tmp/cuda-keyring.deb
  sudo apt-get update -qq
  # 12.8 matches the driver; avoid CUDA 13.2 (Unsloth reports gibberish output with Qwen3.6)
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq cuda-toolkit-12-8
  NVCC=$(find_nvcc) || die "nvcc still not found after installing cuda-toolkit-12-8."
}

build_llama_cpp() {
  mkdir -p "$(dirname "$SRC")"
  if [[ -d "$SRC/.git" ]]; then
    log "Updating llama.cpp…"
    git -C "$SRC" fetch -q --all --tags
  else
    log "Cloning llama.cpp…"
    git clone -q https://github.com/ggml-org/llama.cpp "$SRC"
  fi
  git -C "$SRC" checkout -q "$LLAMA_CPP_REF"
  [[ "$LLAMA_CPP_REF" == master ]] && git -C "$SRC" pull -q --ff-only

  log "Building llama.cpp for sm_75 (takes ~10-20 min on a few vCPUs)…"
  local cuda_bin; cuda_bin=$(dirname "$NVCC")
  export PATH="$cuda_bin:$PATH"
  cmake -S "$SRC" -B "$SRC/build" \
    -DCMAKE_BUILD_TYPE=Release \
    -DGGML_CUDA=ON \
    -DCMAKE_CUDA_ARCHITECTURES=75 \
    -DCMAKE_CUDA_COMPILER="$NVCC" \
    -DBUILD_SHARED_LIBS=OFF > "$LOG_DIR/cmake.log"
  cmake --build "$SRC/build" --config Release -j "$(nproc)" \
    --target llama-server llama-cli llama-bench > "$LOG_DIR/build.log" 2>&1 \
    || die "Build failed; see $LOG_DIR/build.log"
  log "Built: $BIN/llama-server"
}

download_model() {
  if [[ -n "$(model_path)" ]]; then
    log "Model already present: $(model_path)"
    return
  fi
  local hf
  if command -v hf >/dev/null; then
    hf=$(command -v hf)
  else
    log "Setting up huggingface_hub in $VENV…"
    [[ -x "$VENV/bin/hf" ]] || {
      python3 -m venv "$VENV"
      PIP_USER=0 "$VENV/bin/pip" install -q -U "huggingface_hub[hf_xet]"   # Terra sets PIP_USER=true
    }
    hf="$VENV/bin/hf"
  fi
  log "Downloading $HF_REPO ($QUANT, ~22 GB; resumable if interrupted)…"
  mkdir -p "$MODEL_DIR"
  "$hf" download "$HF_REPO" --local-dir "$MODEL_DIR" --include "*${QUANT}*"
  [[ -n "$(model_path)" ]] || die "Download finished but no *${QUANT}*.gguf found in $MODEL_DIR"
  log "Model: $(model_path)"
}

node_ok() {  # Pi needs Node >= 22.19
  command -v node >/dev/null && node -e '
    const [a, b] = process.versions.node.split(".").map(Number);
    process.exit(a > 22 || (a === 22 && b >= 19) ? 0 : 1)'
}

ensure_node() {
  # Private Node under ~/.local so `npm -g` never needs sudo, whatever the image ships
  if [[ ! -x "$NODE_DIR/bin/node" ]]; then
    log "Installing Node 22 LTS into $NODE_DIR…"
    local tarball
    tarball=$(curl -fsSL https://nodejs.org/dist/latest-v22.x/SHASUMS256.txt \
              | awk '/linux-x64.tar.xz/ {print $2}')
    mkdir -p "$NODE_DIR"
    curl -fsSL "https://nodejs.org/dist/latest-v22.x/$tarball" | tar -xJ -C "$NODE_DIR" --strip-components=1
  fi
  export PATH="$NODE_DIR/bin:$PATH"
  # Must go at the FRONT of PATH so it beats an older system Node
  for rc in "$HOME/.bashrc" "$HOME/.profile"; do
    grep -q "$NODE_DIR/bin" "$rc" 2>/dev/null \
      || echo "export PATH=\"$NODE_DIR/bin:\$PATH\"" >> "$rc"
  done
}

install_pi() {
  if command -v pi >/dev/null && node_ok; then
    log "Pi already installed: $(command -v pi) (Node $(node --version))"
  else
    ensure_node
    log "Installing Pi coding agent…"
    npm install -g --ignore-scripts @earendil-works/pi-coding-agent \
      || npm install -g @mariozechner/pi-coding-agent
  fi
  log "Writing Pi provider config (~/.pi/agent/models.json)…"
  mkdir -p "$HOME/.pi/agent"
  python3 - "$ALIAS" "$PORT" <<'PY'
import json, os, shutil, sys
alias, port = sys.argv[1], sys.argv[2]
p = os.path.expanduser("~/.pi/agent/models.json")
d = {}
if os.path.exists(p):
    shutil.copy(p, p + ".bak")
    d = json.load(open(p))
d.setdefault("providers", {})["llama-cpp"] = {
    "baseUrl": f"http://127.0.0.1:{port}/v1",
    "api": "openai-completions",
    "apiKey": "none",
    "models": [{"id": alias}],
}
json.dump(d, open(p, "w"), indent=2)
PY
}

install_opencode() {
  if ! command -v opencode >/dev/null && [[ ! -x "$HOME/.opencode/bin/opencode" ]]; then
    log "Installing OpenCode…"
    curl -fsSL https://opencode.ai/install | bash
  fi
  log "Writing OpenCode provider config (~/.config/opencode/opencode.json)…"
  mkdir -p "$HOME/.config/opencode"
  python3 - "$ALIAS" "$PORT" "$CTX" <<'PY'
import json, os, shutil, sys
alias, port, ctx = sys.argv[1], sys.argv[2], int(sys.argv[3])
p = os.path.expanduser("~/.config/opencode/opencode.json")
d = {"$schema": "https://opencode.ai/config.json"}
if os.path.exists(p):
    shutil.copy(p, p + ".bak")
    d = json.load(open(p))
d.setdefault("provider", {})["llama.cpp"] = {
    "npm": "@ai-sdk/openai-compatible",
    "name": "llama-server (local T4)",
    "options": {"baseURL": f"http://127.0.0.1:{port}/v1"},
    "models": {alias: {"name": "Qwen3.6 35B-A3B (local)",
                       "limit": {"context": ctx, "output": 16384}}},
}
d.setdefault("model", f"llama.cpp/{alias}")
json.dump(d, open(p, "w"), indent=2)
PY
}

cmd_install() {
  require_tools curl python3
  mkdir -p "$LOG_DIR"
  preflight
  if [[ "$BIN" == "$PREBUILT_DIR" ]]; then
    log "Using prebuilt llama.cpp from the image: $BIN (FROM_SOURCE=1 to build instead)"
  elif [[ -x "$BIN/llama-server" && "${REBUILD:-0}" != 1 ]]; then
    log "llama-server already built (REBUILD=1 to force)."
  else
    install_apt_deps
    ensure_cuda_toolkit
    build_llama_cpp
  fi
  download_model
  case "$HARNESS" in
    pi)       install_pi ;;
    opencode) install_opencode ;;
    both)     install_pi; install_opencode ;;
    *)        die "HARNESS must be pi, opencode or both" ;;
  esac
  save_config
  log "Install done. If pi/opencode were installed just now, open a new terminal (or: source ~/.bashrc)."
  log "Next: ./t4-coder.sh tune   then ./t4-coder.sh start   then run pi (or opencode) in your repo."
}

# ---------------------------------------------------------------- server
server_cmd() {  # $1 = port, $2 = n-cpu-moe
  local mp; mp=$(model_path); [[ -n "$mp" ]] || die "Model not found; run install first."
  SERVER_CMD=(
    "$BIN/llama-server"
    -m "$mp" --alias "$ALIAS"
    --host 127.0.0.1 --port "$1"
    -ngl 99 --n-cpu-moe "$2"
    -c "$CTX" -np 1 -fa on --jinja
  )
  if [[ "$THINK" == 1 ]]; then
    # Qwen3.6 thinking-mode sampling for precise coding (Qwen/Unsloth recommendation)
    SERVER_CMD+=(--temp 0.6 --top-p 0.95 --top-k 20 --min-p 0.0)
  else
    SERVER_CMD+=(--temp 0.7 --top-p 0.8 --top-k 20 --min-p 0.0 --presence-penalty 1.5
                 --chat-template-kwargs '{"enable_thinking":false}')
  fi
}

wait_healthy() {  # $1 = port, $2 = pid, $3 = timeout seconds
  local t=0
  until curl -fsS "http://127.0.0.1:$1/health" >/dev/null 2>&1; do
    kill -0 "$2" 2>/dev/null || return 1
    (( t >= $3 )) && return 1
    sleep 3; t=$((t + 3))
  done
}

# The pidfile lives on the persistent disk and can outlive the container, so check
# that the PID is really our llama-server, not an unrelated process that reused it.
require_tools() {
  local missing=()
  for t in "$@"; do command -v "$t" >/dev/null || missing+=("$t"); done
  (( ${#missing[@]} == 0 )) || die "Missing required tools: ${missing[*]}. Install with: sudo apt-get install -y ${missing[*]}"
}

is_running() {
  [[ -f "$PIDFILE" ]] || return 1
  local pid; pid=$(cat "$PIDFILE")
  if kill -0 "$pid" 2>/dev/null && [[ "$(cat "/proc/$pid/comm" 2>/dev/null)" == llama-server* ]]; then
    return 0
  fi
  rm -f "$PIDFILE"   # stale
  return 1
}

cmd_start() {
  require_tools curl
  is_running && { log "Already running (pid $(cat "$PIDFILE"))."; return; }
  mkdir -p "$LOG_DIR"
  "$BIN/llama-server" --version >/dev/null 2>&1 \
    || die "llama-server won't run (missing CUDA libs after an environment rebuild?). Re-run: ./t4-coder.sh install"
  if ! command -v nvidia-smi >/dev/null || ! nvidia-smi -L >/dev/null 2>&1; then
    warn "No working nvidia-smi: the NVIDIA driver libraries are missing or mismatched, so llama.cpp"
    warn "would run on CPU only. Install libnvidia-compute-580 + nvidia-utils-580 (matching the host driver)."
    [[ "${ALLOW_CPU:-0}" == 1 ]] || die "Refusing to start without a GPU (ALLOW_CPU=1 to override)."
  fi
  server_cmd "$PORT" "$N_CPU_MOE"
  log "Starting llama-server on :$PORT (n-cpu-moe=$N_CPU_MOE, ctx=$CTX, think=$THINK)…"
  setsid nohup "${SERVER_CMD[@]}" > "$LOG_DIR/llama-server.log" 2>&1 < /dev/null &
  echo $! > "$PIDFILE"
  if wait_healthy "$PORT" "$(cat "$PIDFILE")" 600; then
    log "Ready: http://127.0.0.1:$PORT/v1  (model id: $ALIAS)"
    nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader | sed 's/^/[t4-coder] VRAM: /'
  else
    tail -20 "$LOG_DIR/llama-server.log" >&2
    die "Server failed to start. If it's out of memory, raise N_CPU_MOE (e.g. N_CPU_MOE=28 ./t4-coder.sh start)."
  fi
}

cmd_stop() {
  if is_running; then kill "$(cat "$PIDFILE")"; rm -f "$PIDFILE"; log "Stopped."
  else log "Not running."; fi
}

cmd_status() {
  if is_running; then
    log "Running, pid $(cat "$PIDFILE"); health: $(curl -fsS "http://127.0.0.1:$PORT/health" 2>/dev/null || echo 'loading/unreachable')"
  else log "Not running."; fi
  nvidia-smi --query-gpu=memory.used,memory.total,utilization.gpu --format=csv,noheader
  [[ -f "$LOG_DIR/llama-server.log" ]] && tail -5 "$LOG_DIR/llama-server.log"
}

# ---------------------------------------------------------------- tuning
cmd_tune() {
  require_tools curl jq python3
  is_running && die "Stop the main server first (./t4-coder.sh stop); tuning needs the whole GPU."
  local candidates tport=8191 best="" best_tg=0
  read -r -a candidates <<<"${TUNE_VALUES:-16 20 24 28 32}"
  mkdir -p "$LOG_DIR"
  # ~2K-token prompt so prefill speed is measured too; agent loops are prefill-heavy
  local payload
  payload=$(python3 -c '
import json
code = "def f(x):\n    return [i * x for i in range(10) if i % 2 == 0]\n" * 120
print(json.dumps({"prompt": "Review this code and suggest improvements:\n" + code,
                  "n_predict": 128, "temperature": 0, "cache_prompt": False}))')
  printf '%-10s %-12s %-12s %-14s\n' n-cpu-moe "prefill t/s" "decode t/s" "VRAM used"
  for n in "${candidates[@]}"; do
    server_cmd "$tport" "$n"
    "${SERVER_CMD[@]}" > "$LOG_DIR/tune-$n.log" 2>&1 &
    local pid=$!
    if ! wait_healthy "$tport" "$pid" 600; then
      kill "$pid" 2>/dev/null || true; wait "$pid" 2>/dev/null || true
      printf '%-10s %s\n' "$n" "failed to load (likely OOM; see $LOG_DIR/tune-$n.log)"
      continue
    fi
    local vram res pp tg
    vram=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader | head -1)
    res=$(curl -fsS "http://127.0.0.1:$tport/completion" -H 'Content-Type: application/json' -d "$payload" || echo '{}')
    pp=$(jq -r '.timings.prompt_per_second // 0 | floor' <<<"$res")
    tg=$(jq -r '.timings.predicted_per_second // 0 | . * 10 | floor / 10' <<<"$res")
    kill "$pid" 2>/dev/null || true; wait "$pid" 2>/dev/null || true
    printf '%-10s %-12s %-12s %-14s\n' "$n" "$pp" "$tg" "$vram"
    if python3 -c "import sys; sys.exit(0 if float('$tg') > float('$best_tg') else 1)"; then
      best=$n; best_tg=$tg
    fi
  done
  [[ -n "$best" ]] || die "No setting loaded. Try TUNE_VALUES=\"32 36 40\" or CTX=32768."
  # Step one notch toward CPU from the fastest, to leave VRAM headroom as context fills up
  N_CPU_MOE=$(( best + 2 ))
  save_config
  log "Fastest was n-cpu-moe=$best (${best_tg} t/s). Saved N_CPU_MOE=$N_CPU_MOE (+2 for context headroom)."
  log "Next: ./t4-coder.sh start"
}

case "${1:-}" in
  install) cmd_install ;;
  tune)    cmd_tune ;;
  start)   cmd_start ;;
  stop)    cmd_stop ;;
  status)  cmd_status ;;
  *) sed -n '2,20p' "$0"; exit 1 ;;
esac
