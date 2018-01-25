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
  qui gen flag     = regexm(v1, "Total sample size")
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

  local fn sdr-mgcfa-mplus/sdr-mgcfa-cr-1.out
  local ni = 2
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
	list x1 x2 x3 x4 x5, clean
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
	
	forval i = 1/2 {
	  local e`i' = x2[`i']
	  local s`i' = x3[`i']
	  local p`i' = x5[`i']
	}
	
	forval i = 3/4 {
	  local e`i' = .
	  local s`i' = .
	  local p`i' = .
	}
  }
  
  post `pf' ("`lv'") (`md') (`warn') (`e1') (`e2') (`e3') (`e4') (`s1') ///
    (`s2') (`s3') (`s4') (`p1') (`p2') (`p3') (`p4')
end
  
  

  
  
  
  





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


