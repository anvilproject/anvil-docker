| Latest Image Release | Docker Image URL |Date Updated | Questions or Feedback | 
| --- | --- | --- | --- |
| 3.14.1 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.14.1 | 2/2/2022 | Contact the [Bioconductor Team](mailto:nturaga.bioc@gmail.com) |
| 3.14.0 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.14.0 | 11/2/2021 | Contact the [Bioconductor Team](mailto:nturaga.bioc@gmail.com) |
| 3.13.3 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.13.3 | 9/28/2021 | Contact the [Bioconductor Team](mailto:nturaga.bioc@gmail.com) |
| 3.13.2 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.13.2 | 6/24/2021 | Contact the [Bioconductor Team](mailto:nturaga.bioc@gmail.com) |
| 3.13.1 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.13.1 | 6/8√/2021 | Contact the [Bioconductor Team](mailto:nturaga.bioc@gmail.com) |
| 3.13.0 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.13.0 | 6/1/2021 | Contact the [Bioconductor Team](mailto:nturaga.bioc@gmail.com) |
| 0.0.11 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.11 | 5/4/2021 | Contact the [Bioconductor Team](mailto:nturaga.bioc@gmail.com) |
| 0.0.10 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.10 | 1/25/2021 | Contact the [Bioconductor Team](mailto:nturaga.bioc@gmail.com) |
| 0.0.9 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.9 | 12/15/2020 | Contact the [Bioconductor Team](mailto:nturaga.bioc@gmail.com) |
| 0.0.8 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.8 | 11/04/2020 | Contact the [Bioconductor Team](mailto:nitesh.turaga@roswellpark.org) |
| 0.0.7 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.7 | 10/28/2020 | Contact the [Bioconductor Team](mailto:nitesh.turaga@roswellpark.org) |
| 0.0.6 | us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.6 | 07/01/2020 | Contact the [Bioconductor Team](mailto:nitesh.turaga@roswellpark.org) |

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

The base image for the AnVIL RStudio Bioconductor Docker is the [bioconductor_docker](https://github.com/Bioconductor/bioconductor_docker). This contains the [rocker/rstudio](https://hub.docker.com/r/rocker/rstudio/) image provided by the [Rocker Project](https://www.rocker-project.org/). All the system dependencies are inherited from the bioconductor image.

### Applications

The AnVIL RStudio Docker contains the [RStudio Server](https://www.rstudio.com/products/rstudio-server/) application which supports a web browser version of RStudio. Additionally, it contains all system dependencies for Bioconductor packages.

### Libraries
The Bioconductor image inherits all libraries from `bioconductor/bioconductor_docker`. The following packages are included in the base image:
* [tidyverse](https://www.tidyverse.org/packages/): a suite of packages designed for data sciences 
* [google-cloud-sdk](https://cloud.google.com/sdk/): tools for the google cloud platform
* [googleCloudStorageR](http://code.markedmondson.me/googleCloudStorageR/): an R library for interacting with google cloud storage
* [bigrquery](https://github.com/r-dbi/bigrquery): a package to allow interaction with Google's BigQuery
* [DataBiosphere/Ronaldo](https://github.com/DataBiosphere/Ronaldo): a package of functions commonly used for R Notebooks created from Leonardo

The following are Bioconductor Docker-specific packages:
* [BiocManager](https://www.bioconductor.org/install/): a tool for installing Bioconductor packages

### Customizations

The AnVIL RStudio image is customized to disable the RStudio login screen. Future customizations will include:

* RStudio hooks to refresh credentials 
* An RStudio auto pause after inactivity

# RStudio Bioconductor Updates

All updates and changes to the current RStudio Bioconductor Docker image are listed in the Rstudio image [CHANGELOG.md file](CHANGELOG.md). 



