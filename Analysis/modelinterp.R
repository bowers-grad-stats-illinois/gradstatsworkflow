
library(here)
library(xtable)
library(rstanarm)
library(tidyverse)
load(here("Data","nes16.rda"))
load(here("Analysis","models.rda"))


wrkdat <- na.omit(nes16[, c("votetrump", "immiglevel", "educyrs")])

wrkdat <- wrkdat %>% mutate(
  il01 = (immiglevel - min(immiglevel)) / ((max(immiglevel) - min(immiglevel))),
  ed01 = (educyrs - min(educyrs)) / ((max(educyrs) - min(educyrs)))
)



credinterval <- posterior_interval(glm1, prob = .95)

## Interval for effect of immigration among folks with high education

thepost$ilEffectEdHi <- thepost$il01 + thepost$`il01:ed01`

credintervalilEdHi <- quantile(thepost$ilEffectEdHi,c(.025,.25,.5,.75,.975))

credintervals <- apply(thepost,2,function(x){
 quantile(x,c(.025,.25,.5,.75,.975))
})


predInt <- predictive_interval(yRepFixed,prob =.95)
predInt2 <- predictive_interval(yRepFixed,prob =.5)

predMedian <- apply(yRepFixed,2,median)

toplot <- data.frame(cbind(c(1,0,1,0),c(0,0,1,1),predInt,predInt2,predMedian))


pdf(file="lineplot.pdf")

with(wrkdat,plot(jitter(il01),jitter(votetrump)))
with(toplot[toplot$V2==0,],lines(V1,X2.5.))
with(toplot[toplot$V2==0,],lines(V1,X97.5.))
with(toplot[toplot$V2==1,],lines(V1,X2.5.,lty=2))
with(toplot[toplot$V2==1,],lines(V1,X97.5.,lty=2))
#
with(toplot[toplot$V2==0,],lines(V1,X25.))
with(toplot[toplot$V2==0,],lines(V1,X75.))
with(toplot[toplot$V2==1,],lines(V1,X25.,lty=2))
with(toplot[toplot$V2==1,],lines(V1,X75.,lty=2))
#
with(toplot[toplot$V2==0,],lines(V1,predMedian,lwd=2))
with(toplot[toplot$V2==1,],lines(V1,predMedian,lwd=2,lty=2))

dev.off()

##save( , file="modelinterp.rda")

