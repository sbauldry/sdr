*** Purpose: conduct initial sdr mgSEM analysis
*** Author: S Bauldry
*** Date: December 28, 2017

*** loading data
cd "~/dropbox/research/hlthineq/sdr/sdr-work"
use sdr-data, replace

*** Preparing indicator variables
qui tab act, gen(a)
qui tab ict, gen(i)
qui tab pol, gen(p)


*** Model for diversity support
set matsize 10000
qui sem (DS -> ds1 ds2 ds3 ds4)                                              ///
  (DS <- a2 a3 fem wht mar ach edu i2 i3 liv hrs com org p2 p3 mlk gov spp)  ///
  [pw = wt], method(mlmv) cov(e.ds1*e.ds2 e.ds1*e.ds3) group(site)           ///
  ginvariant(mcoef mcons)
eststo m1

forval i = 1/5 {
  esttab m1 using m1_`i'.csv, replace csv b(%9.2f) se(%9.2f) nogap  ///
    keep(`i'.site#c.a2 `i'.site#c.a3 `i'.site#c.fem `i'.site#c.wht  ///
         `i'.site#c.mar `i'.site#c.ach `i'.site#c.edu `i'.site#c.i2 ///
	     `i'.site#c.i3 `i'.site#c.liv `i'.site#c.hrs `i'.site#c.com ///
	     `i'.site#c.org `i'.site#c.p2 `i'.site#c.p3 `i'.site#c.mlk  ///
		 `i'.site#c.gov `i'.site#c.spp)
}
estat ginvariant
estat eqgof


*** Model for neighborhood school support
set matsize 10000
qui sem (NSS -> ns1 ns2 ns3 ns4)                                             ///
  (NSS <- a2 a3 fem wht mar ach edu i2 i3 liv hrs com org p2 p3 mlk gov spp) ///
  [pw = wt], method(mlmv) group(site) ginvariant(mcoef mcons)
eststo m2

forval i = 1/5 {
  esttab m2 using m2_`i'.csv, replace csv b(%9.2f) se(%9.2f) nogap  ///
    keep(`i'.site#c.a2 `i'.site#c.a3 `i'.site#c.fem `i'.site#c.wht  ///
         `i'.site#c.mar `i'.site#c.ach `i'.site#c.edu `i'.site#c.i2 ///
	     `i'.site#c.i3 `i'.site#c.liv `i'.site#c.hrs `i'.site#c.com ///
	     `i'.site#c.org `i'.site#c.p2 `i'.site#c.p3 `i'.site#c.mlk  ///
		 `i'.site#c.gov `i'.site#c.spp)
}
estat ginvariant
estat eqgof


*** Model for dangers of reassignment
qui sem (DR -> dr1 dr2 dr3 dr4)                                              ///
  (DR <- a2 a3 fem wht mar ach edu i2 i3 liv hrs com org p2 p3 mlk gov spp)  ///
  [pw = wt], method(mlmv) cov(e.dr1*e.dr2 e.dr1*e.dr3) group(site)           ///
  ginvariant(mcoef mcons)
eststo m3

forval i = 1/5 {
  esttab m3 using m3_`i'.csv, replace csv b(%9.2f) se(%9.2f) nogap  ///
    keep(`i'.site#c.a2 `i'.site#c.a3 `i'.site#c.fem `i'.site#c.wht  ///
         `i'.site#c.mar `i'.site#c.ach `i'.site#c.edu `i'.site#c.i2 ///
	     `i'.site#c.i3 `i'.site#c.liv `i'.site#c.hrs `i'.site#c.com ///
	     `i'.site#c.org `i'.site#c.p2 `i'.site#c.p3 `i'.site#c.mlk  ///
		 `i'.site#c.gov `i'.site#c.spp)
}
estat ginvariant
estat eqgof


*** Model for challenges of reassignment   
qui sem (CR -> cr1@1 cr2@1)                                                 ///
  (CR <- a2 a3 fem wht mar ach edu i2 i3 liv hrs com org p2 p3 mlk gov spp) ///
  [pw = wt], method(mlmv) group(site) ginvariant(mcoef mcons)
eststo m4

forval i = 1/5 {
  esttab m4 using m4_`i'.csv, replace csv b(%9.2f) se(%9.2f) nogap  ///
    keep(`i'.site#c.a2 `i'.site#c.a3 `i'.site#c.fem `i'.site#c.wht  ///
         `i'.site#c.mar `i'.site#c.ach `i'.site#c.edu `i'.site#c.i2 ///
	     `i'.site#c.i3 `i'.site#c.liv `i'.site#c.hrs `i'.site#c.com ///
	     `i'.site#c.org `i'.site#c.p2 `i'.site#c.p3 `i'.site#c.mlk  ///
		 `i'.site#c.gov `i'.site#c.spp)
}
estat ginvariant
estat eqgof


*** Model for reassignment uncertainties
qui sem (RU -> ru1@1 ru2@1)                                                 ///
  (RU <- a2 a3 fem wht mar ach edu i2 i3 liv hrs com org p2 p3 mlk gov spp) ///
  [pw = wt], method(mlmv) group(site) ginvariant(mcoef mcons)
eststo m5

forval i = 1/5 {
  esttab m5 using m5_`i'.csv, replace csv b(%9.2f) se(%9.2f) nogap  ///
    keep(`i'.site#c.a2 `i'.site#c.a3 `i'.site#c.fem `i'.site#c.wht  ///
         `i'.site#c.mar `i'.site#c.ach `i'.site#c.edu `i'.site#c.i2 ///
	     `i'.site#c.i3 `i'.site#c.liv `i'.site#c.hrs `i'.site#c.com ///
	     `i'.site#c.org `i'.site#c.p2 `i'.site#c.p3 `i'.site#c.mlk  ///
		 `i'.site#c.gov `i'.site#c.spp)
}
estat ginvariant
estat eqgof
