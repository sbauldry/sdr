*** Purpose: conduct initial sdr mgCFA analysis
*** Author: S Bauldry
*** Date: January 25, 2018

*** Note: this is an update of a prior mgCFA analysis that did not use weights


*** program for illustrating distributions
capture program drop DistFig
program DistFig
  args v ub
	
  tempvar pr
  gen `pr' = .
  forval i = 1/5 {
    qui sum `v' if site == `i'
	qui replace `pr' = 1/r(N) if site == `i'
  }
  graph bar (sum) `pr', over(`v', rel(1 "SD" 2 "D" 3 "N" 4 "A" 5 "SA")) ///
    by(site) scheme(s1mono) ytit("pr R") ylab(0(0.1)`ub', angle(h))
end


sem (DoR -> dr1 dr2 dr3 dr4), method(mlmv)
estat gof, stats(all)

sem (DoR -> dr1 dr2 dr3 dr4) [pw = wt], method(mlmv)
estat gof, stats(all)


*** loading data
cd "~/dropbox/research/hlthineq/sdr/sdr-work"
use sdr-data, replace


