*** Purpose: conduct initial sdr mgCFA analysis
*** Author: S Bauldry
*** Date: January 25, 2018

*** Note: this is an update of a prior mgCFA analysis that did not use weights
*** Stata does not provide model fit statistics when using weights, so I 
*** switched to Mplus for this analysis.


*** program to extract latent means and variances from Mplus output
capture program drop ParEst
program ParEst
  args lv f3 md pf fn
  
  * check for warning
  qui insheet using "`fn'", clear
  qui gen warn = regexm(v1, "WARNING")
  qui tab warn
  local warn = ( r(r) > 1 )
  
  * extract parameter estimates
  qui gen flag     = 0
  qui gen flag1    = regexm(v1, "Means")
  qui replace flag = 1 if flag1[_n - 1] == 1
  
  qui gen flag2    = regexm(v1, "Variances")
  qui replace flag = 1 if flag2[_n - 1] == 1
  
  qui gen flag3    = regexm(v1, "`f3'")
  qui replace flag = 0 if flag3 == 1
  
  qui gen cntflg = sum(flag)
  qui replace flag = 0 if cntflg > 10
  drop cntflg
  
  qui keep if flag
  qui split v1, gen(x) parse("")
  
  forval i = 1/10 {
    local e`i' = x2[`i']
	local s`i' = x3[`i']
  }
  
  post `pf' ("`lv'") (`md') (`warn') (`e1') (`e2') (`e3') (`e4') (`e5')    ///
    (`e6') (`e7') (`e8') (`e9') (`e10') (`s1') (`s2') (`s3') (`s4') (`s5') ///
	(`s6') (`s7') (`s8') (`s9') (`s10') 
end
  

*** Extract parameter estimates
tempfile d1
postutil clear
postfile PF1 str4 lv model warn m1 v1 m2 v2 m3 v3 m4 v4 m5 v5 sm1 sv1 sm2 ///
  sv2 sm3 sv3 sm4 sv4 sm5 sv5 using `d1', replace
  
ParEst DS  DS1 6 PF1 sdr-mgcfa-mplus-2/sdr-mgcfa-site-ds-6.out
ParEst NSS NS1 6 PF1 sdr-mgcfa-mplus-2/sdr-mgcfa-site-ns-6.out

postclose PF1


*** Prepare figure of latent means and variances
use `d1', replace

drop model warn
reshape long m v sm sv, i(lv) j(site)

foreach x in m v {
  gen lb`x' = `x' - 1.96*s`x'
  gen ub`x' = `x' + 1.96*s`x'
}

gen id = _n

tempfile g1 g2 g3 g4 g5 g6
graph twoway (rcap ubm lbm id if lv == "DS", hor) ///
  (scatter id m if lv == "DS", mc(black)), legend(off) ///
  xlab( , grid gstyle(dot)) ylab(1 "Wake" 2 "CMS" 3 "Rock Hill" ///
    4 "Louisville" 5 "Nashville", angle(h) grid gstyle(dot))    ///
  xtit("estimate") ytit("") tit("Latent Means") ///
  saving(`g1')
  
graph twoway (rcap ubv lbv id if lv == "DS", hor) ///
  (scatter id v if lv == "DS", mc(black)), legend(off) ///
  xlab( , grid gstyle(dot)) ylab(1 "Wake" 2 "CMS" 3 "Rock Hill" ///
    4 "Louisville" 5 "Nashville", angle(h) grid gstyle(dot))    ///
  xtit("estimate") ytit("") tit("Latent Variances") ///
  saving(`g2')
  
graph combine "`g1'" "`g2'", rows(1) tit("Diversity Support") saving(`g3')
  
graph twoway (rcap ubm lbm id if lv == "NSS", hor) ///
  (scatter id m if lv == "NSS", mc(black)), legend(off) ///
  xlab( , grid gstyle(dot)) ylab(6 "Wake" 7 "CMS" 8 "Rock Hill" ///
    9 "Louisville" 10 "Nashville", angle(h) grid gstyle(dot))    ///
  xtit("estimate") ytit("") tit("Latent Means") ///
  saving(`g4')
  
graph twoway (rcap ubv lbv id if lv == "NSS", hor) ///
  (scatter id v if lv == "NSS", mc(black)), legend(off) ///
  xlab( , grid gstyle(dot)) ylab(6 "Wake" 7 "CMS" 8 "Rock Hill" ///
    9 "Louisville" 10 "Nashville", angle(h) grid gstyle(dot))    ///
  xtit("estimate") ytit("") tit("Latent Variances")  ///
  saving(`g5')
  
graph combine "`g4'" "`g5'", rows(1) tit("Neighborhood School Support") saving(`g6')
  
graph combine "`g3'" "`g6'", rows(2)






