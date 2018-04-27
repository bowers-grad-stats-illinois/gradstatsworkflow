## This file records the dependencies among files in this project

## Make a pdf of the paper itself

paper.pdf: paper.tex main.bib
	latexmk -pdf paper.tex

## Setup required libraries

## Setup the data
Data/anes_timeseries_2016.dta: Data/downloadData.R
	cd Data && R CMD BATCH downloadData.R

Data/nes16.rda: Data/nes16setup.R Data/anes_timeseries_2016.dta
	cd Data && R CMD BATCH nes16setup.R

## Execute the analysis

## Make figures and/or tables

Figures/reglines.pdf: Figures/reglines.R
	cd Figures && R CMD BATCH reglines.R


