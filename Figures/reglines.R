
library(here)
library(tidyverse)
library(rstanarm)
load(here("Data","nes16.rda"))
load(here("Analysis","models.rda"))

## plotdat <- data.frame(yRepFixed)
## plot(c(0,1),c(0,1),type="n",xlab="Less to More Immig")
## for(i in 1:nrow(plotdat)){
## 	segments(x0 = 0, x1 = 1, y0 = plotdat[i,2], y1 = plotdat[i,1])
## }

pdf(file = "reglines.pdf")

theplot <- plot(glm1,"hist")

print(theplot)

dev.off()


