*** Purpose: conduct initial sdr mgCFA analysis
*** Author: S Bauldry
*** Date: January 25, 2018

*** Note: this is an update of a prior mgCFA analysis that did not use weights
*** Stata does not provide model fit statistics when using weights, so I 
*** switched to Mplus for this analysis.


*** program to extract model fit statistics from Mplus output
capture program drop ModFit
program ModFit
  args lv md pf fn

  * check for warning
  qui insheet using "`fn'", clear
  qui gen warn = regexm(v1, "WARNING")
  qui tab warn
  local warn = ( r(r) > 1 )
  
  * extract fit statistics
  if (`md' < 5) {
    qui gen flag     = regexm(v1, "Number of observations")
  }
  else if (`md' > 4) {
    qui gen flag     = regexm(v1, "Total sample size")
  }
  qui gen flag1    = regexm(v1, "Chi-Square Test of Model Fit")
  qui replace flag = 1 if flag1[_n - 1] == 1
  qui replace flag = 1 if flag1[_n - 2] == 1
  qui replace flag = 1 if flag1[_n - 3] == 1
  
  qui gen flag2    = regexm(v1, "RMSEA \(Root")
  qui replace flag = 1 if flag2[_n - 1] == 1
  
  qui gen flag3    = regexm(v1, "CFI/TLI")
  qui replace flag = 1 if flag3[_n - 1] == 1
  qui replace flag = 1 if flag3[_n - 2] == 1
  qui keep if flag
  qui drop if _n > 7
  
  qui split v1, gen(x) parse("")
  qui replace x2 = x4 if x2 == "sample" | x2 == "of"
  qui replace x2 = regexr(x2, "\*", "")
  qui destring x2, replace
  
  forval i = 1/7 {
    local mf`i' = x2[`i']
  }
  
  * post model fit statistics
  post `pf' ("`lv'") (`md') (`warn') (`mf1') (`mf2') (`mf3') (`mf4') (`mf5') ///
    (`mf6') (`mf7')
end



*** program to extract parameter estimates from Mplus output
capture program drop ParEst
program ParEst
  args lv md ni pf fn

  local fn sdr-mgcfa-mplus/sdr-mgcfa-ds-1.out
  local ni = 4
  * check for warning
  qui insheet using "`fn'", clear
  qui gen warn = regexm(v1, "WARNING")
  qui tab warn
  local warn = ( r(r) > 1 )
  
  * extract parameter estimates
  if (`ni' == 4) {
    qui gen flag     = 0
    qui gen flag1    = regexm(v1, "BY")
	qui replace flag = 1 if flag1[_n - 1] == 1
    qui replace flag = 1 if flag1[_n - 2] == 1
    qui replace flag = 1 if flag1[_n - 3] == 1
	qui replace flag = 1 if flag1[_n - 4] == 1
	
	qui gen flag2    = regexm(v1, "Intercepts")
    qui replace flag = 1 if flag2[_n - 1] == 1
	qui replace flag = 1 if flag2[_n - 2] == 1
	qui replace flag = 1 if flag2[_n - 3] == 1
	qui replace flag = 1 if flag2[_n - 4] == 1
	
	qui gen flag3    = regexm(v1, "R-SQUARE")
    qui replace flag = 1 if flag3[_n - 3] == 1
	qui replace flag = 1 if flag3[_n - 4] == 1
	qui replace flag = 1 if flag3[_n - 5] == 1
	qui replace flag = 1 if flag3[_n - 6] == 1
	
	qui keep if flag
    qui drop if _n < 5 | (_n > 12 & _n < 21)
	
	qui split v1, gen(x) parse("")
	
	forval i = 1/12 {
	  local e`i' = x2[`i']
	  local s`i' = x3[`i']
	  local p`i' = x5[`i']
	}
  }
  
  else if (`ni' == 2) {
    qui gen flag     = 0
    qui gen flag1    = regexm(v1, "BY")
	qui replace flag = 1 if flag1[_n - 1] == 1
    qui replace flag = 1 if flag1[_n - 2] == 1
	
	qui gen flag2    = regexm(v1, "Intercepts")
    qui replace flag = 1 if flag2[_n - 1] == 1
	qui replace flag = 1 if flag2[_n - 2] == 1
	
	qui gen flag3    = regexm(v1, "R-SQUARE")
    qui replace flag = 1 if flag3[_n - 3] == 1
	qui replace flag = 1 if flag3[_n - 4] == 1
	
	qui keep if flag
    qui drop if _n < 3 | (_n > 6 & _n < 11)
	
	qui split v1, gen(x) parse("")
	
	
	forval i = 1/6 {
	  if (`i' < 3) {
	    local e`i' = x2[`i']
	    local s`i' = x3[`i']
	    local p`i' = x5[`i']
	  }  
	  else if (`i' > 2 & `i' < 5) {
	    local j = `i' + 2
		local e`i' = x2[`j']
	    local s`i' = x3[`j']
	    local p`i' = x5[`j']
	  }
	  else if (`i' > 4) {
	    local j = `i' + 4
		local e`i' = x2[`j']
	    local s`i' = x3[`j']
	    local p`i' = x5[`j']
	  }
	}
	
	foreach i in 3 4 7 8 11 12 {
	  local e`i' = .
	  local s`i' = .
	  local p`i' = .
	}
  }
  
  post `pf' ("`lv'") (`md') (`warn') (`e1') (`e2') (`e3') (`e4') (`e5')      ///
    (`e6') (`e7') (`e8') (`e9') (`e10') (`e11') (`e12') (`s1') (`s2') (`s3') ///
	(`s4') (`s5') (`s6') (`s7') (`s8') (`s9') (`s10') (`s11') (`s12') (`p1') ///
	(`p2') (`p3') (`p4') (`p5') (`p6') (`p7') (`p8') (`p9') (`p10') (`p11')  ///
	(`p12')
end
  
  

  
*** Extract model fit statistics
postutil clear
postfile PF1 str4 lv model warn ssize chisq df pval rmsea cfi tli using ///
  sdr-mgcfa-mfit, replace
  
forval i = 1/6 {
  ModFit DS  `i' PF1 sdr-mgcfa-mplus/sdr-mgcfa-ds-`i'.out
  ModFit DoR `i' PF1 sdr-mgcfa-mplus/sdr-mgcfa-dr-`i'.out
}

foreach i in 1 5 6 {
  ModFit NSS `i' PF1 sdr-mgcfa-mplus/sdr-mgcfa-ns-`i'.out
  ModFit CoR `i' PF1 sdr-mgcfa-mplus/sdr-mgcfa-cr-`i'.out
  ModFit RU  `i' PF1 sdr-mgcfa-mplus/sdr-mgcfa-ru-`i'.out
}

postclose PF1

*** displaying model fit statistics
use sdr-mgcfa-mfit, replace

gen bic = chisq - ln(ssize)*df

list model chisq df pval bic rmsea cfi tli if lv == "DS", clean
list model chisq df pval bic rmsea cfi tli if lv == "DoR", clean
list model chisq df pval bic rmsea cfi tli if lv == "NSS", clean
list model chisq df pval bic rmsea cfi tli if lv == "CoR", clean
list model chisq df pval bic rmsea cfi tli if lv == "RU", clean



*** Extract parameter estimates
postutil clear
postfile PF2 str4 lv model ni warn l1 l2 l3 l4 i1 i2 i3 i4 r1 r2 r3 r4 sel1  ///
  sel2 sel3 sel4 sei1 sei2 sei3 sei4 ser1 ser2 ser3 ser4 pl1 pl2 pl3 pl4 pi1 ///
  pi2 pi3 pi4 pr1 pr2 pr3 pr4 using sdr-mgcfa-parest, replace
  
ParEst DS  4 4 PF2 sdr-mgcfa-mplus/sdr-mgcfa-ds-4.out
ParEst DoR 4 4 PF2 sdr-mgcfa-mplus/sdr-mgcfa-dr-4.out
ParEst NSS 1 4 PF2 sdr-mgcfa-mplus/sdr-mgcfa-ns-1.out
ParEst CoR 1 2 PF2 sdr-mgcfa-mplus/sdr-mgcfa-cr-1.out
ParEst RU  1 2 PF2 sdr-mgcfa-mplus/sdr-mgcfa-ru-1.out
  
postclose PF1


