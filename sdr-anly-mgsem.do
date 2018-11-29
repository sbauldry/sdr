*** Purpose: conduct MGSEM analysis
*** Author: S Bauldry
*** Date: July 21, 2018

*** set higher matrix size and working directory
set matsize 10000
cd "~/dropbox/research/statistics/sdr/sdr-work"


*** Analysis over time
use sdr-data-time, replace

qui tab act, gen(a)
qui tab ict, gen(i)
qui tab pol, gen(p)

sem (DS -> ds1 ds2 ds3 ds4) (DS <- a2 a3 fem wht mar ach edu i2 i3 liv ///
  p2 p3 mlk gov) [pw = wt], method(mlmv) cov(e.ds1*e.ds2 e.ds1*e.ds3)  ///
  group(time) ginvariant(mcoef mcons merr)

eststo m1  
mat b1 = e(b)
mat v1 = e(V)

qui estat ginvariant
mat g1 = r(test)

qui estat eqgof
mat ra1 = r(eqfit_1)
mat rb1 = r(eqfit_2)


qui sem (NS -> ns1 ns2 ns3 ns4) (NS <- a2 a3 fem wht mar ach edu i2 i3 liv  ///
  p2 p3 mlk gov) [pw = wt], method(mlmv) group(time) ginvariant(mcoef mcons ///
  merr)

eststo m2  
mat b2 = e(b)
mat v2 = e(V)

qui estat ginvariant
mat g2 = r(test)

qui estat eqgof
mat ra2 = r(eqfit_1)
mat rb2 = r(eqfit_2)


qui sem (DR -> dr1 dr2 dr3 dr4)  (DR <- a2 a3 fem wht mar ach edu i2 i3 liv ///
  p2 p3 mlk gov) [pw = wt], method(mlmv) cov(e.dr1*e.dr2 e.dr1*e.dr3)       ///
  group(time) ginvariant(mcoef mcons)

eststo m3 
mat b3 = e(b)
mat v3 = e(V)

qui estat ginvariant
mat g3 = r(test)

qui estat eqgof
mat ra3 = r(eqfit_1)
mat rb3 = r(eqfit_2)


qui sem (CR -> cr1@1 cr2@1) (CR <- a2 a3 fem wht mar ach edu i2 i3 liv p2 ///
  p3 mlk gov) [pw = wt], method(mlmv) group(time) ginvariant(mcoef mcons)

eststo m4
mat b4 = e(b)
mat v4 = e(V)

qui estat ginvariant
mat g4 = r(test)

qui estat eqgof
mat ra4 = r(eqfit_1)
mat rb4 = r(eqfit_2)


qui sem (RU -> ru1@1 ru2@1) (RU <- a2 a3 fem wht mar ach edu i2 i3 liv p2 ///
  p3 mlk gov) [pw = wt], method(mlmv) group(time) ginvariant(mcoef mcons)

eststo m5
mat b5 = e(b)
mat v5 = e(V)

qui estat ginvariant
mat g5 = r(test)

qui estat eqgof
mat ra5 = r(eqfit_1)
mat rb5 = r(eqfit_2)




*** Analysis across sites
use sdr-data-site, replace

qui tab act, gen(a)
qui tab ict, gen(i)
qui tab pol, gen(p)

qui sem (DS -> ds1 ds2 ds3 ds4) (DS <- a2 a3 fem wht mar ach edu i2 i3 liv ///
  p2 p3 mlk gov spp) [pw = wt], method(mlmv) cov(e.ds1*e.ds2 e.ds1*e.ds3)  ///
  group(site) ginvariant(mcoef mcons merr)

eststo m6  
mat b6 = e(b)
mat v6 = e(V)

qui estat ginvariant
mat g6 = r(test)

qui estat eqgof
mat ra6 = r(eqfit_1)
mat rb6 = r(eqfit_2)


qui sem (NS -> ns1 ns2 ns3 ns4) (NS <- a2 a3 fem wht mar ach edu i2 i3 liv  ///
  p2 p3 mlk gov spp) [pw = wt], method(mlmv) group(site) ginvariant(mcoef   ///
  mcons merr)

eststo m7  
mat b7 = e(b)
mat v7 = e(V)

qui estat ginvariant
mat g7 = r(test)

qui estat eqgof
mat ra7 = r(eqfit_1)
mat rb7 = r(eqfit_2)


