## 3.19.1 - 6/27/2024

- Bioconductor 3.19 build with R 4.4.1

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.19.1

## 3.19.0 - 5/13/2024

- Bioconductor 3.19 build with R 4.4.0

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.19.0

## 3.18.1 - 5/7/2024

- Bioconductor 3.18 rebuild with R 4.3.3

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.18.1

## 3.18.0 - 11/7/2023

- Bioconductor 3.18 release with R 4.3.2
- Pin torch to last version for container CUDA version

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.18.0

## 3.17.1 - 9/13/2023

- Update R to 4.3.1

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.17.1

## 3.17.0 - 5/12/2023

- Update base to ghcr.io/bioconductor/ml-verse:3.17 image with Bioconductor 3.17 release and GPU drivers
- R 4.3.0

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.17.0

## 3.16.1 - 5/12/2023

- Update base to ghcr.io/bioconductor/ml-verse:3.16 image with Bioconductor 3.16 release and GPU drivers
- R 4.2.3

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.16.1

## 3.16.0 - 11/7/2022

- Update base bioconductor/bioconductor_docker:RELEASE_3_16 image with Bioconductor 3.16 release
- R 4.2.2

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.16.0

## 3.15.3 - 9/13/2022

- Update base bioconductor/bioconductor_docker:RELEASE_3_15 image with R 4.2.1 and including Quarto

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.15.3

## 3.15.2 - 6/06/2022

- Update base bioconductor/bioconductor_docker:RELEASE_3_15 image with python3.8-venv

- rebuild stack.

- Add CHANGELOG.md changes for 3.15.1 as well.

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.15.2

## 3.15.1 - 5/02/2022

- AnVIL package needs to be installed in the RStudio image

- Patch version update 3.15.1

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.15.1

## 3.15.0 - 4/26/2022

- Update base bioconductor/bioconductor_docker:RELEASE_3_15 image.

- R 4.2.0 is the current version.

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.15.0

## 3.14.2 - 3/8/2022

- Update base bioconductor/bioconductor_docker:RELEASE_3_14 image.

- Rebuild stack.

Image URL: us.gcr.io/broad-dsp-gcr-public/anvil-rstudio-bioconductor:3.14.2

## 3.14.1 - 2/2/2022

- Add RStudio user to users group for proper permissions

## 3.14.0 - 11/2/2021

- Latest release of Bioconductor 3.14

- Update in base image bioconductor/bioconductor_docker:RELEASE_3_14.

- Rebuild stack.

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.14.0

## 3.13.3 - 9/28/2021

- Update in base image bioconductor/bioconductor_docker:RELEASE_3_13.

- Rebuild stack.

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.13.3

## 3.13.2 - 6/24/2021

- Fix bug with ggplot2 causing RStudio to crash
   - See https://github.com/rstudio/rstudio/issues/9373

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.13.2

## 3.13.1 - 6/8/2021

- Update www-address to accomodate recent network change for RStudio container

- Update in base image `biconductor/bioconductor_docker:RELEASE_3_13_1`. 

- Adding pre-install of Seurat

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.13.1

## 3.13.0 - 5/24/2021

- Launch of Bioconductor release 3.13 image

- Update in base image `biconductor/bioconductor_docker:RELEASE_3_13`. 

- Change versioning scheme to reflect Bioconductor version.

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:3.13.0

## 0.0.11 - 5/4/2021

- Update in base image `biconductor/bioconductor_docker:RELEASE_3_12`. 

- rebuild of the entire stack

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.11

## 0.0.10 - 1/15/2020

- This version update is a precursor to the image which will
  eventually follow Bioconductor versioning. The next update will be
  based on the version of Bioconductor 3.12.0.
  
- It removes all the Env variables which are not required.

- Includes a new way PD's save packages in folders under
  /home/rstudio/R/x86_64-pc-linux-gnu-library/4.0-3.12. The directory
  4.0-3.12 will host the packages under that image and attached to the
  .libPaths() inside the R session. These changes will live in the set_up_package_dir.sh script.
  
Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.10

## 0.0.9 - 12/15/2020

- Update to R 4.0.3 and Bioc 3.12
- Image is now based on 'bioconductor/bioconductor_docker:RELEASE_3_12'
  version '3.12.30'.
- This verison adds the dependency 'libgit2-dev' which is essential for
  packages like 'gert' and 'use_this'.

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.9

## 0.0.8 - 11/4/2020

- Update to R 4.0.3 and Bioc 3.12
- Image is now based on 'bioconductor/bioconductor_docker' stack and not
  on rocker/tidyverse

Image URL: us.gcr.io/anvil-gcr-public/anvil-rstudio-bioconductor:0.0.8

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
