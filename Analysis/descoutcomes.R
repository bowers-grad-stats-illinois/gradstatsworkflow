## Describe the thing that we are going to explain: Trump vote

library(here)
load(here("Data","nes16.rda"))

sampsize <- nrow(nes16)
proptrumpvote <- mean(nes16$votetrump,na.rm=TRUE)

save(sampsize,proptrumpvote,file="desc.rda")