qui sem (DR -> dr1 dr2 dr3 dr4)  (DR <- a2 a3 fem wht mar ach edu i2 i3 liv ///
  p2 p3 mlk gov spp) [pw = wt], method(mlmv) cov(e.dr1*e.dr2 e.dr1*e.dr3)   ///
  group(site) ginvariant(mcoef mcons)

eststo m8 
mat b8 = e(b)
mat v8 = e(V)

qui estat ginvariant
mat g8 = r(test)

qui estat eqgof
mat ra8 = r(eqfit_1)
mat rb8 = r(eqfit_2)


qui sem (CR -> cr1@1 cr2@1) (CR <- a2 a3 fem wht mar ach edu i2 i3 liv p2 ///
  p3 mlk gov spp) [pw = wt], method(mlmv) group(site) ginvariant(mcoef mcons)

eststo m9
mat b9 = e(b)
mat v9 = e(V)

qui estat ginvariant
mat g9 = r(test)

qui estat eqgof
mat ra9 = r(eqfit_1)
mat rb9 = r(eqfit_2)


qui sem (RU -> ru1@1 ru2@1) (RU <- a2 a3 fem wht mar ach edu i2 i3 liv p2 ///
  p3 mlk gov spp) [pw = wt], method(mlmv) group(site) ginvariant(mcoef mcons)

eststo m10
mat b10 = e(b)
mat v10 = e(V)

qui estat ginvariant
mat g10 = r(test)

qui estat eqgof
mat ra10 = r(eqfit_1)
mat rb10 = r(eqfit_2)
  


*** Posting results
postutil clear
postfile PF1 lv gp vr b v using sdr-mgsem-res, replace

