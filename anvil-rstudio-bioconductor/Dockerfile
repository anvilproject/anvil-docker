FROM ghcr.io/bioconductor/ml-verse:3.20 as build

RUN apt-get update && apt-get install -yq --no-install-recommends \
    gnupg \
    lsb-release \
 && echo "deb http://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
 && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
 && apt-get update \
 && apt-get install -yq --no-install-recommends \
    google-cloud-sdk \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 -V \
    && pip3 install --no-cache-dir -U crcmod terra-notebook-utils torch

# add rstudio user to users group
RUN usermod -g users rstudio \
    && useradd -m -s /bin/bash -N --non-unique -u 1001 welder-user

# google-cloud R packages
RUN R -e "BiocManager::install(c('AnVIL', 'DataBiosphere/Ronaldo', 'shiny', 'bigrquery', 'googleCloudStorageR', 'tidyverse', 'Seurat', 'markdown', 'SingleCellExperiment', 'GenomicFeatures', 'GenomicAlignments', 'ShortRead', 'DESeq2', 'AnnotationHub', 'ExperimentHub', 'ensembldb', 'scRNAseq', 'scran', 'Rtsne'))"

ENV RSTUDIO_PORT 8001
ENV RSTUDIO_HOME /etc/rstudio
ENV RSTUDIO_USERSETTING /home/rstudio/.config/rstudio/rstudio-prefs.json

ADD rserver.conf $RSTUDIO_HOME/rserver.conf

RUN sed -i 's/"always_save_history": false/"always_save_history": true/g'  $RSTUDIO_USERSETTING \
 && sed -i 's/"save_workspace": "never"/"save_workspace": "always"/g' $RSTUDIO_USERSETTING

EXPOSE $RSTUDIO_PORT

COPY scripts ${RSTUDIO_HOME}/scripts

RUN find ${RSTUDIO_HOME}/scripts -name '*.sh' -type f | xargs chmod +x \
 && echo "PIP_USER=true" >>  /usr/local/lib/R/etc/Renviron.site

RUN apt-get clean && rm -rf /var/lib/apt/lists/* && \
    usermod -o -u 1000 rstudio && \
    find / \( -path /proc -o -path /sys -o -path /dev \) -prune -o -user 1001 -exec chown -h 1000 {} \;


FROM ghcr.io/bioconductor/ml-verse:3.20 as final
COPY --from=build / /

ENV RSTUDIO_PORT 8001
ENV RSTUDIO_HOME /etc/rstudio
ENV RSTUDIO_USERSETTING /home/rstudio/.config/rstudio/rstudio-prefs.json
