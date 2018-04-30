## This file records the dependencies among files in this project

## Make a pdf of the paper itself

paper.pdf:  paper.Rmd Analysis/models.rda \
	Figures/reglines.pdf \
	Figures/thetab.tex \
	Analysis/desc.rda \
	bowersarticle.latex \
	main.bib \
	defs-all.sty
	Rscript -e "library(rmarkdown); render('paper.Rmd',output_format=pdf_document(),clean=FALSE)"

## Setup required libraries

packages.done: packages.R
	R CMD BATCH --no-save --no-restore packages.R

## Setup the data
Data/anes_timeseries_2016.dta: Data/downloadData.R
	cd Data && R CMD BATCH --no-save --no-restore downloadData.R

Data/nes16.rda: Data/nes16setup.R Data/anes_timeseries_2016.dta packages.done
	cd Data && R CMD BATCH --no-save --no-restore nes16setup.R

## Execute the analysis

Analysis/models.rda:  Analysis/models.R Data/nes16.rda packages.done
	cd Analysis && R CMD BATCH --no-save --no-restore models.R

## Make figures and/or tables

Analysis/desc.rda: Analysis/descoutcomes.R Data/nes16.rda
	cd Analysis && R CMD BATCH  --no-save --no-restore descoutcomes.R

Figures/reglines.pdf: Figures/reglines.R Analysis/models.rda packages.done
	cd Figures && R CMD BATCH --no-save --no-restore reglines.R

Figures/thetab.tex: Figures/thetab.R Data/nes16.rda
	cd Figures && R CMD BATCH --no-save --no-restore thetab.R


