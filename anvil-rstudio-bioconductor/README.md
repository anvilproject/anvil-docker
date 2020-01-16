| RStudio-Bioconductor Version | Date Updated | Questions or Feedback |
| --- | --- | --- |
| 0.0.2 | 10/06/2019 | Adrian Sharma: adrian@broadinstitute.org |

# RStudio-Bioconductor Docker Image

[Rstudio](https://rstudio.com/products/rstudio/) is an integrated development environment to support the R statistical programming language. The AnVIL RStudio Bioconductor Docker is an RStudio environment that supports [Bioconductor](https://www.bioconductor.org/), an open source software that supports bioinformatic analyses. The RStudio Bioconductor Docker is based off the AnVIL RStudio Docker, a version-tagged image of RStudio, providing consistent RStudio software, packages, and dependencies with every use. This document describes the [RStudio Bioconductor] Docker Image and how to use it in the cloud-based platform [Terra](app.terra.bio). Unlike the currently existing [Terra base images](https://github.com/DataBiosphere/terra-docker#terra-base-images), RStudio is not hosted in a Jupyter Notebook; any work performed in Terra RStudio will not be saved. At the end of this document, you will find Instructions and suggestions for saving RStudio data and code. 

## Table of Contents
- [RStudio Docker Contents](#rstudio-docker-contents)
  * [Accessing the AnVIL RStudio Image](#accessing-the-anvil-rstudio-bioconductor-image)
  * [Base Image](#base-image)
  * [Applications](#applications)
  * [Libraries](#libraries)
  * [Customizations](#customizations)
- [RStudio Bioconductor Contents](#anvil-rstudio-bioconductor-docker-contents)
  * [System Dependencies](#system-dependencies)
  * [Biconductor Dependencies](#bioconductor-dependencies)
  * [Perl Dependencies](#perl-dependencies)
  * [Python Dependencies](#python-dependencies)
  * [Additional Dependencies](#additional-dependencies)
  * [Databases and Other Software](#databases-and-other-software)  
- [Using R Studio in Terra](#using-r-studio-in-terra)
- [Saving RStudio Data](#saving-rstudio-data)
- [Versioning](#versioning)

### Accessing the AnVIL RStudio Bioconductor Image

The AnVIL Rstudio Bioconductor Image can be accessed using the following URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-base. 

### Base Image

The base image for the AnVIL RStudio Bioconductor Docker is the [rocker/tidyverse](https://hub.docker.com/r/rocker/tidyverse/) image provided by the [Rocker Project](https://www.rocker-project.org/). This image additionally contains tidyverse and devtools.

### Applications

The AnVIL R Docker contains the [RStudio Server](https://www.rstudio.com/products/rstudio-server/) application which supports a web browser version of RStudio. Additionally, it contains all system dependencies for Bioconductor packages.

### Libraries
The Bioconductor image inherits all libraries from `anvil-rstudio-base`. The following packages are included in the base image:
* [tidyverse](https://www.tidyverse.org/packages/): a suite of packages designed for data sciences 
* [google-cloud-sdk](https://cloud.google.com/sdk/): tools for the google cloud platform
* [googleCloudStorageR](http://code.markedmondson.me/googleCloudStorageR/): an R library for interacting with google cloud storage
* [bigrquery](https://github.com/r-dbi/bigrquery): a package to allow interaction with Google's BigQuery
* [DataBiosphere/Ronaldo](https://github.com/DataBiosphere/Ronaldo): a package of functions commonly used for R Notebooks created from Leonardo

The following are Bioconductor-specific packages:
* [BiocManager](https://www.bioconductor.org/install/): a tool for installing Bioconductor packages
* SingleCellExperiment
* GenomicFeatures
* GenomicAlignments
* ShortRead
* DESeq2
* AnnotationHub
* ExperimentHub
* ensembldb
* scRNAseq
* scran
* Rtsne

### Customizations

The AnVIL RStudio image is customized to disable the RStudio login screen. Future customizations will include:

* RStudio hooks to refresh credentials 
* An RStudio pause after inactivity


## AnVIL RStudio Bioconductor Docker Contents

### System Dependencies
* fortran77-compiler
* byacc
* automake
* libpng-dev
* libnetcdf-dev
* libhdf5-serial-dev
* libfftw3-dev
* libopenbabel-dev
* libopenmpi-dev
* libexempi3
* libxt-dev
* libgdal-dev
* libjpeg62-turbo-dev
* libtiff5-dev
* libreadline-dev
* libgsl0-dev
* libgsl2
* libgtk2.0-dev
* libgl1-mesa-dev
* libglu1-mesa-dev
* libgmp3-dev
* libhdf5-dev
* libncurses-dev
* libbz2-dev
* libxpm-dev
* liblapack-dev
* libv8-3.14-dev
* libgtkmm-2.4-dev
* libmpfr-dev
* libudunits2-dev
* libmodule-build-perl
* libapparmor-dev
* libgeos-dev
* libprotoc-dev
* librdf0-dev
* libmagick++-dev
* libpoppler-cpp-dev
* libprotobuf-dev
* libperl-dev
* libz-dev
* liblzma-dev

### Bioconductor Dependencies
* libsbml
* xvfb

### Perl Dependencies
* libarchive-extract-perl
* libfile-copy-recursive-perl
* libcgi-pm-perl
* libdbi-perl
* libdbd-mysql-perl
* libxml-simple-perl

### Python Dependencies
* python-dev
* sklearn
* pandas
* pyyaml
* cwltool

### Additional dependencies
* xfonts-100dpi
* xfonts-75dpi
* biber

### Databases and Other Software
* sqlite
* openmpi-bin
* mpi-default-bin
* openmpi-common
* openmpi-doc
* tcl8.5-dev
* tk-dev
* openjdk-8-jdk
* imagemagick
* tabix
* ggobi
* graphviz
* protobuf-compiler
* jags


## Using RStudio in Terra

Detailed instructions on accessing the AnVIL RStudio image can be found in the "[Working with project-specific images](https://broadinstitute.zendesk.com/knowledge/articles/360037269472)" documentation in Terra support.

## Saving RStudio Data

Code and data generated in Terra RStudio will not be saved. Below are three suggestions for saving your work.

### 1. Copying RStudio work to a workspace google bucket

Use the [gsutil](https://cloud.google.com/storage/docs/gsutil) tool to copy files to your workspace google bucket. The "[Working with project-specific images](https://broadinstitute.zendesk.com/knowledge/articles/360037269472)" documentation in Terra support demonstrates how to identify the url for a workspace google bucket. After identifying the workspace google bucket url, you can copy files to a google bucket using the bash command: 

    !gsutil cp ./* gs://GoogleBucketURL

### 2. Downloading RStudio files to your local computer
Once your files are copied to workspace google bucket, you can access them by selecting the Data tab of the workspace and choosing the Files option on bottom left. This will display the files available in your google bucket. By selecting a file, you can download it directly. Additionally, [this Terra support document](https://support.terra.bio/hc/en-us/articles/360029251091-Broad-Genomics-Downloading-data-from-a-Terra-workspace) details alternative techniques you can use to download data files. 

### 3. Checking code into GitHub
You can install Git on RStudio and use it to [check code into GitHub](https://help.github.com/en/github/importing-your-projects-to-github). 

## Versioning

All updates and changes to the current Docker image are listed in the Rstudio image [CHANGELOG.md file](CHANGELOG.md). 