* time results
forval lv = 1/5 {
  forval gp = 1/2 {
    forval vr = 1/14 {
      if (`gp' == 1 & `vr' == 1) {
	    post PF1 (`lv') (`gp') (`vr') (b`lv'[1,1]) (v`lv'[1,1])
	  }
	
      else if (`gp' == 1 & `vr' != 1) {
	    local po = `vr' + `vr' - 1
        post PF1 (`lv') (`gp') (`vr') (b`lv'[1,`po']) (v`lv'[`po',`po'])
	  }
	
	  else if (`gp' == 2) {
	    local po = `vr' + `vr'
        post PF1 (`lv') (`gp') (`vr') (b`lv'[1,`po']) (v`lv'[`po',`po'])
	  }
    }
  }
}

* site results
forval lv = 6/10 {
  forval gp = 1/5 {
    forval vr = 1/15 {
      if (`gp' == 1 & `vr' == 1) {
	    post PF1 (`lv') (`gp') (`vr') (b`lv'[1,1]) (v`lv'[1,1])
	  }
	
      else if (`gp' == 1 & `vr' != 1) {
	    local po = `vr' + (`vr' - 1)*4
        post PF1 (`lv') (`gp') (`vr') (b`lv'[1,`po']) (v`lv'[`po',`po'])
	  }
	
	  else if (`gp' == 2) {
	    local po = `vr' + 1 + (`vr' - 1)*4
        post PF1 (`lv') (`gp') (`vr') (b`lv'[1,`po']) (v`lv'[`po',`po'])
	  }
	  
	  else if (`gp' == 3) {
	    local po = `vr' + 2 + (`vr' - 1)*4
        post PF1 (`lv') (`gp') (`vr') (b`lv'[1,`po']) (v`lv'[`po',`po'])
	  }
	  
	  else if (`gp' == 4) {
	    local po = `vr' + 3 + (`vr' - 1)*4
        post PF1 (`lv') (`gp') (`vr') (b`lv'[1,`po']) (v`lv'[`po',`po'])
	  }
	  
	  else if (`gp' == 5) {
	    local po = `vr' + 4 + (`vr' - 1)*4
        post PF1 (`lv') (`gp') (`vr') (b`lv'[1,`po']) (v`lv'[`po',`po'])
	  }
    }
  }
}

postclose PF1


*** Graphing results
use sdr-mgsem-res, replace

gen lb = b - 1.96*sqrt(v)
gen ub = b + 1.96*sqrt(v)

gen id = 3*vr + 0.3*gp

tempfile g1 g2 g3 g4 g5
graph twoway (rspike ub lb id if lv == 2, hor)                              ///
  (scatter id b if lv == 2, msize(tiny) mcolor(black)),                     ///
  legend(off) ylab(3.5 "age 31-45" 6.5 "age 46+" 9.5 "female" 12.5 "white"  ///
    15.5 "married" 18.5 "school kids" 21.5 "education" 24.5 "inc $25-75K"   ///
	27.5 "inc $76K+" 30.5 "years res" 33.5 "moderate" 36.5 "conservative"   ///
	39.5 "MLK" 42.5 "trust", angle(h) grid gstyle(dot) labs(small)) ytit("") ///
	xtit("unstandardized estimate") xlab(-1(0.5)1.5, grid gstyle(dot))      ///
	title("Neigh School") text(12.5 -1 "**") text(21.5 -1 "*")             ///
	text(27.5 -1 "*") text(30.5 -1 "**") text(33.5 -1 "**")                 ///
	text(36.5 -1 "**") text(39.5 -1 "***") saving(`g1')

graph twoway (rspike ub lb id if lv == 1, hor)                              ///
  (scatter id b if lv == 1, msize(tiny) mcolor(black)),                     ///
  legend(off) ylab(3.5 "age 31-45" 6.5 "age 46+" 9.5 "female" 12.5 "white"  ///
    15.5 "married" 18.5 "school kids" 21.5 "education" 24.5 "inc $25-75K"   ///
	27.5 "inc $76K+" 30.5 "years res" 33.5 "moderate" 36.5 "conservative"   ///
	39.5 "MLK" 42.5 "trust", angle(h) grid gstyle(dot) labs(small)) ytit("") ///
	xtit("unstandardized estimate") xlab(-1(0.5)1.5, grid gstyle(dot))      ///
	title("Diversity") text(12.5 -1 "*") saving(`g2')

graph twoway (rspike ub lb id if lv == 4, hor)                              ///
  (scatter id b if lv == 4, msize(tiny) mcolor(black)),                     ///
  legend(off) ylab(3.5 "age 31-45" 6.5 "age 46+" 9.5 "female" 12.5 "white"  ///
    15.5 "married" 18.5 "school kids" 21.5 "education" 24.5 "inc $25-75K"   ///
	27.5 "inc $76K+" 30.5 "years res" 33.5 "moderate" 36.5 "conservative"   ///
	39.5 "MLK" 42.5 "trust", angle(h) grid gstyle(dot) labs(small)) ytit("") ///
	xtit("unstandardized estimate") xlab(-1(0.5)1.5, grid gstyle(dot))      ///
	title("Challenges") text(24.5 -1 "*") text(27.5 -1 "*")                 ///
	text(33.5 -1 "*") saving(`g3')

graph twoway (rspike ub lb id if lv == 3, hor)                              ///
  (scatter id b if lv == 3, msize(tiny) mcolor(black)),                     ///
  legend(off) ylab(3.5 "age 31-45" 6.5 "age 46+" 9.5 "female" 12.5 "white"  ///
    15.5 "married" 18.5 "school kids" 21.5 "education" 24.5 "inc $25-75K"   ///
	27.5 "inc $76K+" 30.5 "years res" 33.5 "moderate" 36.5 "conservative"   ///
	39.5 "MLK" 42.5 "trust", angle(h) grid gstyle(dot) labs(small)) ytit("") ///
	xtit("unstandardized estimate") xlab(-1(0.5)1.5, grid gstyle(dot))      ///
	title("Dangers") text(3.5 -1 "*") text(6.5 -1 "*") text(24.5 -1 "*")    ///
	text(27.5 -1 "*") saving(`g4')

graph twoway (rspike ub lb id if lv == 5, hor)                              ///
  (scatter id b if lv == 5, msize(tiny) mcolor(black)),                     ///
  legend(off) ylab(3.5 "age 31-45" 6.5 "age 46+" 9.5 "female" 12.5 "white"  ///
    15.5 "married" 18.5 "school kids" 21.5 "education" 24.5 "inc $25-75K"   ///
	27.5 "inc $76K+" 30.5 "years res" 33.5 "moderate" 36.5 "conservative"   ///
	39.5 "MLK" 42.5 "trust", angle(h) grid gstyle(dot) labs(small)) ytit("") ///
	xtit("unstandardized estimate") xlab(-1(0.5)1.5, grid gstyle(dot))      ///
	title("Uncertainty") text(27.5 -1 "*") saving(`g5')

graph combine "`g1'" "`g2'" "`g3'" "`g4'" "`g5'"
graph export ~/desktop/fig3.pdf, replace
	

	
	
	
tempfile g1 g2 g3 g4 g5
graph twoway (rspike ub lb id if lv == 6, hor)                              ///
  (scatter id b if lv == 6, msize(tiny) mcolor(black)),                     ///
  legend(off) ylab(4.5 "age 31-45" 7.5 "age 46+" 10.5 "female" 13.5 "white" ///
    16.5 "married" 19.5 "school age kids" 22.5 "education"                  ///
	25.5 "income 25-75K" 28.5 "income 76K+" 31.5 "years lived"              ///
	34.5 "moderate" 37.5 "conservative" 40.5 "MLK very favorable"           ///
	43.5 "trust government" 46.5 "social purpose politics", angle(h) grid   ///
	gstyle(dot)) ytit("") xtit("unstandardized estimate") xlab(-1(0.5)1,    ///
  grid gstyle(dot)) title("Diversity Support") saving(`g1')
  
graph twoway (rspike ub lb id if lv == 7, hor)                              ///
  (scatter id b if lv == 7, msize(tiny) mcolor(black)),                     ///
  legend(off) ylab(4.5 "age 31-45" 7.5 "age 46+" 10.5 "female" 13.5 "white" ///
    16.5 "married" 19.5 "school age kids" 22.5 "education"                  ///
	25.5 "income 25-75K" 28.5 "income 76K+" 31.5 "years lived"              ///
	34.5 "moderate" 37.5 "conservative" 40.5 "MLK very favorable"           ///
	43.5 "trust government" 46.5 "social purpose politics", angle(h) grid   ///
	gstyle(dot)) ytit("") xtit("unstandardized estimate") xlab(-1(0.5)1,    ///
  grid gstyle(dot)) title("Neighborhood Sch Sup") text(4.5 -1 "*")          ///
  text(7.5 -1 "*") text(16.5 -1 "*") saving(`g2')
  
graph twoway (rspike ub lb id if lv == 8, hor)                              ///
  (scatter id b if lv == 8, msize(tiny) mcolor(black)),                     ///
  legend(off) ylab(4.5 "age 31-45" 7.5 "age 46+" 10.5 "female" 13.5 "white" ///
    16.5 "married" 19.5 "school age kids" 22.5 "education"                  ///
	25.5 "income 25-75K" 28.5 "income 76K+" 31.5 "years lived"              ///
	34.5 "moderate" 37.5 "conservative" 40.5 "MLK very favorable"           ///
	43.5 "trust government" 46.5 "social purpose politics", angle(h) grid   ///
	gstyle(dot)) ytit("") xtit("unstandardized estimate") xlab(-1(0.5)1,    ///
  grid gstyle(dot)) title("Dangers") text(4.5 -1 "*") text(7.5 -1 "**")     ///
  text(10.5 -1 "*") text(25.5 -1 "***") text(28.5 -1 "*") saving(`g3')
  
graph twoway (rspike ub lb id if lv == 9, hor)                              ///
  (scatter id b if lv == 9, msize(tiny) mcolor(black)),                     ///
  legend(off) ylab(4.5 "age 31-45" 7.5 "age 46+" 10.5 "female" 13.5 "white" ///
    16.5 "married" 19.5 "school age kids" 22.5 "education"                  ///
	25.5 "income 25-75K" 28.5 "income 76K+" 31.5 "years lived"              ///
	34.5 "moderate" 37.5 "conservative" 40.5 "MLK very favorable"           ///
	43.5 "trust government" 46.5 "social purpose politics", angle(h) grid   ///
	gstyle(dot)) ytit("") xtit("unstandardized estimate") xlab(-1(0.5)1,    ///
  grid gstyle(dot)) title("Challenges") text(25.5 -1 "*") text(46.5 -1 "*") ///
  saving(`g4')
  
graph twoway (rspike ub lb id if lv == 10, hor)                             ///
  (scatter id b if lv == 10, msize(tiny) mcolor(black)),                    ///
  legend(off) ylab(4.5 "age 31-45" 7.5 "age 46+" 10.5 "female" 13.5 "white" ///
    16.5 "married" 19.5 "school age kids" 22.5 "education"                  ///
	25.5 "income 25-75K" 28.5 "income 76K+" 31.5 "years lived"              ///
	34.5 "moderate" 37.5 "conservative" 40.5 "MLK very favorable"           ///
	43.5 "trust government" 46.5 "social purpose politics", angle(h) grid   ///
	gstyle(dot)) ytit("") xtit("unstandardized estimate") xlab(-1(0.5)1,    ///
  grid gstyle(dot)) title("Uncertainty") text(28.5 -1 "*") saving(`g5')
graph export ~/desktop/fig9.pdf, replace
  
graph combine "`g1'" "`g2'"
graph export ~/desktop/fig7.pdf, replace

graph combine "`g3'" "`g4'"
graph export ~/desktop/fig8.pdf, replace
