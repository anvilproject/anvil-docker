library(rmarkdown)
library(gert)
library(knitr)

f <- git_clone("https://github.com/DataBiosphere/terra-docker")

## Covert to R
input <- file.path(f, "terra-jupyter-bioconductor/tests/smoke_test.ipynb")
output <- xfun::with_ext(input, "Rmd")
rmarkdown::convert_ipynb(input, output = output)
r_script <- knitr::purl(output)

## Run rscript

source(r_script, max=Inf, echo=TRUE)
