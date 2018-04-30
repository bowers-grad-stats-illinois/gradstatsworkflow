
library(here)
library(parallel)
library(rstanarm)
library(dplyr)

## https://cran.r-project.org/web/packages/rstanarm/vignettes/rstanarm.html
load(here("Data", "nes16.rda"))

## covs <- c("educyrs", "age", "gender", "pid", "income", "state", "immiglevel", "immigjobs")
## outcome <- c("votetrump")

summary(nes16[, c("votetrump", "immiglevel", "educyrs")])

wrkdat <- na.omit(nes16[, c("votetrump", "immiglevel", "educyrs")])

wrkdat <- wrkdat %>% mutate(
  il01 = (immiglevel - min(immiglevel)) / ((max(immiglevel) - min(immiglevel))),
  ed01 = (educyrs - min(educyrs)) / ((max(educyrs) - min(educyrs)))
)


SEED <- 12345
ncores <- parallel::detectCores()

## http://mc-stan.org/rstanarm/articles/priors.html
## Hmm... a better prior? my_prior <- normal(location = c(-10, 0), scale = c(5, 2), autoscale = FALSE)
## http://mc-stan.org/rstanarm/articles/continuous.html

glm1 <- stan_glm(votetrump ~ il01 * ed01,
  data = wrkdat,
  family=gaussian,
  ## family = binomial(link = "cauchit"),
  ## prior = laplace(location = 0, scale = NULL, autoscale = TRUE),
  prior = normal(.01, 1000),
  prior_intercept = normal(0, 10000),
  iter = 1000,
  chains = 2, cores = ncores, seed = SEED
)

glm1summary <- summary(glm1)
## http://mc-stan.org/rstanarm/articles/rstanarm.html
credinterval <- posterior_interval(glm1, prob = .95)

yRep <- posterior_predict(glm1)

preddat <- expand.grid(il01 = c(0, 1), ed01 = c(0, 1))
yRepFixed <- posterior_predict(glm1, newdata = preddat, type = "response")
colnames(yRepFixed) <- c(
  "More Immig,No Educ", "Least Immig,No Educ",
  "More Immig,Most Educ", "Least Immig,Most Educ"
)
apply(yRepFixed, 2, summary)

thepost <- as.data.frame(glm1)

save(glm1, yRep, yRepFixed, thepost, credinterval, glm1summary, file = "models.rda")
