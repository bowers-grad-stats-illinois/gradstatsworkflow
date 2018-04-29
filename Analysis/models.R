
library(here)
.libPaths(here("libs"))
library(rstanarm)

## https://cran.r-project.org/web/packages/rstanarm/vignettes/rstanarm.html
load(here("Data","nes16.rda"))

##covs <- c("educyrs", "age", "gender", "pid", "income", "state", "immiglevel", "immigjobs")
##outcome <- c("votetrump")

SEED <- 12345

glm1 <- stan_glm( votetrump ~ immiglevel + immigjobs,
                              data = nes16,
                              family = binomial(link = "logit"),
                              prior = student_t(df = 7),
                              prior_intercept = student_t(df = 7),
                              chains = 4, cores = parallel::detectCores(), seed = SEED)



save(glm1,file="models.rda")

