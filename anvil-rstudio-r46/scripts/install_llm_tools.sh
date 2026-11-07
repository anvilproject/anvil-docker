#!/bin/bash
# install_llm_tools.sh — tools for local agentic coding (t4-coder) on terra-base images.
#
# Expects llama.cpp to have been copied to /opt/llama/bin by the Dockerfile's build stage.
# Installs: Node 22 (terra-base ships Node 20; Pi needs >= 22.19), Pi and OpenCode agents,
# the Hugging Face `hf` CLI, jq/python3 for t4-coder, and /usr/local/bin links so
# everything is on PATH in RStudio terminals (which don't inherit Docker ENV PATH).
set -euo pipefail

# NB: terra-base sets ENV NODE_MAJOR=20 and PIP_USER=true; use our own names/overrides
LLM_NODE_MAJOR="${LLM_NODE_MAJOR:-22}"
PI_VERSION="${PI_VERSION:-}"              # empty = latest
OPENCODE_VERSION="${OPENCODE_VERSION:-}"  # empty = latest

## curl/gnupg first: install_R_source.sh purges curl as a build dependency,
## and both are needed to fetch the NodeSource key below (and by t4-coder at runtime)
apt-get update
apt-get install -y --no-install-recommends curl ca-certificates gnupg

## Node 22 from NodeSource (replaces terra-base's node_20 repo entry)
mkdir -p /etc/apt/keyrings
[ -s /etc/apt/keyrings/nodesource.gpg ] || \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key \
    | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_${LLM_NODE_MAJOR}.x nodistro main" \
  > /etc/apt/sources.list.d/nodesource.list

apt-get update
apt-get install -y --no-install-recommends nodejs jq python3 python3-venv
echo "node $(node --version), npm $(npm --version)"
# Pi needs Node >= 22.19; fail the build here rather than at runtime
node -e 'const [a,b]=process.versions.node.split(".").map(Number); process.exit(a>22||(a===22&&b>=19)?0:1)' \
  || { echo "ERROR: Node $(node --version) is too old for Pi (need >= 22.19)" >&2; exit 1; }

## Coding agents (global npm prefix is /usr, so these land in /usr/bin)
npm install -g --ignore-scripts "@earendil-works/pi-coding-agent${PI_VERSION:+@$PI_VERSION}"
npm install -g "opencode-ai${OPENCODE_VERSION:+@$OPENCODE_VERSION}"   # postinstall fetches its binary
pi --version || true
opencode --version || true

## Hugging Face CLI for model downloads, in its own venv
python3 -m venv /opt/hf
PIP_USER=0 /opt/hf/bin/pip install --no-cache-dir -U "huggingface_hub[hf_xet]"
ln -sf /opt/hf/bin/hf /usr/local/bin/hf

## llama.cpp: link the executables onto PATH. Backends (libggml-cuda.so, CPU variants)
## are found next to the real binary in /opt/llama/bin, so symlinks are fine.
for b in llama-server llama-cli llama-bench; do
  if [ -x "/opt/llama/bin/$b" ]; then ln -sf "/opt/llama/bin/$b" "/usr/local/bin/$b"; fi
done
chmod 755 /usr/local/bin/t4-coder

## Sanity checks. No GPU at build time, so the only unresolved library
## should be libcuda.so.1, which Terra mounts from the host at runtime.
/opt/llama/bin/llama-server --version || true
echo "Unresolved libraries for the CUDA backend (expect only libcuda.so.1):"
ldd /opt/llama/bin/libggml-cuda.so | grep 'not found' || echo "  (none)"

## Clean up
npm cache clean --force
apt-get clean
rm -rf /var/lib/apt/lists/* /root/.npm /tmp/*
