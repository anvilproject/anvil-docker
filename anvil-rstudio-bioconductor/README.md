| Latest Image Release | Docker Image URL |Date Updated | Questions or Feedback | 
| --- | --- | --- | --- |
| 0.0.3 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.3 | 12/11/2019 | Contact the [Bioconductor Team](mailto:nitesh.turaga@roswellpark.org) |

# RStudio-Bioconductor Docker Image

[Rstudio](https://rstudio.com/products/rstudio/) is an integrated development environment to support the R statistical programming language. The AnVIL RStudio Bioconductor Docker is an RStudio environment that supports [Bioconductor](https://www.bioconductor.org/), an open source software for bioinformatic analyses. The RStudio Bioconductor Docker is based off the AnVIL RStudio Docker, a version-tagged image of RStudio, providing consistent RStudio software, packages, and dependencies with every use. This document describes the RStudio Bioconductor Docker Image and how to use it in the cloud-based platform [Terra](app.terra.bio). Unlike the currently existing [Terra base images](https://github.com/DataBiosphere/terra-docker#terra-base-images), RStudio is not hosted in a Jupyter Notebook; any work performed in Terra RStudio will not be saved to a workspace google bucket. This document provides instructions and resources for saving RStudio data and code. 

## Table of Contents
- [Accessing the AnVIL RStudio Bioconductor Image](#accessing-the-anvil-rstudio-bioconductor-image)
- [Using RStudio in Terra](#using-rstudio-in-terra)
  * [Saving RStudio Data](#saving-rstudio-data)
    + [1. Copying RStudio work to a workspace google bucket](#1-copying-rstudio-work-to-a-workspace-google-bucket)
    + [2. Downloading RStudio files to your local computer](#2-downloading-rstudio-files-to-your-local-computer)
    + [3. Checking code into GitHub](#3-checking-code-into-github)
- [RStudio Bioconductor Docker Contents](#rstudio-bioconductor-docker-contents)
    + [Base Image](#base-image)
    + [Applications](#applications)
    + [Libraries](#libraries)
    + [Customizations](#customizations)
    + [Dependencies](#dependencies)
- [RStudio Bioconductor Updates](#rstudio-bioconductor-updates)


# Accessing the AnVIL RStudio Bioconductor Image

The AnVIL Rstudio Bioconductor Image can be accessed using the Docker Image URL specified in the table at the top of this document.

# Using RStudio in Terra

The RStudio Docker can be used in the cloud-based platform Terra. Detailed instructions on accessing the AnVIL RStudio image in Terra can be found in the "[Working with Project-Specific Environments in Terra](https://support.terra.bio/hc/en-us/articles/360037269472)" documentation in Terra support.

## Saving RStudio Data

Unlike in a Terra base Docker image, any work performed in a project-specific Docker (like RStudio) will not be saved to your workspace google bucket. While your code will be saved on the runtime environment, if you delete the runtime (or if your runtime becomes unresponsive), you will lose code. To avoid losing work, make sure to back up your code or save it using the following techniques.

### 1. Copying RStudio work to a workspace google bucket

Use the [gsutil](https://cloud.google.com/storage/docs/gsutil) tool to copy files to your workspace google bucket. The "[Working with Project-Specific Environments in Terra](https://support.terra.bio/hc/en-us/articles/360037269472)" documentation in Terra support demonstrates how to identify the URL for a workspace google bucket. After identifying the workspace google bucket URL, you can copy files to a google bucket by navigating to them in your terminal and using the bash command: 

    gsutil cp ./* gs://<WORKSPACE_BUCKET>

### 2. Downloading RStudio files to your local computer
Once your files are copied to a workspace google bucket, you can access them by selecting the Data tab of the workspace and choosing the Files option on the bottom left. This will display the files available in your google bucket. By selecting a file, you can download it directly. Additionally, [this Terra support document](https://support.terra.bio/hc/en-us/articles/360029251091-Broad-Genomics-Downloading-data-from-a-Terra-workspace) details alternative techniques you can use to download data files. 

### 3. Checking code into GitHub
You can install Git on RStudio and use it to [check code into GitHub](https://help.github.com/en/github/importing-your-projects-to-github). 

# RStudio Bioconductor Docker Contents

### Base Image

The base image for the AnVIL RStudio Bioconductor Docker is the [RStudio Docker](https://github.com/anvilproject/anvil-docker/tree/master/anvil-rstudio-base). This contains the [rocker/tidyverse](https://hub.docker.com/r/rocker/tidyverse/) image provided by the [Rocker Project](https://www.rocker-project.org/), as well as tidyverse and devtools.

### Applications

The AnVIL RStudio Docker contains the [RStudio Server](https://www.rstudio.com/products/rstudio-server/) application which supports a web browser version of RStudio. Additionally, it contains all system dependencies for Bioconductor packages.

### Libraries
The Bioconductor image inherits all libraries from `anvil-rstudio-base`. The following packages are included in the base image:
* [tidyverse](https://www.tidyverse.org/packages/): a suite of packages designed for data sciences 
* [google-cloud-sdk](https://cloud.google.com/sdk/): tools for the google cloud platform
* [googleCloudStorageR](http://code.markedmondson.me/googleCloudStorageR/): an R library for interacting with google cloud storage
* [bigrquery](https://github.com/r-dbi/bigrquery): a package to allow interaction with Google's BigQuery
* [DataBiosphere/Ronaldo](https://github.com/DataBiosphere/Ronaldo): a package of functions commonly used for R Notebooks created from Leonardo

The following are Bioconductor Docker-specific packages:
* [BiocManager](https://www.bioconductor.org/install/): a tool for installing Bioconductor packages
* [SingleCellExperiment](): an S4 container for single-cell analyses
* [GenomicFeatures](https://www.bioconductor.org/packages/release/bioc/html/GenomicFeatures.html): tools for manipulating transcript annotations
* [GenomicAlignments](https://www.bioconductor.org/help/search/index.html?q=GenomicAlignments/): containers for storing short genomic alignments
* [ShortRead](https://www.bioconductor.org/packages/release/bioc/html/ShortRead.html): tools for manipulating and assessing FASTQs
* [DESeq2](https://www.bioconductor.org/help/search/index.html?q=DESeq2/): tools for RNAseq analyses
* [AnnotationHub](https://www.bioconductor.org/packages/release/bioc/html/AnnotationHub.html): resources for gene annotation
* [ExperimentHub](https://www.bioconductor.org/packages/release/bioc/html/ExperimentHub.html): tools for accessing curated experiments
* [ensembldb](https://www.bioconductor.org/packages/release/bioc/html/ensembldb.html): tools for making Ensembl-based annotations
* [scRNAseq](https://www.bioconductor.org/packages/release/data/experiment/html/scRNAseq.html): a collection of public, single-cell RNAseq datasets
* [scran](https://www.bioconductor.org/packages/release/bioc/html/scran.html): tools for single-cell analyses
* [Rtsne](https://cran.r-project.org/web/packages/Rtsne/index.html): an R package for making tSNE plots

### Customizations

The AnVIL RStudio image is customized to disable the RStudio login screen. Future customizations will include:

* RStudio hooks to refresh credentials 
* An RStudio auto pause after inactivity

### Dependencies
**System Dependencies**
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

**Bioconductor Dependencies**
* libsbml
* xvfb

**Perl Dependencies**
* libarchive-extract-perl
* libfile-copy-recursive-perl
* libcgi-pm-perl
* libdbi-perl
* libdbd-mysql-perl
* libxml-simple-perl

**Python Dependencies**
* python-dev
* sklearn
* pandas
* pyyaml
* cwltool

**Additional Dependencies**
* xfonts-100dpi
* xfonts-75dpi
* biber

**Databases and Other Software**
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

# RStudio Bioconductor Updates

All updates and changes to the current RStudio Bioconductor Docker image are listed in the Rstudio image [CHANGELOG.md file](CHANGELOG.md). 



