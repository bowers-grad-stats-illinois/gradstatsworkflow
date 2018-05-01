
library(here)
library(xtable)
load(here("Data","nes16.rda"))
load(here("Analysis","models.rda"))

summat <- glm1summary[1:7,]

atable <- xtable(summat,label="tab:thetab", caption="A long description that means that you do not have to read the text of the paper in order to understand the table")

print(atable,file="thetab.tex")



