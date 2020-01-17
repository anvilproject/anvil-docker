| RStudio Version | Date Updated | Questions or Feedback |
| --- | --- | --- |
| 0.0.1 | 10/06/2019 | Adrian Sharma: adrian@broadinstitute.org |

# AnVIL RStudio Docker Image

[Rstudio](https://rstudio.com/products/rstudio/) is an integrated development environment to support the R statistical programming language. The AnVIL RStudio Docker is a version-tagged image of RStudio, providing consistent RStudio software, packages, and dependencies with every use. This document describes the [RStudio](https://rstudio.com/products/rstudio/) Docker Image and how to use it in the cloud-based platform [Terra](app.terra.bio). Unlike the currently existing [Terra base images](https://github.com/DataBiosphere/terra-docker#terra-base-images), RStudio is not hosted in a Jupyter Notebook; any work performed in Terra RStudio will not be saved. At the end of this document, you will find Instructions and suggestions for saving RStudio data and code. 

## Table of Contents
- [RStudio Docker Contents](#rstudio-docker-contents)
  * [Accessing the AnVIL RStudio Image](#accessing-the-anvil-rstudio-image)
  * [Base Image](#base-image)
  * [Applications](#applications)
  * [Libraries](#libraries)
  * [Customizations](#customizations)
- [Using RStudio in Terra](#using-rstudio-in-terra)
- [Saving RStudio Data](#saving-rstudio-data)
- [RStudio Docker Updates](#rstudio-docker-updates)

## RStudio Docker Contents

### Accessing the AnVIL RStudio Image

The AnVIL Rstudio Image can be accessed using the following URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-base:0.0.1. 

### Base Image

The base image for the AnVIL RStudio Docker is the [rocker/tidyverse](https://hub.docker.com/r/rocker/tidyverse/) image provided by the [Rocker Project](https://www.rocker-project.org/). This image additionally contains tidyverse and devtools.


### Applications

The AnVIL R Docker contains the [RStudio Server](https://www.rstudio.com/products/rstudio-server/) application which supports a web browser version of RStudio. 

### Libraries

The following packages are pre-loaded in the AnVIL RStudio image:

* [tidyverse](https://www.tidyverse.org/packages/): a suite of packages designed for data sciences 
* [google-cloud-sdk](https://cloud.google.com/sdk/): tools for the google cloud platform
* [googleCloudStorageR](http://code.markedmondson.me/googleCloudStorageR/): an R library for interacting with google cloud storage
* [bigrquery](https://github.com/r-dbi/bigrquery): a package to allow interaction with Google's BigQuery
* [DataBiosphere/Ronaldo](https://github.com/DataBiosphere/Ronaldo): a package of functions commonly used for R Notebooks created from Leonardo

### Customizations

The AnVIL RStudio image is customized to disable the RStudio login screen. Future customizations will include:

* RStudio hooks to refresh credentials 
* An RStudio auto pause after inactivity

## Using RStudio in Terra

Detailed instructions on accessing the AnVIL RStudio image can be found in the "[Working with Project-Specific Environments in Terra](https://broadinstitute.zendesk.com/knowledge/articles/360037269472)" documentation in Terra support.

## Saving RStudio Data

Code and data generated in Terra RStudio will not be saved to the Terra workspace google bucket. While code will be saved on the runtime environment (the virtual machine), if you delete the runtime or if your runtime becomes unresponsive, you will lose code. Below are three suggestions for saving your work.

### 1. Copying RStudio work to a workspace google bucket

Use the [gsutil](https://cloud.google.com/storage/docs/gsutil) tool to copy files to your workspace google bucket. The "[Working with project-specific images](https://broadinstitute.zendesk.com/knowledge/articles/360037269472)" documentation in Terra support demonstrates how to identify the url for a workspace google bucket. After identifying the workspace google bucket url, you can copy files to a google bucket using the bash command: 

    !gsutil cp ./* gs://<WORKSPACE_BUCKET>

### 2. Downloading RStudio files to your local computer
Once your files are copied to workspace google bucket, you can access them by selecting the Data tab of the workspace and choosing the Files option on bottom left. This will display the files available in your google bucket. By selecting a file, you can download it directly. Additionally, [this Terra support document](https://support.terra.bio/hc/en-us/articles/360029251091-Broad-Genomics-Downloading-data-from-a-Terra-workspace) details alternative techniques you can use to download data files. 

### 3. Checking code into GitHub
You can install Git on RStudio and use it to [check code into GitHub](https://help.github.com/en/github/importing-your-projects-to-github). 

## RStudio Docker Updates

All updates and changes to the current Docker image are listed in the Rstudio image [CHANGELOG.md file](CHANGELOG.md). 


