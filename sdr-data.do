*** Purpose: prepare sdr data for analysis
*** Author: S Bauldry
*** Date: Dec 28, 2017

*** loading data on 5 sites provided by Virginia
cd "~/dropbox/research/statistics/sdr/sdr-work"
use "sdr-raw-data/5SITES_Data_MI_SI_2_080816.dta", replace
keep if _mi_m == 0

*** various indicators for scales
* diversity support measures (a = 0.91)
rename (q25racediversesch q26econdiversesch q27racediverseclass ///
  q28econdiverseclass) (ds1 ds2 ds3 ds4) 
  
* neighborhood school support measures (a = 0.51)
rename (q12neighbor q24neighborkids q31taxes) (ns1 ns2 ns3)
gen ns4 = q13busing45min
replace ns4 = q14busing25min if mi(ns4)
replace ns4 = q15busing30min if mi(ns4)
  
* danger of reassignment (a = 0.89)
rename (q18elemlearn q19middlelearn q20elemfriends q21middlefriends) ///
  (dr1 dr2 dr3 dr4)

* challenges of reassignment (a = 0.92)
rename (q22elemchallparents q23midchallparents) (cr1 cr2)

* reassignment uncertainty (a = 0.75)
rename (q29uncertainkids q30uncertainparents) (ru1 ru2)

* reverse code all items
foreach x of varlist ds* dr* cr* ru* ns* {
  replace `x' = 6 - `x'
}

* constructing summative scales
gen dsp = ds1 + ds2 + ds3 + ds4
gen dor = dr1 + dr2 + dr3 + dr4
gen chr = cr1 + cr2
gen reu = ru1 + ru2
gen nss = ns1 + ns2 + ns3 + ns4

lab var dsp "diversity support (a = 0.91)"
lab var nss "neighborhood school support (a = 0.51)"
lab var dor "danger of reassignment (a = 0.89)"
lab var chr "challenges of reassignment (a = 0.92)"
lab var reu "reassignment uncertainty (a = 0.75)"

*** sociodemographics
rename (q52age  income_cont) (age inc)
recode age (0/30 = 1) (31/45 = 2) (45/99 = 3), gen(act)
recode q57education (1 = 10) (2 = 12) (3 = 14) (4 = 16) (5 = 18), gen(edu)
recode q54householdinc (1 = 1) (2 3 = 2) (4 5 6 = 3), gen(ict)
gen ach = (q67numberchildren > 0) & !mi(q67numberchildren)
gen fem = (q53gender == 2) if !mi(q53gender)
recode q56race (1 = 2) (2 3 5 6 = 3) (4 = 1), gen(race)
replace race = 3 if q55hisplatino == 1
gen wht = (race == 1) if !mi(race)
recode q61maritalstatus (1 = 1) (2 3 = 0), gen(mar)
rename q11conservative pol
gen mlk = (q46mlk == 1) if !mi(q46mlk)
gen gov = 5 - q44trustgovt
gen spp = (q43socpurpol == 1) if !mi(q43socpurpol)
recode q2lengthlive (1 = 5) (2 3 = 1) (4 = 2) (5 = 3) (6 = 4), gen(liv)

lab var act "age categories"
lab var ict "income categories"
lab var ach "any school-aged children"
lab var pol "political ideology"
lab var mlk "impression of MLK (VF)"
lab var gov "trust in government"
lab var spp "social purpose politics (SA)"
lab var mar "married"
lab var liv "length lived in area"

*** renaming weights
rename (wate) (wt)

*** keeping variables for analysis
order site ds1 ds2 ds3 ds4 ns1 ns2 ns3 ns4 dr1 dr2 dr3 dr4 cr1 cr2 ru1 ru2 ///
  dsp nss dor chr reu age act fem wht mar ach edu ict liv pol mlk gov spp wt
keep  site-wt

*** saving data for analysis in Stata
mi unset, asis
save sdr-data-site, replace

