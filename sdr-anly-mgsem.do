*** Purpose: conduct initial sdr mgSEM analysis
*** Author: S Bauldry
*** Date: December 28, 2017

*** loading data
cd "~/dropbox/research/hlthineq/sdr/sdr-work"
use sdr-data, replace

*** Model for diversity support
qui tab act, gen(a)
qui tab ict, gen(i)
qui tab pol, gen(p)

set matsize 10000
qui sem (DS -> ds1 ds2 ds3 ds4)                                              ///
  (DS <- a2 a3 fem wht mar ach edu i2 i3 liv hrs com org p2 p3 mlk gov spp)  ///
  [pw = wt], method(mlmv) cov(e.ds1*e.ds2 e.ds1*e.ds3) group(site)           ///
  ginvariant(mcoef mcons)
eststo m1

forval i = 1/5 {
  esttab m1 using s`i'.csv, replace csv b(%9.2f) se(%9.2f) nogap    ///
    keep(`i'.site#c.a2 `i'.site#c.a3 `i'.site#c.fem `i'.site#c.wht  ///
         `i'.site#c.mar `i'.site#c.ach `i'.site#c.edu `i'.site#c.i2 ///
	     `i'.site#c.i3 `i'.site#c.liv `i'.site#c.hrs `i'.site#c.com ///
	     `i'.site#c.org `i'.site#c.p2 `i'.site#c.p3 `i'.site#c.mlk  ///
		 `i'.site#c.gov `i'.site#c.spp)
}

estat ginvariant
estat eqgof
