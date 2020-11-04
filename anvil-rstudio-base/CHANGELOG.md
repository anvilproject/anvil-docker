## 0.0.5 - 11/03/2020

- Deprecation notice. The `anvil-rstudio-base:0.0.5` is going to be
  deprecated and doesn't offer value. The only `rstudio` image on the
  anvil maintained by the Bioconductor team is going to be 
  `anvil-rstudio-bioconductor`.

- DO NOT update anvil-rstudio-base anymore.

## 0.0.5 - 10/28/2020

- Install shiny as part of the base image to fix RShiny app launching
   - See: https://broadworkbench.atlassian.net/browse/IA-2235

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-base:0.0.5

## 0.0.4 - 07/01/2020

- User installed R and pip packages will now persist between runtimes

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-base:0.0.4

## 0.0.3 - 05/08/2020

- Update to R-4.0.0
- rockerdev/tidyverse:4.0.0-ubuntu18.04 as the inherting image.

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-base:0.0.3

## 0.0.2 - 11/26/2019

- Add image tab to rocker/tidyverse:3.6.1 instead of "latest".
- Replace install.packages with BiocManager.

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-base:0.0.2

## 0.0.1 - 10/06/2019

- Extends rocker/tidyverse image
- Add tidyverse
- Add google-cloud-sdk
- Add googleCloudStorageR
- Add bigrquery
- Add DataBiosphere/Ronaldo
- Add Leonardo customizations

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-base:0.0.1
