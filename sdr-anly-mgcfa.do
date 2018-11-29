*** Purpose: conduct sdr mgCFA analysis
*** Author: S Bauldry
*** Date: July 21, 2018


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
  
  if ("`md'" == "site") {
    qui gen cntflg = sum(flag)
    qui replace flag = 0 if cntflg > 10
    drop cntflg
  
    qui keep if flag
    qui split v1, gen(x) parse("")
  
    forval i = 1/10 {
      local e`i' = x2[`i']
	  local s`i' = x3[`i']
    }
  }
  
  if ("`md'" == "time") {
    qui gen cntflg = sum(flag)
    qui replace flag = 0 if cntflg > 4
    drop cntflg
  
    qui keep if flag
    qui split v1, gen(x) parse("")
  
    forval i = 1/10 {
	  if (`i' < 5) {
        local e`i' = x2[`i']
	    local s`i' = x3[`i']
	  }
	  else {
	    local e`i' = .
	    local s`i' = .
	  }
    }
  }
  
  
  post `pf' ("`lv'") ("`md'") (`warn') (`e1') (`e2') (`e3') (`e4') (`e5')  ///
    (`e6') (`e7') (`e8') (`e9') (`e10') (`s1') (`s2') (`s3') (`s4') (`s5') ///
	(`s6') (`s7') (`s8') (`s9') (`s10') 
end
  

*** Extract parameter estimates
tempfile d1
postutil clear
postfile PF1 str4 lv str4 model warn m1 v1 m2 v2 m3 v3 m4 v4 m5 v5 sm1 sv1 ///
  sm2 sv2 sm3 sv3 sm4 sv4 sm5 sv5 using `d1', replace

ParEst DS  DS1 time PF1 sdr-exv2/sdr-exv2-ds-m2.out
ParEst NSS NS1 time PF1 sdr-exv2/sdr-exv2-ns-m2.out
ParEst DR  DR1 time PF1 sdr-exv2/sdr-exv2-dr-m2.out
ParEst RU  RU1 time PF1 sdr-exv2/sdr-exv2-ru-m2.out
ParEst CR  CR1 time PF1 sdr-exv2/sdr-exv2-cr-m2.out

postclose PF1


*** Prepare figure of latent means and variances over time
use `d1', replace

drop warn
gen id = _n
reshape long m v sm sv, i(id) j(site)
drop id
drop if mi(m)

foreach x in m v {
  gen lb`x' = `x' - 1.96*s`x'
  gen ub`x' = `x' + 1.96*s`x'
}

gen id = 1 if lv == "RU" & site == 1
replace id = 1.5 if lv == "RU" & site == 2
replace id = 2.5 if lv == "DR" & site == 1
replace id = 3   if lv == "DR" & site == 2
replace id = 4   if lv == "CR" & site == 1
replace id = 4.5 if lv == "CR" & site == 2
replace id = 5.5 if lv == "DS" & site == 1
replace id = 6   if lv == "DS" & site == 2
replace id = 7   if lv == "NSS" & site == 1
replace id = 7.5 if lv == "NSS" & site == 2

