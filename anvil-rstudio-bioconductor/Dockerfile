FROM bioconductor/bioconductor_docker:RELEASE_3_16

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
    && pip3 install --no-cache-dir -U crcmod

# add rstudio user to users group
RUN usermod -g users rstudio \
    && useradd -m -s /bin/bash -N -u 1001 welder-user

# google-cloud R packages
RUN R -e "BiocManager::install(c('AnVIL', 'DataBiosphere/Ronaldo', 'shiny', 'bigrquery', 'googleCloudStorageR', 'tidyverse', 'Seurat'))"

ENV RSTUDIO_PORT 8001
ENV RSTUDIO_HOME /etc/rstudio
ENV RSTUDIO_USERSETTING /home/rstudio/.rstudio/monitored/user-settings/user-settings

ADD rserver.conf $RSTUDIO_HOME/rserver.conf

RUN sed -i 's/alwaysSaveHistory="0"/alwaysSaveHistory="1"/g'  $RSTUDIO_USERSETTING \
 && sed -i 's/loadRData="0"/loadRData="1"/g' $RSTUDIO_USERSETTING \
 && sed -i 's/saveAction="0"/saveAction="1"/g' $RSTUDIO_USERSETTING

EXPOSE $RSTUDIO_PORT

COPY scripts ${RSTUDIO_HOME}/scripts
RUN find ${RSTUDIO_HOME}/scripts -name '*.sh' -type f | xargs chmod +x \
 && echo "PIP_USER=true" >>  /usr/local/lib/R/etc/Renviron.site
