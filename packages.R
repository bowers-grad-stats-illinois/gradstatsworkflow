## A file to setup the local package situation

## As a general rule, we want the working directory to be the directory containing the command file.

## This next is fast so it doesn't hurt to set it even if it is already set by virtue of the way that we are using R (i.e. if you start R at the command line in this directory, it will have the correct working directory set).

## First, install the here package globally. It would be better to do this all locally, but we need the here package, I think.
pkgs <- installed.packages()
## firstpkgs <- c("here","packrat","devtools")
firstpkgs <- c("here","devtools")

installhere <- firstpkgs[!(firstpkgs  %in% pkgs[,"Package"])]
if(length(installhere)>0){
  install.packages("here")
}
library(here)

#dir.create(here("packrat"), showWarnings = FALSE)
#dir.create(here("packrat/lib"), showWarnings = FALSE)
dir.create(here("lib"))
##.libPaths(here("packrat/lib"))
.libPaths(here("lib"))

## Set working directory to the root of this project
thisdir <- here::here()
setwd(thisdir)

## Setup the packrat local library.
##packrat::init(thisdir, options = list(auto.snapshot = FALSE, external.packages = c("here"), use.cache=TRUE))

secondpkgs <- c("knitr","rmarkdown","readstata13","rstanarm")

toinstallsecond <- secondpkgs[!(secondpkgs %in% pkgs[,"Package"])]
if(length(toinstallsecond)>0){
  install.packages(toinstallsecond)
}

## load the second set of packages
for(nm in secondpkgs){
  message("Loading package ",nm,sep="")
  require(nm,character.only = TRUE)
}

## Maybe packrat::snapshot will be helpful in the future and across OSs. Not sure.
## packrat::snapshot()

## Indicate that this file has run
packages.done <- "done"
write.table(packages.done,file="packages.done")

