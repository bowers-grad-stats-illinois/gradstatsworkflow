## Extract variables and recode

library("readstata13")
library(tidyverse)
library(car)
## code book http://www.jakebowers.org/PS531/anes_timeseries_2016_userguidecodebook.pdf
# anes16 <- read.dta13("http://jakebowers.org/PS531/anes_timeseries_2016.dta")
anes16 <- read.dta13("anes_timeseries_2016.dta")

## anes16$age <- with(anes16,ifelse(V161267<0,NA,V161267))
## Feeling thermometer for Trump asked AFTER the election
anes16$ftTrumpPost <- with(anes16, ifelse(V162079 < 0 | V162079 == 998, NA, V162079))
## Feeling thermometer for Trump asked BEFORE the election
anes16$ftTrumpPre <- with(anes16, ifelse(V161087 < 0 | V161087 == 998, NA, V161087))

table(anes16$V162230x, exclude = c())
table(anes16$V162034a, exclude = c())

anes16$age <- with(anes16, ifelse(V161267 < 0, NA, V161267))
summary(anes16$age)
## Make an indicator variable 1=over 50, 0=under 50
anes16$age50plus <- as.numeric(anes16$age >= 50)

anes16$voteTrump <- with(anes16, car::Recode(V162034a, "2=1;c(-9,-8,-7,-6,-1,7,9)=NA;else=0"))
with(anes16, table(voteTrump, V162034a, exclude = c()))

anes16$age <- with(anes16, ifelse(V161267 < 0, NA, V161267))
summary(anes16$age)
## Make an indicator variable 1=over 50, 0=under 50
anes16$age50plus <- as.numeric(anes16$age >= 50)


anes16$voteTrump <- with(anes16, Recode(V162034a, "2=1;c(-9,-8,-7,-6,-1,7,9)=NA;else=0"))
with(anes16, table(voteTrump, V162034a, exclude = c()))

anes16$obamaNotMuslimCertain <- with(anes16, ifelse(V162255x < 0, NA, V162255x - 1))
anes16$obamaMuslim <- with(anes16, ifelse(V162255 < 0, NA, V162255))
anes16$obamaMuslim01 <- as.numeric(anes16$obamaMuslim == 1)

anes16$educyrs <- with(anes16, ifelse(V161270 < 0 | V161270 %in% c(90, 95), NA, V161270 - 1))
## PID V161158x
### -8. Don’t know 11 -9. Refused
## V161267 PRE: Respondent age
## V162078 POST: Feeling thermometer: Democratic Presidential candidate
## V162079 POST: Feeling thermometer: Republican Presidential candidate
## V162171 POST: 7pt scale liberal-Conservate: self placement
## V161158x PRE: SUMMARY - Party ID
## V161270 PRE: Highest level of Education
anes16$pid <- factor(with(anes16, ifelse(V161158x < 0, NA, V161158x)))
## anes16$educ <- with(anes16,ifelse( V161270<0 | V161270>16,NA,V161270 ))
## anes16$ftdemrep <- with(anes16,ftClintonPost - ftTrumpPost)
## Recode the 7 point partisanship scale into two categories: democrats (1) versus republicans.(0).
anes16$dem <- with(anes16, ifelse(pid < 4, 1, 0))
anes16$dem[anes16$pid == 4] <- NA ## set Independents to Missing
## check recode with(anes16, table(dem,pid,useNA="ifany"))
anes16$republican <- as.numeric(anes16$pid >= 4)

## V161002 Female
## 1. Male
## 2. Female
## -1. Inapplicable
## V161342 PRE: self-identified gender
## -9. Refused
## 1. Male
## 2. Female
## 3. Other

anes16$gender <- factor(ifelse(anes16$V161342 == -9, NA, anes16$V161342))
anes16$income <- ifelse(anes16$V161361x < 1, NA, anes16$V161361x)
anes16$state <- anes16$V163001b


## V162034a Numeric POST: For whom did R vote for President
table(anes16$V162034a, exclude = c())
anes16$votetrump <- car::Recode(anes16$V162034a,' -9:-1 = NA; 2=1; else=0')

with(anes16,table(V162034a,votetrump,exclude=c()))

## V162157 Numeric POST: What should immigration levels be
### from 1=increased a lot to 5=decreased a lot
anes16$immiglevel <- ifelse(anes16$V162157<0,NA,anes16$V162157)
stopifnot(all(unique(anes16$immiglevel[!is.na(anes16$immiglevel)]) %in% 1:5))

## V162158 Numeric POST: How likely immigration will take away jobs
anes16$immigjobs <- ifelse(anes16$V162158<0,NA,anes16$V162158)
stopifnot(all(unique(anes16$immigjobs[!is.na(anes16$immigjobs)]) %in% 1:5))

## Check to make sure all covariates exist in the data
stopifnot(all(covs %in% names(anes16)))

covs <- c("educyrs", "age", "gender", "pid", "income", "state", "immiglevel", "immigjobs")
outcome <- c("votetrump")
nes16 <- droplevels(anes16[, c(covs,outcome)] )

stopifnot(nrow(nes16) == nrow(anes16))

save(nes16, file = "nes16.rda")
