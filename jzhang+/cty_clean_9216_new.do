* Clean from DDIPW_complete4.dta
use DDIPW_complete4, clear

drop n1_4 - diff1 DI_ijt10 - I_ijt emp_in_cty eic2 qp1 - diff_o DI_ijt10_o - I_ijt_o
rename naics naics_6
rename naics4 naics_4
rename hhit hhi_4
rename D*_IPW_o d*_ipw_o
rename D*_IPW d*_ipw
rename us_merge _merge_us
rename _merge _merge_o
rename IPW ipw 
rename IPW_o ipw_o
rename DI_it*_o d*_imp_i_o
rename DI_it* d*_imp_i
rename d1_imp_i d_imp_i
rename I_it imp_i
rename I_it_o imp_i_o
rename Lit emp_i
rename Ljt emp_j
label var naics_4 "first 4 digits of NAICS"
label var naics_6 "6 digits of NAICS"
label var hhi_4 "HHI @ 4-digit NAICS"
label var emp "county-industry employment @ 4-digit NAICS" 
label var est "county-industry establishment @ 4-digit NAICS"
label var est_or "alternative county-industry establishment @ 4-digit NAICS"
label var emp_i "county employment @ 4-digit NAICS"
label var emp_j "nationwide industry employment @ 4-digit NAICS"
label var imp_i "level of US imports in county i"
label var d_imp_i "1-year change of US imports in county i"
label var d3_imp_i "3-year change of US imports in county i"
label var d5_imp_i "5-year change of US imports in county i"
label var d10_imp_i "10-year change of US imports in county i"
label var ipw "county-level US imports per worker"
label var d_ipw "1-year change of US imports per worker in county"
label var d3_ipw "3-year change of US imports per worker in county"
label var d5_ipw "5-year change of US imports per worker in county"
label var d10_ipw "10-year change of US imports per worker in county"
label var imp_i_o "other countries imports from China averaged to US county i"
label var d_imp_i_o "1-year change of other countries imports averaged to US county i"
label var d3_imp_i_o "3-year change of other countries imports averaged to US county i"
label var d5_imp_i_o "5-year change of other countries imports averaged to US county i"
label var d10_imp_i_o "10-year change of other countries imports averaged to US county i"
label var ipw_o "other countries imports from China per US worker"
label var d_ipw_o "1-year change of other countries imports per US worker in county"
label var d3_ipw_o "3-year change of other countries imports per US worker in county"
label var d5_ipw_o "5-year change of other countries imports per US worker in county"
label var d10_ipw_o "10-year change of other countries imports per US worker in county"

gen countyid = fipstate * 1000 + fipscty
count if fipstate == .
count if countyid == . 
drop if fipstate == .

gen naics_2 = int(naics_4 / 100)
assert naics_2 != . 
assert naics_2 > 0
label var naics_2 "first 2 digits of NAICS"

* calculate county-level establishment
bysort year countyid: egen est_i = sum(est) 
bysort year countyid: egen est_or_i = sum(est_or)  // dubious
label var est_i "county establishment @ 4-digit NAICS"
label var est_or_i "alternative county establishment @ 4-digit NAICS"

order year fipstate fipscty countyid naics_2 naics_4 naics_6

* change data with each county as the basic unit
duplicates drop year countyid emp_i ipw ipw_o, force
duplicates report year fipstate fipscty

* drop variables that are unnecessary or at county-industry level
drop emp est est_or emp_j naics_2 naics_4 naics_6 

* add HHI in 2-digit NAICS level
merge 1:1 year fipstate fipscty using hhit2.dta 
assert _merge == 3
drop _merge
rename hhit2 hhi_2
label var hhi_2 "HHI @ 2-digit NAICS"

