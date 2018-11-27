*** Purpose: prepare descriptive statistics
*** Author: S Bauldry
*** Date: November 27, 2018

*** Set directory and load time data
cd "~/dropbox/research/statistics/sdr/sdr-work"
use sdr-data-time, replace

* indicator descriptives
sum ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 if time == 2
sum ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 if time == 1

* covariate descriptives


*** Load site data
use sdr-data-site, replace

* indicator descriptives
sum ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 if site == 2
sum ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 if site == 3
sum ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 if site == 4
sum ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 if site == 5

* covariate descriptives
