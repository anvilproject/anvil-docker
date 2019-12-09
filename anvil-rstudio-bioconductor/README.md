# RStudio-Bioconductor Docker Image

## Base image
* [us.gcr.io/anvil-gcr-public/anvil-rstudio-base](us.gcr.io/anvil-gcr-public/anvil-rstudio-base)

## Applications
* [RStudio Server](https://www.rstudio.com/products/rstudio-server/)
* All system dependencies for Bioconductor packages.

## Libraries
* Inherits all libraries from `anvil-rstudio-base`
* BiocManager
* tidyverse
* google-cloud-sdk
* googleCloudStorageR
* bigrquery
* DataBiosphere/Ronaldo

## Customiziations
* Disabled RStudio login screen
* TODO: RStudio hooks to refresh credentials and pause on inactivity

## Bioconductor modifications

#### System dependencies installed for Bioconductor
fortran77-compiler
byacc
automake
libpng-dev
libnetcdf-dev
libhdf5-serial-dev
libfftw3-dev
libopenbabel-dev
libopenmpi-dev
libexempi3
libxt-dev
libgdal-dev
libjpeg62-turbo-dev
libtiff5-dev
libreadline-dev
libgsl0-dev
libgsl2
libgtk2.0-dev
libgl1-mesa-dev
libglu1-mesa-dev
libgmp3-dev
libhdf5-dev
libncurses-dev
libbz2-dev
libxpm-dev
liblapack-dev
libv8-3.14-dev
libgtkmm-2.4-dev
libmpfr-dev
libudunits2-dev
libmodule-build-perl
libapparmor-dev
libgeos-dev
libprotoc-dev
librdf0-dev
libmagick++-dev
libpoppler-cpp-dev
libprotobuf-dev
libperl-dev
libz-dev
liblzma-dev

#### perl modules
libarchive-extract-perl
libfile-copy-recursive-perl
libcgi-pm-perl
libdbi-perl
libdbd-mysql-perl
libxml-simple-perl

#### Databases and other software
sqlite
openmpi-bin
mpi-default-bin
openmpi-common
openmpi-doc
tcl8.5-dev
tk-dev
openjdk-8-jdk
imagemagick
tabix
ggobi
graphviz
protobuf-compiler
jags

#### Additional resources
xfonts-100dpi
xfonts-75dpi
biber

#### python dependencies
python-dev
sklearn
pandas
pyyaml
cwltool

#### Bioconductor package specific dependencies
libsbml
xvfb
