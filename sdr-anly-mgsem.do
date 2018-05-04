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
list if gp >= 3 & vr == 15

gen lb = b - 1.96*sqrt(v)
gen ub = b + 1.96*sqrt(v)

replace id = 5*vr + 0.3*gp

graph twoway (rcap ub lb id if lv == 3, hor) (scatter id b if lv == 3)



 mc(black)), legend(off)              ///
  xlab( , grid gstyle(dot)) ylab(1 "Wake" 2 "CMS" 3 "Rock Hill"     ///
    4 "Louisville" 5 "Nashville" 6 " " 7 "Wake 2011" 8 "Wake 2015", ///
	angle(h) grid gstyle(dot)) xtit("estimate") ytit("")            ///
  tit("Latent Means") saving(`g1')



	  
  
  
  
  
  
  
  
  
*** Model for diversity support
set matsize 10000

eststo m1

forval i = 1/5 {
  esttab m1 using m1_`i'.csv, replace csv b(%9.2f) se(%9.2f) nogap  ///
    keep(`i'.site#c.a2 `i'.site#c.a3 `i'.site#c.fem `i'.site#c.wht  ///
         `i'.site#c.mar `i'.site#c.ach `i'.site#c.edu `i'.site#c.i2 ///
	     `i'.site#c.i3 `i'.site#c.liv `i'.site#c.p2 `i'.site#c.p3   ///
		 `i'.site#c.mlk  `i'.site#c.gov `i'.site#c.spp)
}
estat ginvariant
estat eqgof


*** Model for neighborhood school support
set matsize 10000
qui sem (NSS -> ns1 ns2 ns3 ns4)                                 ///
  (NSS <- a2 a3 fem wht mar ach edu i2 i3 liv p2 p3 mlk gov spp) ///
  [pw = wt], method(mlmv) group(site) ginvariant(mcoef mcons)
eststo m2

forval i = 1/5 {
  esttab m2 using m2_`i'.csv, replace csv b(%9.2f) se(%9.2f) nogap  ///
    keep(`i'.site#c.a2 `i'.site#c.a3 `i'.site#c.fem `i'.site#c.wht  ///
         `i'.site#c.mar `i'.site#c.ach `i'.site#c.edu `i'.site#c.i2 ///
	     `i'.site#c.i3 `i'.site#c.liv `i'.site#c.p2 `i'.site#c.p3   ///
		 `i'.site#c.mlk  `i'.site#c.gov `i'.site#c.spp)
}
estat ginvariant
estat eqgof


*** Model for dangers of reassignment
qui sem (DR -> dr1 dr2 dr3 dr4)                                    ///
  (DR <- a2 a3 fem wht mar ach edu i2 i3 liv p2 p3 mlk gov spp)    ///
  [pw = wt], method(mlmv) cov(e.dr1*e.dr2 e.dr1*e.dr3) group(site) ///
  ginvariant(mcoef mcons)
eststo m3

forval i = 1/5 {
  esttab m3 using m3_`i'.csv, replace csv b(%9.2f) se(%9.2f) nogap  ///
    keep(`i'.site#c.a2 `i'.site#c.a3 `i'.site#c.fem `i'.site#c.wht  ///
         `i'.site#c.mar `i'.site#c.ach `i'.site#c.edu `i'.site#c.i2 ///
	     `i'.site#c.i3 `i'.site#c.liv `i'.site#c.p2 `i'.site#c.p3   ///
		 `i'.site#c.mlk  `i'.site#c.gov `i'.site#c.spp)
}
estat ginvariant
estat eqgof


*** Model for challenges of reassignment   
qui sem (CR -> cr1@1 cr2@1)                                     ///
  (CR <- a2 a3 fem wht mar ach edu i2 i3 liv p2 p3 mlk gov spp) ///
  [pw = wt], method(mlmv) group(site) ginvariant(mcoef mcons)
eststo m4

forval i = 1/5 {
  esttab m4 using m4_`i'.csv, replace csv b(%9.2f) se(%9.2f) nogap  ///
    keep(`i'.site#c.a2 `i'.site#c.a3 `i'.site#c.fem `i'.site#c.wht  ///
         `i'.site#c.mar `i'.site#c.ach `i'.site#c.edu `i'.site#c.i2 ///
	     `i'.site#c.i3 `i'.site#c.liv `i'.site#c.p2 `i'.site#c.p3   ///
		 `i'.site#c.mlk  `i'.site#c.gov `i'.site#c.spp)
}
estat ginvariant
estat eqgof


*** Model for reassignment uncertainties
qui sem (RU -> ru1@1 ru2@1)                                     ///
  (RU <- a2 a3 fem wht mar ach edu i2 i3 liv p2 p3 mlk gov spp) ///
  [pw = wt], method(mlmv) group(site) ginvariant(mcoef mcons)
eststo m5

forval i = 1/5 {
  esttab m5 using m5_`i'.csv, replace csv b(%9.2f) se(%9.2f) nogap  ///
    keep(`i'.site#c.a2 `i'.site#c.a3 `i'.site#c.fem `i'.site#c.wht  ///
         `i'.site#c.mar `i'.site#c.ach `i'.site#c.edu `i'.site#c.i2 ///
	     `i'.site#c.i3 `i'.site#c.liv `i'.site#c.p2 `i'.site#c.p3   ///
		 `i'.site#c.mlk  `i'.site#c.gov `i'.site#c.spp)
}
estat ginvariant
estat eqgof
