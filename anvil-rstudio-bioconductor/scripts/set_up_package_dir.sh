#!/bin/bash
set -e

RSTUDIO_USER_HOME=/home/rstudio
R_PATH=`R CMD printenv R_LIBS_USER | sed 's/~\///g'`
BIOCONDUCTOR_VERSION=`printenv BIOCONDUCTOR_DOCKER_VERSION | sed 's/\(^[0-9].[0-9][0-9]\).*/\1/g'`
R_PACKAGE_DIR=${RSTUDIO_USER_HOME}/${R_PATH}-${BIOCONDUCTOR_VERSION}

mkdir -p ${R_PACKAGE_DIR}
chmod a+rwx ${R_PACKAGE_DIR}

echo R_LIBS=${R_PACKAGE_DIR} >> /usr/local/lib/R/etc/Renviron.site
