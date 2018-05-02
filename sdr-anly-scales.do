*** Purpose: conduct multiple group analysis using scales
*** Author: S Bauldry
*** Date: May 2, 2018

*** Set higher matrix size 
set matsize 10000

*** Analysis over time
use sdr-data-time, replace
svyset [pw = wt]

* difference in reliabilities
bysort time: alpha ds1-ds4
bysort time: alpha ns1-ns4

* difference in means
svy: mean dsp nss, over(time)
test [dsp]2011 = [dsp]2015
test [nss]2011 = [nss]2015

* difference in variances (Stas)
gen dsp2 = dsp^2
svy: mean dsp dsp2, over(time)
nlcom  ( _b[dsp2:2011] - _b[dsp:2011]*_b[dsp:2011] ) 
nlcom  ( _b[dsp2:2015] - _b[dsp:2015]*_b[dsp:2015] ) 
testnl ( _b[dsp2:2011] - _b[dsp:2011]*_b[dsp:2011] ) ///
     = ( _b[dsp2:2015] - _b[dsp:2015]*_b[dsp:2015] )

gen nss2 = nss^2
svy: mean nss nss2, over(time)
nlcom  ( _b[nss2:2011] - _b[nss:2011]*_b[nss:2011] ) 
nlcom  ( _b[nss2:2015] - _b[nss:2015]*_b[nss:2015] ) 
testnl ( _b[nss2:2011] - _b[nss:2011]*_b[nss:2011] ) ///
     = ( _b[nss2:2015] - _b[nss:2015]*_b[nss:2015] )

* difference in predictors
qui tab act, gen(a)
qui tab ict, gen(i)
qui tab pol, gen(p) 

sem (dsp <- a2 a3 fem wht mar ach edu i2 i3 liv p2 p3 mlk gov) [pw = wt], ///
  method(mlmv) group(time)
estat ginvariant

sem (nss <- a2 a3 fem wht mar ach edu i2 i3 liv p2 p3 mlk gov) [pw = wt], ///
  method(mlmv) group(time)
estat ginvariant



*** Analysis across sites
use sdr-data-site, replace
svyset [pw = wt]

* difference in reliabilities
bysort site: alpha ds1-ds4
bysort site: alpha ns1-ns4

* difference in means
svy: mean dsp nss, over(site)
test [dsp]Wake = [dsp]CMS = [dsp]_subpop_3 = [dsp]Louisville = [dsp]Nashville
test [nss]Wake = [nss]CMS = [nss]_subpop_3 = [nss]Louisville = [nss]Nashville

* difference in variances
gen dsp2 = dsp^2
svy: mean dsp dsp2, over(site)
nlcom  ( _b[dsp2:Wake] - _b[dsp:Wake]*_b[dsp:Wake] ) 
nlcom  ( _b[dsp2:CMS] - _b[dsp:CMS]*_b[dsp:CMS] ) 
nlcom  ( _b[dsp2:_subpop_3] - _b[dsp:_subpop_3]*_b[dsp:_subpop_3] ) 
nlcom  ( _b[dsp2:Louisville] - _b[dsp:Louisville]*_b[dsp:Louisville] ) 
nlcom  ( _b[dsp2:Nashville] - _b[dsp:Nashville]*_b[dsp:Nashville] ) 

testnl ( _b[dsp2:Wake] - _b[dsp:Wake]*_b[dsp:Wake] )                   ///
     = ( _b[dsp2:CMS] - _b[dsp:CMS]*_b[dsp:CMS] )                      ///
     = ( _b[dsp2:_subpop_3] - _b[dsp:_subpop_3]*_b[dsp:_subpop_3] )    ///
     = ( _b[dsp2:Louisville] - _b[dsp:Louisville]*_b[dsp:Louisville] ) ///
     = ( _b[dsp2:Nashville] - _b[dsp:Nashville]*_b[dsp:Nashville] ) 
	 
gen nss2 = nss^2
svy: mean nss nss2, over(site)
nlcom  ( _b[nss2:Wake] - _b[nss:Wake]*_b[nss:Wake] ) 
nlcom  ( _b[nss2:CMS] - _b[nss:CMS]*_b[nss:CMS] ) 
nlcom  ( _b[nss2:_subpop_3] - _b[nss:_subpop_3]*_b[nss:_subpop_3] ) 
nlcom  ( _b[nss2:Louisville] - _b[nss:Louisville]*_b[nss:Louisville] ) 
nlcom  ( _b[nss2:Nashville] - _b[nss:Nashville]*_b[nss:Nashville] ) 

testnl ( _b[nss2:Wake] - _b[nss:Wake]*_b[nss:Wake] )                   ///
     = ( _b[nss2:CMS] - _b[nss:CMS]*_b[nss:CMS] )                      ///
     = ( _b[nss2:_subpop_3] - _b[nss:_subpop_3]*_b[nss:_subpop_3] )    ///
     = ( _b[nss2:Louisville] - _b[nss:Louisville]*_b[nss:Louisville] ) ///
     = ( _b[nss2:Nashville] - _b[nss:Nashville]*_b[nss:Nashville] ) 

* difference in predictors
qui tab act, gen(a)
qui tab ict, gen(i)
qui tab pol, gen(p)

sem (dsp <- a2 a3 fem wht mar ach edu i2 i3 liv p2 p3 mlk gov spp) [pw = wt], ///
  method(mlmv) group(site)
estat ginvariant

sem (nss <- a2 a3 fem wht mar ach edu i2 i3 liv p2 p3 mlk gov spp) [pw = wt], ///
  method(mlmv) group(site)
estat ginvariant
