
library(here)
library(xtable)
load(here("Data","nes16.rda"))
load(here("Analysis","models.rda"))

summat <- glm1summary[1:7,]

atable <- xtable(summat,label="tab:thetab")

print(atable,file="thetab.tex")



