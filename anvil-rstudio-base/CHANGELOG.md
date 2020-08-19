## 0.0.5 - 08/19/2020

- Update base image to rocker/tidyverse:4.0.2
- Update R version to 4.0.2
- The version of Ubuntu is now 20.04 because of the update to
  rocker/tidyverse:4.0.2. This is a shift from the 18.04 image.

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
