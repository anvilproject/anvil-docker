## 0.0.7 - 10/28/2020

- Install shiny as part of the base image to fix RShiny app launching
   - See: https://broadworkbench.atlassian.net/browse/IA-2235

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.7

## 0.0.6 - 07/01/2020

- User installed R and pip packages will now persist between runtimes
- Update vesrsion number of image to `0.0.6`.

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.6

## 0.0.5 - 05/08/2020

- Update anvil-rstudio-base image to `0.0.3`.
- This image includes Bioconductor RELEASE_3_11 and R 4.0.0
- Update vesrsion number of image to `0.0.5`.

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.5

## 0.0.4 - 12/11/2019

- Add env variables R_PLATFORM and R_PLATFORM_BINARY_VERSION.
- Update vesrsion number of image to `0.0.4`.

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.4

## 0.0.3 - 12/11/2019

- Pull Bioconductor packages from location on Github.
- This location and set of packages are the same for both RStudio and Jupyter images.

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.3

## 0.0.2 - 12/10/2019

- Improve image by adding essential Bioconductor packages.
- Packages list: "AnnotationHub", "ExperimentHub", "ensembldb", "scRNAseq", "scran", "Rtsne"
- Update version of the image to `0.0.2`.

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.2

## 0.0.1 - 11/26/2019

- Extends us.gcr.io/anvil-gcr-public/anvil-rstudio-base image.
- Add system dependencies for all bioconductor packages.

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.1
