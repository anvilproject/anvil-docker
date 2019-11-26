# RStudio-Bioconductor Docker Image

## Base image
* [rocker/tidyverse](https://hub.docker.com/r/rocker/tidyverse/)
* [us.gcr.io/anvil-gcr-public/anvil-rstudio-base](us.gcr.io/anvil-gcr-public/anvil-rstudio-base)

## Applications
* [RStudio Server](https://www.rstudio.com/products/rstudio-server/)
* All system dependencies for Bioconductor packages.

## Libraries (TODO)
* tidyverse
* google-cloud-sdk
* googleCloudStorageR
* bigrquery
* DataBiosphere/Ronaldo

## Customiziations (TODO)
* Disabled RStudio login screen
* TODO: RStudio hooks to refresh credentials and pause on inactivity