*** saving data for analysis in Mplus
qui tab act, gen(a)
qui tab ict, gen(i)
qui tab pol, gen(p) 

recode _all (. = -9)

order site wt ds1-ds4 ns1-ns4 dr1-dr4 cr1 cr2 ru1 ru2 a2 a3 fem wht mar ach ///
  edu i2 i3 liv p2 p3 mlk gov spp
keep site-spp
desc
outsheet using sdr-data-site-mplus.txt, replace comma noname nolabel



*** loading 2011 Wake data provided by Virginia
use "sdr-raw-data/Wake_Data_2011.dta", replace

* group variable
gen time = 2

* diversity support measures 
rename (q29diverse q30diverse1 q31diverse2 q32diverse3) (ds1 ds2 ds3 ds4) 
 
* neighborhood school support measures 
rename (q18neighbor q28neighbor1 q36taxes q19bussing) (ns1 ns2 ns3 ns4)

* challenges of reassignment 
rename (q26k5challenge q27middlechallenge) (cr1 cr2)

* danger of reassignment
rename (q22k5learning q23middlelearning q24k5friend q25middlefriend) ///
  (dr1 dr2 dr3 dr4)
  
* reassignment uncertainty (a = 0.75)
rename (q34probchild q35probparent) (ru1 ru2)

* constructing summative scales
gen dsp = ds1 + ds2 + ds3 + ds4
gen nss = ns1 + ns2 + ns3 + ns4
gen dor = dr1 + dr2 + dr3 + dr4
gen chr = cr1 + cr2
gen reu = ru1 + ru2

* sociodemographics
recode q46q47age1 (21/30 = 1) (31/45 = 2) (45/99 = 3), gen(act)
recode q49householdinc (1 = 1) (2 3 = 2) (4 5 6 = 3), gen(ict)
recode q51education (1 = 10) (2 = 12) (3 = 14) (4 = 16) (5 = 18), gen(edu)
gen ach = (q67numberchildren > 0) if !mi(q67numberchildren)
gen fem = (q48gender == 2) if !mi(q48gender)
gen wht = (q50race == 2) if !mi(q50race)
gen mar = (q6married == 1) if !mi(q6married)
recode q17ideology (4 = .), gen(pol) 
recode q39localgovt (5 = .) (1 = 4) (2 = 3) (3 = 2) (4 = 1), gen(gov)
gen mlk = (q42mlk == 1) if !mi(q42mlk)
recode q2lengthwake (1 = 5) (2 3 = 1) (4 = 2) (5 = 3) (6 = 4), gen(liv)

* renaming weight
rename (FINALRAKER) (wt)

order time ds1 ds2 ds3 ds4 ns1 ns2 ns3 ns4 dr1 dr2 dr3 dr4 cr1 cr2 ru1 ru2 ///
  dsp nss dor chr reu act ict edu ach fem wht mar pol gov mlk liv wt
keep time-wt

*** saving data for appending
tempfile d1
save `d1', replace


*** loading 5 site data and preparing for appending
use sdr-data-site, replace
keep if site == 1
gen time = 1

append using `d1'

order time ds1 ds2 ds3 ds4 ns1 ns2 ns3 ns4 dr1 dr2 dr3 dr4 cr1 cr2 ru1 ru2 ///
  dsp nss dor chr reu act ict edu ach fem wht mar pol gov mlk liv wt
keep time-wt
  
*** saving data for analysis in Stata
mi unset, asis
save sdr-data-time, replace

*** saving data for analysis in Mplus
qui tab act, gen(a)
qui tab ict, gen(i)
qui tab pol, gen(p) 

recode _all (. = -9)

order time wt ds1-ds4 ns1-ns4 dr1-dr4 cr1 cr2 ru1 ru2 a2 a3 fem wht mar ach ///
  edu i2 i3 liv p2 p3 mlk gov
keep time-gov
desc
outsheet using sdr-data-time-mplus.txt, replace comma noname nolabel  


  