* add manufacture data using mfg_v2
merge 1:1 year fipstate fipscty countyid using mfg_v2_gap.dta
assert _merge == 3
drop _merge
label var emp_mfg "county manufacturing employment"
label var emp_sh_mfg "county manufacturing employment share"
rename d1_emp_mfg d_emp_mfg
label var d_emp_mfg "1-year change of county manufacturing employment"
label var d3_emp_mfg "3-year change of county manufacturing employment"
label var d5_emp_mfg "5-year change of county manufacturing employment"
label var d10_emp_mfg "10-year change of county manufacturing employment"

* special case check re countyid
// ignore 2201, 2231, 2232, 2270, and 2280

// 12025 Dade County was renamed Miami-Dade County with a new code 12086 on July 22, 1997
tab year if countyid == 12025  // up to 2001
tab year if countyid == 12086  // since 2002
** fix by replacing old code with new code
count if countyid == 12025  // 10
count if countyid == 12086  // 15
replace countyid = 12086 if countyid == 12025
replace fipscty = 86 if fipstate == 12 & fipscty == 25
count if countyid == 12086  // 25

// 46113 Shannon County was renamed Oglala Lakota County with a new code 46102 on May 1, 2015
tab year if countyid == 46113 // 25 years
tab year if countyid == 46102 // no observation
** fix by replacing old code with new code
count if countyid == 46113  // 25
count if countyid == 46102  // 0
replace countyid = 46102 if countyid == 46113
replace fipscty = 102 if fipstate == 46 & fipscty == 113
count if countyid == 46102  // 25

// 51515 City of Bedford was merged with Bedford County 51109 on July 1, 2013.
tab year if countyid == 51515 // 25 years
tab year if countyid == 51109 // 25 years
** PENDING: hard to fix due to other data in the row

// 51560 was added to 51005 on July 1, 2001.
tab year if countyid == 51560 // up to 2001
tab year if countyid == 51005 // 25 years
** PENDING: hard to fix due to other data in the row

// 51780 was added to 51083 on June 30, 1995.
tab year if countyid == 51780 // up to 1995
tab year if countyid == 51083 // 25 years
** PENDING: hard to fix due to other data in the row

* add working age population 
merge 1:1 year countyid using wap_new.dta
tab countyid if _merge == 1  // 1277 observations, most fipscty 999
tab countyid if _merge == 2  // 126 observations
drop if _merge == 2
rename _merge _merge_wap
assert _merge_wap == 1 | _merge_wap == 3
label var wap "county working age population"
rename d1_wap d_wap
label var d_wap "1-year change of county working age population"
label var d3_wap "3-year change of county working age population"
label var d5_wap "5-year change of county working age population"
label var d10_wap "10-year change of county working age population"

* drop state level data (fipscty 999)
count if fipscty == 999  // 1217 observations
drop if fipscty == 999

* re-check unmatched wap left
count if _merge_wap == 1  // 60 observations
tab countyid if _merge_wap == 1  // 2201 2231 2232 2270 2280 51515 51560 51780
count if wap < emp_i
tab countyid if wap < emp_i  // 803 observations

* gaps in years for some countyid embedded in CBP data
xtset countyid year  // with gaps
egen max_gap = max(year-year[_n-1]), by(countyid)
tab countyid if max_gap > 1  // 48269 48301
tab year if countyid == 48269  // no year 2001 2002 2005~2015
tab year if countyid == 48301  // no year 2005 2006 2011
** PENDING: drop if countyid == 48269 | countyid == 48301
** assert max_gap == 1
drop max_gap

order year fipstate fipscty countyid emp_i est_i est_or_i hhi_2 hhi_4 _merge_us imp_i d_imp_i d3_imp_i d5_imp_i d10_imp_i ipw d_ipw d3_ipw d5_ipw d10_ipw _merge_o imp_i_o d_imp_i_o d3_imp_i_o d5_imp_i_o d10_imp_i_o ipw_o d_ipw_o d3_ipw_o d5_ipw_o d10_ipw_o emp_mfg emp_sh_mfg d_emp_mfg d3_emp_mfg d5_emp_mfg d10_emp_mfg _merge_wap wap d_wap d3_wap d5_wap d10_wap

save cty_clean_9216_new.dta, replace