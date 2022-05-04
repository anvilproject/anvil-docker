#!/bin/bash
set -e

# This script needs to be separated from the Dockerfile because we mount persistent disks in the
# /home/rstudio directory and when we mount the PD, everything in that directory gets wiped.
# Therefore, we will run this script from Leonardo after the PD is mounted

RSTUDIO_USER_HOME=/home/rstudio
R_PATH=`Rscript -e "cat(Sys.getenv('R_LIBS_USER'))"`
# R_PATH=`R CMD printenv R_LIBS_USER | sed 's/~\///g'`
BIOCONDUCTOR_VERSION=`printenv BIOCONDUCTOR_DOCKER_VERSION | sed 's/\(^[0-9].[0-9][0-9]\).*/\1/g'`
R_PACKAGE_DIR=${RSTUDIO_USER_HOME}/${R_PATH}-${BIOCONDUCTOR_VERSION}

sudo -E -u rstudio mkdir -p ${R_PACKAGE_DIR}

echo R_LIBS=${R_PACKAGE_DIR} >> /usr/local/lib/R/etc/Renviron.site
