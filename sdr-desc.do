*** Purpose: prepare descriptive statistics
*** Author: S Bauldry
*** Date: November 27, 2018

*** Set directory and load time data
cd "~/dropbox/research/statistics/sdr/sdr-work"
use sdr-data-time, replace

* indicator descriptives
sum ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 if time == 2, separator(50)
sum ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 if time == 1, separator(50)

* covariate descriptives
qui tab act, gen(a)
qui tab ict, gen(i)
qui tab pol, gen(p)

sum a1 a2 a3 fem wht mar ach edu i1 i2 i3 liv p1 p2 p3 mlk gov if time == 2, ///
  separator(50)
sum a1 a2 a3 fem wht mar ach edu i1 i2 i3 liv p1 p2 p3 mlk gov if time == 1, ///
  separator(50)

* extent of missing data
local N = _N
foreach x of varlist ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 {
  qui sum `x'
  dis "`x': " as result %5.2f (1 - r(N)/`N')*100
}
foreach x of varlist a3 fem wht mar ach edu i3 liv p3 mlk gov {
  qui sum `x'
  dis "`x': " as result %5.2f (1 - r(N)/`N')*100
}


  
*** Load site data
use sdr-data-site, replace

* indicator descriptives
sum ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 if site == 2, separator(50)
sum ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 if site == 3, separator(50)
sum ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 if site == 4, separator(50)
sum ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 if site == 5, separator(50)

* covariate descriptives
qui tab act, gen(a)
qui tab ict, gen(i)
qui tab pol, gen(p)

sum a1 a2 a3 fem wht mar ach edu i1 i2 i3 liv p1 p2 p3 mlk gov if site == 2, ///
  separator(50)
sum a1 a2 a3 fem wht mar ach edu i1 i2 i3 liv p1 p2 p3 mlk gov if site == 3, ///
  separator(50)
sum a1 a2 a3 fem wht mar ach edu i1 i2 i3 liv p1 p2 p3 mlk gov if site == 4, ///
  separator(50)
sum a1 a2 a3 fem wht mar ach edu i1 i2 i3 liv p1 p2 p3 mlk gov if site == 5, ///
  separator(50)
  
* extent of missing data
local N = _N
foreach x of varlist ns1-ns4 ds1-ds4 cr1 cr2 dr1-dr4 ru1 ru2 {
  qui sum `x'
  dis "`x': " as result %5.2f (1 - r(N)/`N')*100
}
foreach x of varlist a3 fem wht mar ach edu i3 liv p3 mlk gov {
  qui sum `x'
  dis "`x': " as result %5.2f (1 - r(N)/`N')*100
}


