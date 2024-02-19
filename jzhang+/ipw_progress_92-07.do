//92-07 (changes imports from China to US)/worker constructing 
//cd V:\ic\zili

use "append_97naics4.dta", clear
* fix issues with countyid
gen countyid = fipstate * 1000 + fipscty
count if countyid == 12025
count if countyid == 12086
count if countyid == 12025 & year > 2001
count if countyid == 12086 & year < 2002
replace countyid = 12086 if countyid == 12025
replace fipscty = 86 if fipstate == 12 & fipscty == 25

count if countyid == 46113
count if countyid == 46102
replace countyid = 46102 if countyid == 46113
replace fipscty = 102 if fipstate == 46 & fipscty == 113
drop countyid

sort year fipstate fipscty naics

merge m:1 year naics4 using hs_cn_9207.dta

bysort year fipstate fipscty: egen Lit = sum(emp)
bysort year naics4: egen Ljt = sum(emp)

gen DI_ijt8 = emp/Ljt*d_impgrow
bysort year fipstate fipscty: egen DI_it8 = total(DI_ijt8)
gen Dorn_DIPW = DI_it8/Lit

sort year fipstate fipscty naics4
keep if year == 2000
drop if _merge==2

save Dorn_IPW00, replace

//---------------

use "sic_naics4", clear
* fix issues with countyid
gen countyid = fipstate * 1000 + fipscty
count if countyid == 12025
count if countyid == 12086
replace countyid = 12086 if countyid == 12025
replace fipscty = 86 if fipstate == 12 & fipscty == 25

count if countyid == 46113
count if countyid == 46102
replace countyid = 46102 if countyid == 46113
replace fipscty = 102 if fipstate == 46 & fipscty == 113
drop countyid

sort year fipstate fipscty naics

merge m:1 year naics4 using hs_cn_9207.dta

bysort year fipstate fipscty: egen Lit = sum(emp)
bysort year naics4: egen Ljt = sum(emp)

gen DI_ijt7 = emp/Ljt*d_impgrow
bysort year fipstate fipscty: egen DI_it7 = total(DI_ijt7)
gen Dorn_DIPW = DI_it7/Lit

sort year fipstate fipscty naics4
keep if year == 1992
drop if _merge==2
save Dorn_IPW92, replace

append using Dorn_IPW00
keep year fipstate fipscty naics naics4 emp Dorn_DIPW d_impgrow _merge Lit Ljt 
save Dorn_IPW, replace

//92-07 (changes imports from China to other countries)/worker constructing 
use Dorn_IPW.dta, clear
rename _merge us_merge
merge m:1 year naics4 using other_naics4_agg_9207.dta

gen DI_ijt_o = emp/Ljt*d_impgrow_o
bysort year fipstate fipscty: egen DI_it_o = total(DI_ijt_o)
gen Dorn_DIPW_o = DI_it_o/Lit

sort year fipstate fipscty naics4
drop if _merge==2
save Dorn_IPWC, replace

//construct county-level DIPW9207
duplicates drop year fipstate fipscty Lit Dorn_DIPW Dorn_DIPW_o, force
gen countyid = fipstate * 1000 + fipscty
keep year fipstate fipscty countyid Lit Dorn_DIPW Dorn_DIPW_o
sort countyid year
save Dorn_IPW9207, replace

********************************************************************************

* do the same version for va three counties 
use va_append_97naics4, clear
merge m:1 year naics4 using hs_cn_9207.dta

bysort year fipstate fipscty: egen Lit = sum(emp)
bysort year naics4: egen Ljt = sum(emp)

gen DI_ijt8 = emp/Ljt*d_impgrow
bysort year fipstate fipscty: egen DI_it8 = total(DI_ijt8)
gen Dorn_DIPW = DI_it8/Lit

sort year fipstate fipscty naics4
keep if year == 2000
drop if _merge==2

save Dorn_IPW00_va, replace

//---------------

use va_sic_naics4, clear
merge m:1 year naics4 using hs_cn_9207.dta

bysort year fipstate fipscty: egen Lit = sum(emp)
bysort year naics4: egen Ljt = sum(emp)

gen DI_ijt7 = emp/Ljt*d_impgrow
bysort year fipstate fipscty: egen DI_it7 = total(DI_ijt7)
gen Dorn_DIPW = DI_it7/Lit

sort year fipstate fipscty naics4
keep if year == 1992
drop if _merge==2
save Dorn_IPW92_va, replace

append using Dorn_IPW00_va
keep year fipstate fipscty naics naics4 emp Dorn_DIPW d_impgrow _merge Lit Ljt 
save Dorn_IPW_va, replace

//92-07 (changes imports from China to other countries)/worker constructing 
use Dorn_IPW_va.dta, clear
rename _merge us_merge
merge m:1 year naics4 using other_naics4_agg_9207.dta

gen DI_ijt_o = emp/Ljt*d_impgrow_o
bysort year fipstate fipscty: egen DI_it_o = total(DI_ijt_o)
gen Dorn_DIPW_o = DI_it_o/Lit

sort year fipstate fipscty naics4
drop if _merge==2
save Dorn_IPWC_va, replace

//construct county-level DIPW9207
duplicates drop year fipstate fipscty Lit Dorn_DIPW Dorn_DIPW_o, force
gen countyid = fipstate * 1000 + fipscty
keep year fipstate fipscty countyid Lit Dorn_DIPW Dorn_DIPW_o
sort countyid year
save Dorn_IPW9207_va, replace

********************************************************************************

* revise Dorn_IPW9207 with the three va_counties
use Dorn_IPW9207, clear
count if countyid == 12025 | countyid == 46113
count if countyid == 51515 | countyid == 51109 | countyid == 51560 | countyid == 51005 | countyid == 51780 | countyid == 51083

count if countyid == 51515 // 2
count if countyid == 51109 // 2
count if countyid == 51560 // 2
count if countyid == 51005 // 2
count if countyid == 51780 // 1, because it goes up to 1995, no emp in 2000
count if countyid == 51083 // 2

drop if countyid == 51515 | countyid == 51109 | countyid == 51560 | countyid == 51005 | countyid == 51780 | countyid == 51083

append using Dorn_IPW9207_va
sort countyid year

save Dorn_IPW9207_new, replace