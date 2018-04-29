## This file records the dependencies among files in this project

## Make a pdf of the paper itself

paper.pdf: paper.tex main.bib
	latexmk -pdf paper.tex

paper.tex: paper.Rmd Analysis/models.rda Figures/reglines.pdf
	Rscript -e "library(knitr); library(methods); knit('paper.Rmd')"

## Setup required libraries

packages.done: packages.R
	R CMD BATCH packages.R

## Setup the data
Data/anes_timeseries_2016.dta: Data/downloadData.R
	cd Data && R CMD BATCH downloadData.R

Data/nes16.rda: Data/nes16setup.R Data/anes_timeseries_2016.dta packages.done
	cd Data && R CMD BATCH nes16setup.R

## Execute the analysis

Analysis/models.rda:  Analysis/models.R Data/nes16.rda packages.done
	cd Analysis && R CMD BATCH models.R

## Make figures and/or tables

Figures/reglines.pdf: Figures/reglines.R Analysis/models.rda packages.done
	cd Figures && R CMD BATCH reglines.R