tempfile g1 g2 
graph twoway (rcap ubm lbm id, hor) (scatter id m, mc(black)), legend(off) ///
  xlab(-0.6(0.2)0.6, grid gstyle(dot)) ylab(1 "RU 2015" 1.5 "RU 2011"      ///
    2.5 "RD 2015" 3 "RD 2011" 4 "CR 2015" 4.5 "CR 2011" 5.5 "DS 2015"      ///
	6 "DS 2011" 7 "NS 2015" 7.5 "NS 2011", angle(h) grid gstyle(dot))      ///
  xtit("estimate") ytit("") tit("Latent Means") saving(`g1')
  
graph twoway (rcap ubv lbv id, hor) (scatter id v, mc(black)), legend(off) ///
  xlab(0(0.2)1.4, grid gstyle(dot)) ylab(1 "RU 2015" 1.5 "RU 2011"         ///
    2.5 "RD 2015" 3 "RD 2011" 4 "CR 2015" 4.5 "CR 2011" 5.5 "DS 2015"      ///
	6 "DS 2011" 7 "NS 2015" 7.5 "NS 2011", angle(h) grid gstyle(dot))      ///
  xtit("estimate") ytit("") tit("Latent Variances") saving(`g2')
  
graph combine "`g1'" "`g2'", rows(1)
graph export ~/desktop/fig1.pdf, replace 

  
  
  
  
graph twoway (rcap ubv lbv id if lv == "DS", hor)                       ///
  (scatter id v if lv == "DS", mc(black)), legend(off)                  ///
  xlab(0(0.2)1.6, grid gstyle(dot)) ylab(1 "Wake" 2 "CMS" 3 "Rock Hill" ///
    4 "Louisville" 5 "Nashville" 6 " " 7 "Wake 2015" 8 "Wake 2011",     ///
	angle(h) grid gstyle(dot)) xtit("estimate") ytit("")                ///
  tit("Latent Variances") saving(`g2')
  
graph combine "`g1'" "`g2'", rows(1) tit("Diversity Support") saving(`g3')
  
graph twoway (rcap ubm lbm id if lv == "NSS", hor)                         ///
  (scatter id m if lv == "NSS", mc(black)), legend(off)                    ///
  xlab(-0.6(0.2)0.6, grid gstyle(dot)) ylab(1 "Wake" 2 "CMS" 3 "Rock Hill" ///
    4 "Louisville" 5 "Nashville" 6 " " 7 "Wake 2015" 8 "Wake 2011",        ///
	angle(h) grid gstyle(dot)) xtit("estimate") ytit("")                   ///
  tit("Latent Means") saving(`g4')
  
graph twoway (rcap ubv lbv id if lv == "NSS", hor)                       ///
  (scatter id v if lv == "NSS", mc(black)), legend(off)                  ///
  xlab(0(0.2)1.6, grid gstyle(dot)) ylab(1 "Wake" 2 "CMS" 3 "Rock Hill"  ///
    4 "Louisville" 5 "Nashville" 6 " " 7 "Wake 2015" 8 "Wake 2011",      ///
	angle(h) grid gstyle(dot)) xtit("estimate") ytit("")                 ///
  tit("Latent Variances") saving(`g5')
  
graph combine "`g4'" "`g5'", rows(1) tit("Neighborhood School Support") ///
  saving(`g6')
  
graph combine "`g3'" "`g6'", rows(2)




tempfile g1 g2 g3 g4 g5 g6
graph twoway (rcap ubm lbm id if lv == "DR", hor)                          ///
  (scatter id m if lv == "DR", mc(black)), legend(off)                     ///
  xlab(-0.6(0.2)0.6, grid gstyle(dot)) ylab(1 "Wake" 2 "CMS" 3 "Rock Hill" ///
    4 "Louisville" 5 "Nashville" 6 " " 7 "Wake 2015" 8 "Wake 2011",        ///
	angle(h) grid gstyle(dot)) xtit("estimate") ytit("")                   ///
  tit("Latent Means") saving(`g1')
  
graph twoway (rcap ubv lbv id if lv == "DR", hor)                        ///
  (scatter id v if lv == "DR", mc(black)), legend(off)                   ///
  xlab(0(0.2)1.6, grid gstyle(dot)) ylab(1 "Wake" 2 "CMS" 3 "Rock Hill"  ///
    4 "Louisville" 5 "Nashville" 6 " " 7 "Wake 2015" 8 "Wake 2011",      ///
	angle(h) grid gstyle(dot)) xtit("estimate") ytit("")                 ///
  tit("Latent Variances") saving(`g2')
  
graph combine "`g1'" "`g2'", rows(1) tit("Dangers of Reassignment") saving(`g3')
  
graph twoway (rcap ubm lbm id if lv == "CR", hor)                          ///
  (scatter id m if lv == "CR", mc(black)), legend(off)                     ///
  xlab(-0.6(0.2)0.6, grid gstyle(dot)) ylab(1 "Wake" 2 "CMS" 3 "Rock Hill" ///
    4 "Louisville" 5 "Nashville" 6 " " 7 "Wake 2015" 8 "Wake 2011",        ///
	angle(h) grid gstyle(dot)) xtit("estimate") ytit("")                   ///
  tit("Latent Means") saving(`g4')
  
graph twoway (rcap ubv lbv id if lv == "CR", hor)                       ///
  (scatter id v if lv == "CR", mc(black)), legend(off)                  ///
  xlab(0(0.2)1.6, grid gstyle(dot)) ylab(1 "Wake" 2 "CMS" 3 "Rock Hill" ///
    4 "Louisville" 5 "Nashville" 6 " " 7 "Wake 2015" 8 "Wake 2011",     ///
	angle(h) grid gstyle(dot)) xtit("estimate") ytit("")                ///
  tit("Latent Variances") saving(`g5')
  
graph combine "`g4'" "`g5'", rows(1) tit("Challenges of Reassignment") ///
  saving(`g6')
  
graph combine "`g3'" "`g6'", rows(2)
graph export ~/desktop/fig2.pdf, replace



tempfile g1 g2
graph twoway (rcap ubm lbm id if lv == "RU", hor)                          ///
  (scatter id m if lv == "RU", mc(black)), legend(off)                     ///
  xlab(-0.6(0.2)0.6, grid gstyle(dot)) ylab(1 "Wake" 2 "CMS" 3 "Rock Hill" ///
    4 "Louisville" 5 "Nashville" 6 " " 7 "Wake 2015" 8 "Wake 2011",        ///
	angle(h) grid gstyle(dot)) xtit("estimate") ytit("")                   ///
  tit("Latent Means") saving(`g1')
  
graph twoway (rcap ubv lbv id if lv == "RU", hor)                        ///
  (scatter id v if lv == "RU", mc(black)), legend(off)                   ///
  xlab(0(0.2)1.6, grid gstyle(dot)) ylab(1 "Wake" 2 "CMS" 3 "Rock Hill"  ///
    4 "Louisville" 5 "Nashville" 6 " " 7 "Wake 2015" 8 "Wake 2011",      ///
	angle(h) grid gstyle(dot)) xtit("estimate") ytit("")                 ///
  tit("Latent Variances") saving(`g2')
  
graph combine "`g1'" "`g2'", rows(1) tit("Reassignment Uncertainties")
graph export ~/desktop/fig3.pdf, replace
