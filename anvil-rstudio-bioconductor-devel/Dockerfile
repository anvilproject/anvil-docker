FROM bioconductor/bioconductor_docker:devel

ARG TERRA_R_PLATFORM=bioconductor-docker
ARG TERRA_R_PLATFORM_BINARY_VERSION=0.99.1

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

# google-cloud R packages
RUN R -e "BiocManager::install(c('DataBiosphere/Ronaldo', 'shiny', 'bigrquery', 'googleCloudStorageR', 'tidyverse'))"

ENV RSTUDIO_PORT 8001
ENV RSTUDIO_HOME /etc/rstudio
ENV TERRA_R_PLATFORM=$TERRA_R_PLATFORM
ENV TERRA_R_PLATFORM_BINARY_VERSION=$TERRA_R_PLATFORM_BINARY_VERSION
ENV RSTUDIO_USERSETTING /home/rstudio/.rstudio/monitored/user-settings/user-settings

ADD rserver.conf $RSTUDIO_HOME/rserver.conf

RUN sed -i 's/alwaysSaveHistory="0"/alwaysSaveHistory="1"/g'  $RSTUDIO_USERSETTING \
 && sed -i 's/loadRData="0"/loadRData="1"/g' $RSTUDIO_USERSETTING \
 && sed -i 's/saveAction="0"/saveAction="1"/g' $RSTUDIO_USERSETTING

EXPOSE $RSTUDIO_PORT

RUN echo "R_LIBS='/home/rstudio/packages'" >>  /usr/local/lib/R/etc/Renviron.site \
 && echo "PIP_USER=true" >>  /usr/local/lib/R/etc/Renviron.site \
 && echo TERRA_R_PLATFORM=${TERRA_R_PLATFORM} >> /usr/local/lib/R/etc/Renviron.site \
 && echo TERRA_R_PLATFORM_BINARY_VERSION=${TERRA_R_PLATFORM_BINARY_VERSION} >> /usr/local/lib/R/etc/Renviron.site
