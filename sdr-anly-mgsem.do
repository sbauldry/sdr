*** Purpose: conduct MGSEM analysis
*** Author: S Bauldry
*** Date: May 4, 2018

*** set higher matrix size and working directory
set matsize 10000
cd "~/dropbox/research/statistics/sdr/sdr-work"


*** Analysis over time
use sdr-data-time, replace

qui tab act, gen(a)
qui tab ict, gen(i)
qui tab pol, gen(p)

qui sem (DS -> ds1 ds2 ds3 ds4) (DS <- a2 a3 fem wht mar ach edu i2 i3 liv ///
  p2 p3 mlk gov) [pw = wt], method(mlmv) cov(e.ds1*e.ds2 e.ds1*e.ds3)      ///
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



*** Analysis across sites
use sdr-data-site, replace

qui tab act, gen(a)
qui tab ict, gen(i)
qui tab pol, gen(p)

qui sem (DS -> ds1 ds2 ds3 ds4) (DS <- a2 a3 fem wht mar ach edu i2 i3 liv ///
  p2 p3 mlk gov spp) [pw = wt], method(mlmv) cov(e.ds1*e.ds2 e.ds1*e.ds3)  ///
  group(site) ginvariant(mcoef mcons merr)

eststo m3  
mat b3 = e(b)
mat v3 = e(V)

qui estat ginvariant
mat g3 = r(test)

qui estat eqgof
mat ra3 = r(eqfit_1)
mat rb3 = r(eqfit_2)


qui sem (NS -> ns1 ns2 ns3 ns4) (NS <- a2 a3 fem wht mar ach edu i2 i3 liv  ///
  p2 p3 mlk gov spp) [pw = wt], method(mlmv) group(site) ginvariant(mcoef   ///
  mcons merr)

eststo m4  
mat b4 = e(b)
mat v4 = e(V)

qui estat ginvariant
mat g4 = r(test)

qui estat eqgof
mat ra4 = r(eqfit_1)
mat rb4 = r(eqfit_2)
  


*** Posting results
tempfile d1
postutil clear
postfile PF1 lv gp vr b v using `d1', replace

* time results
forval lv = 1/2 {
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
forval lv = 3/4 {
  forval gp = 1/5 {
    forval vr = 1/15 {
	  local gg = `gp' + 2
      if (`gp' == 1 & `vr' == 1) {
	    post PF1 (`lv') (`gg') (`vr') (b`lv'[1,1]) (v`lv'[1,1])
	  }
	
      else if (`gp' == 1 & `vr' != 1) {
	    local po = `vr' + `vr' - 1
        post PF1 (`lv') (`gg') (`vr') (b`lv'[1,`po']) (v`lv'[`po',`po'])
	  }
	
	  else if (`gp' == 2) {
	    local po = `vr' + `vr'
        post PF1 (`lv') (`gg') (`vr') (b`lv'[1,`po']) (v`lv'[`po',`po'])
	  }
	  
	  else if (`gp' == 3) {
	    local po = `vr' + `vr' + 1
        post PF1 (`lv') (`gg') (`vr') (b`lv'[1,`po']) (v`lv'[`po',`po'])
	  }
	  
	  else if (`gp' == 4) {
	    local po = `vr' + `vr' + 2
        post PF1 (`lv') (`gg') (`vr') (b`lv'[1,`po']) (v`lv'[`po',`po'])
	  }
	  
	  else if (`gp' == 5) {
	    local po = `vr' + `vr' + 3
        post PF1 (`lv') (`gg') (`vr') (b`lv'[1,`po']) (v`lv'[`po',`po'])
	  }
    }
  }
}

postclose PF1


*** Graphing results
use `d1', replace

gen lb = b - 1.96*sqrt(v)
gen ub = b + 1.96*sqrt(v)

gen id = 3*vr + 0.3*gp

tempfile g1 g2 g3 g4
graph twoway (rspike ub lb id if lv == 1, hor)                              ///
  (scatter id b if lv == 1, msize(tiny) mcolor(black)),                     ///
  legend(off) ylab(3.5 "age 31-45" 6.5 "age 46+" 9.5 "female" 12.5 "white"  ///
    15.5 "married" 18.5 "school age kids" 21.5 "education"                  ///
	24.5 "income 25-75K" 27.5 "income 76K+" 30.5 "years lived"              ///
	33.5 "moderate" 36.5 "conservative" 39.5 "MLK very favorable"           ///
	42.5 "trust government", angle(h) grid gstyle(dot)) ytit("")            ///
	xtit("unstandardized estimate") xlab(-1(0.5)1, grid gstyle(dot))        ///
	title("Diversity Support") text(12.5 -1 "*") saving(`g1')

graph twoway (rspike ub lb id if lv == 2, hor)                              ///
  (scatter id b if lv == 2, msize(tiny) mcolor(black)),                     ///
  legend(off) ylab(3.5 "age 31-45" 6.5 "age 46+" 9.5 "female" 12.5 "white"  ///
    15.5 "married" 18.5 "school age kids" 21.5 "education"                  ///
	24.5 "income 25-75K" 27.5 "income 76K+" 30.5 "years lived"              ///
	33.5 "moderate" 36.5 "conservative" 39.5 "MLK very favorable"           ///
	42.5 "trust government", angle(h) grid gstyle(dot)) ytit("")            ///
	xtit("unstandardized estimate") xlab(-1(0.5)1, grid gstyle(dot))        ///
	title("Neighborhood School Support") text(12.5 -1 "**")                 ///
	text(21.5 -1 "*") text(27.5 -1 "*") text(30.5 -1 "**")                  ///
	text(33.5 -1 "**") text(36.5 -1 "**") text(39.5 -1 "***") saving(`g2')

graph twoway (rspike ub lb id if lv == 3, hor) ///
  (scatter id b if lv == 3, msize(tiny) mcolor(black)), ///
  legend(off) ylab(4.5 "age 31-45" 7.5 "age 46+" 10.5 "female" 13.5 "white" ///
    16.5 "married" 19.5 "school age kids" 22.5 "education"                  ///
	25.5 "income 25-75K" 28.5 "income 76K+" 31.5 "years lived"              ///
	34.5 "moderate" 37.5 "conservative" 40.5 "MLK very favorable"           ///
	43.5 "trust government" 46.5 "social purpose politics", angle(h) grid   ///
	gstyle(dot)) ytit("") xtit("unstandardized estimate") xlab(-1(0.5)1,    ///
  grid gstyle(dot)) title("Diversity Support") saving(`g3')
  
graph twoway (rspike ub lb id if lv == 4, hor) ///
  (scatter id b if lv == 4, msize(tiny) mcolor(black)), ///
  legend(off) ylab(4.5 "age 31-45" 7.5 "age 46+" 10.5 "female" 13.5 "white" ///
    16.5 "married" 19.5 "school age kids" 22.5 "education"                  ///
	25.5 "income 25-75K" 28.5 "income 76K+" 31.5 "years lived"              ///
	34.5 "moderate" 37.5 "conservative" 40.5 "MLK very favorable"           ///
	43.5 "trust government" 46.5 "social purpose politics", angle(h) grid   ///
	gstyle(dot)) ytit("") xtit("unstandardized estimate") xlab(-1(0.5)1,    ///
  grid gstyle(dot)) title("Neighborhood School Support") text(4.5 -1 "*")   ///
  text(7.5 -1 "*") text(16.5 -1 "*") saving(`g4')
  
graph combine "`g1'" "`g2'"
graph export ~/desktop/fig2.pdf, replace

graph combine "`g3'" "`g4'"
graph export ~/desktop/fig3.pdf, replace
  



