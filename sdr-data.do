*** Purpose: prepare sdr data for analysis
*** Author: S Bauldry
*** Date: Dec 28, 2017


*** loading data provided by Virginia
cd "~/dropbox/research/hlthineq/sdr/sdr-work"
use "sdr-raw-data/5SITES_Data_MI_SI_2_080816.dta", replace
keep if _mi_m == 0

*** various indicators for scales
* diversity support measures (a = 0.91)
rename (q25racediversesch q26econdiversesch q27racediverseclass ///
  q28econdiverseclass) (ds1 ds2 ds3 ds4) 
  
* danger of reassignment (a = 0.89)
rename (q18elemlearn q19middlelearn q20elemfriends q21middlefriends) ///
  (dr1 dr2 dr3 dr4)

* challenges of reassignment (a = 0.92)
rename (q22elemchallparents q23midchallparents) (cr1 cr2)

* reassignment uncertainty (a = 0.75)
rename (q29uncertainkids q30uncertainparents) (ru1 ru2)

* neighborhood school support measures (a = 0.51)
rename (q12neighbor q24neighborkids q31taxes) (ns1 ns2 ns3)
gen ns4 = q13busing45min
replace ns4 = q14busing25min if mi(ns4)
replace ns4 = q15busing30min if mi(ns4)
  
* support for magnet schools (a = 0.81)
rename (q37supportmagnet q38magnetbetter q39incmagnet) (sm1 sm2 sm3)

* support for charter schools (a = 0.82)
rename (q32supportcharter q33charterbetter) (sc1 sc2)

* reverse code all items
foreach x of varlist ds* dr* cr* ru* ns* sm* sc* {
  replace `x' = 6 - `x'
}

* constructing summative scales
gen dsp = ds1 + ds2 + ds3 + ds4
gen dor = dr1 + dr2 + dr3 + dr4
gen chr = cr1 + cr2
gen run = ru1 + ru2
gen nss = ns1 + ns2 + ns3 + ns4

lab var dsp "diversity support (a = 0.91)"
lab var dor "danger of reassignment (a = 0.89)"
lab var chr "challenges of reassignment (a = 0.92)"
lab var run "reassignment uncertainty (a = 0.75)"
lab var nss "neighborhood school support (a = 0.51)"

*** sociodemographics
rename (q52age  income_cont) (age inc)

recode age (0/30 = 1) (31/45 = 2) (45/99 = 3), gen(act)
recode q57education (1 = 10) (2 = 12) (3 = 14) (4 = 16) (5 = 18), gen(edu)
recode q54householdinc (1 = 1) (2 3 = 2) (4 5 6 = 3), gen(ict)

recode q67numberchildren (0 = 0) (1 = 1) (2 = 2) (3 = 3) (4/9 = 4), gen(nch)
gen ach = (nch > 0) & !mi(nch)

gen fem = (q53gender == 2) if !mi(q53gender)

recode q56race (1 = 2) (2 3 5 6 = 3) (4 = 1), gen(race)
replace race = 3 if q55hisplatino == 1
gen wht = (race == 1) if !mi(race)

recode q61maritalstatus (1 = 1) (2 3 = 0), gen(mar)

rename q11conservative pol
gen mlk = (q46mlk == 1) if !mi(q46mlk)
gen gov = 5 - q44trustgovt
gen spp = 6 - q43socpurpol

recode q2lengthlive (1 = 5) (2 3 = 1) (4 = 2) (5 = 3) (6 = 4), gen(liv)
recode q59hrswk q62sphrswk (1 = 0) (2 = 15) (3 = 28) (4 = 37) (5 = 50), ///
  gen(rhrs shrs)
gen hrs = (rhrs + shrs)/10

recode q60comm q63spcomm (0 = 0) (1 = 10) (2 = 20) (3 = 35) (4 = 60), ///
  gen(rcom scom)
gen com = (rcom + scom)/10

recode q65nummem (0 = 0) (1 = 1) (2 = 2) (3 = 3) (4 = 4) (5/9 = 5), gen(org)

lab var act "age categories"
lab var ict "income categories"
lab var nch "number school-aged children"
lab var ach "any school-aged children"
lab var pol "political ideology"
lab var mlk "very favorable impression of MLK"
lab var gov "trust in government"
lab var spp "social purpose politics"
lab var mar "married"
lab var liv "length lived in area"
lab var hrs "household hours work per week"
lab var com "household hours commute" 
lab var org "number of organizations"

*** keeping variables for analysis
order site ds1-ds4 dr1-dr4 cr1 cr2 ru1 ru2 ns1-ns4 sm1-sm3 sc1 sc2 ///
  dsp chr dor run nss age act fem race wht mar nch ach edu inc ict ///
  liv hrs com org pol mlk gov spp
keep  site-spp

*** saving data for analysis in Stata
save sdr-data, replace


