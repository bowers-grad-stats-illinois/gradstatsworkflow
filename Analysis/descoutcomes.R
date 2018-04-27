## Describe the thing that we are going to explain: Trump vote

load("../Data/nes16.rda")

sampsize <- nrow(nes16)
proptrumpvote <- mean(nes16$votetrump)

save(sampsize,proptrumpvote,file="desc.rda")

