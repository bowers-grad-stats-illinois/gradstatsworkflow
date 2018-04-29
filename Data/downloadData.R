## Simply download the data so that we dont have to wait to download everytime we want to change our recoding.

library(here)
download.file("http://jakebowers.org/PS531/anes_timeseries_2016.dta",destfile = here("Data","anes_timeseries_2016.dta"))
