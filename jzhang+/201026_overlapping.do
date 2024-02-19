*overlapping 10-year difference
//redo "imports growth in 1992-2007.do"
use hs_cn_new.dta, clear
gen d_impgrow = sum_dollar[_n+10] - sum_dollar[_n] 
drop if d_impgrow ==.
keep year naics4 sum_dollar d_impgrow
save hs_cn_10yr.dta, replace

*other countries- China imports growth
use other_naics4_agg.dta, clear 
gen d_impgrow_o = dollar_o[_n+10] - dollar_o[_n] 
drop if d_impgrow_o ==.
keep year naics4 d_impgrow_o
save other_naics4_agg_10yr.dta, replace

/*--------------------------------------------------------------------*/
//redo "ipw_progress_92-07.do"
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

merge m:1 year naics4 using hs_cn_10yr.dta

bysort year fipstate fipscty: egen Lit = sum(emp)
bysort year naics4: egen Ljt = sum(emp)

gen DI_ijt9 = emp/Ljt*d_impgrow
bysort year fipstate fipscty: egen DI_it9 = total(DI_ijt9)
gen Dorn_DIPW = DI_it9/Lit

sort year fipstate fipscty naics4
drop if _merge==2
keep year fipstate fipscty naics naics4 emp Dorn_DIPW d_impgrow _merge Lit Ljt 
save Dorn_IPW10yr, replace

*92-07 (changes imports from China to other countries)/worker constructing 
use Dorn_IPW10yr.dta, clear
rename _merge us_merge
merge m:1 year naics4 using other_naics4_agg_10yr.dta

gen DI_ijt_o = emp/Ljt*d_impgrow_o
bysort year fipstate fipscty: egen DI_it_o = total(DI_ijt_o)
gen Dorn_DIPW_o = DI_it_o/Lit

sort year fipstate fipscty naics4
drop if _merge==2
save Dorn_IPWC10yr, replace

//construct county-level DIPW9207
duplicates drop year fipstate fipscty Lit Dorn_DIPW Dorn_DIPW_o, force
gen countyid = fipstate * 1000 + fipscty
keep year fipstate fipscty countyid Lit Dorn_DIPW Dorn_DIPW_o
sort countyid year
save Dorn_IPW10yr, replace

* do the same version for va three counties 
use va_ctyid_new/va_append_97naics4, clear
merge m:1 year naics4 using hs_cn_10yr.dta

bysort year fipstate fipscty: egen Lit = sum(emp)
bysort year naics4: egen Ljt = sum(emp)

gen DI_ijt9 = emp/Ljt*d_impgrow
bysort year fipstate fipscty: egen DI_it9 = total(DI_ijt9)
gen Dorn_DIPW = DI_it9/Lit

sort year fipstate fipscty naics4
drop if _merge==2
keep year fipstate fipscty naics naics4 emp Dorn_DIPW d_impgrow _merge Lit Ljt 
save Dorn_IPWyr_va, replace

//92-16 (changes imports from China to other countries)/worker constructing 
use Dorn_IPWyr_va.dta, clear
rename _merge us_merge
merge m:1 year naics4 using other_naics4_agg_10yr.dta

gen DI_ijt_o = emp/Ljt*d_impgrow_o
bysort year fipstate fipscty: egen DI_it_o = total(DI_ijt_o)
gen Dorn_DIPW_o = DI_it_o/Lit

sort year fipstate fipscty naics4
drop if _merge==2
save Dorn_IPWC10yr_va, replace

//construct county-level DIPW9207
duplicates drop year fipstate fipscty Lit Dorn_DIPW Dorn_DIPW_o, force
gen countyid = fipstate * 1000 + fipscty
keep year fipstate fipscty countyid Lit Dorn_DIPW Dorn_DIPW_o
sort countyid year
save Dorn_IPW10yr_va, replace


* revise Dorn_IPW9207 with the three va_counties
use Dorn_IPW10yr, clear
count if countyid == 12025 | countyid == 46113
count if countyid == 51515 | countyid == 51109 | countyid == 51560 | countyid == 51005 | countyid == 51780 | countyid == 51083

count if countyid == 51515 // 2
count if countyid == 51109 // 2
count if countyid == 51560 // 2
count if countyid == 51005 // 2
count if countyid == 51780 // 1, because it goes up to 1995, no emp in 2000
count if countyid == 51083 // 2

drop if countyid == 51515 | countyid == 51109 | countyid == 51560 | countyid == 51005 | countyid == 51780 | countyid == 51083

append using Dorn_IPW10yr_va
sort countyid year

save Dorn_IPW10yr_new, replace


/*---------------------------------------------------------------------------------*/
//redo "Dorn_9207.do"
* REVISED version
* merge and construct 1992-2007 dataset 
** Dorn_IPW9207_new has fixed five countyids problems as listed in cty_clean_9216_new.do
use va_ctyid_new/cty_clean_9216_f1.dta, clear
*merge 1:1 year fipstate fipscty countyid using Dorn_IPW10yr_new.dta
*tab countyid if _merge == 2
*assert fipscty == 999 if _merge == 2
*drop if _merge == 2
*tab countyid if emp_mfg == .
*tab countyid if wap == .  // 2201 2231 2232 2270 2280
gen mfg_sh_wap = emp_mfg / wap // have missing values due to wap == .
gen emp_i_sh_wap = emp_i / wap // have missing values due to wap == .

sort countyid year
by countyid: gen d10_mfg_sh_wap = mfg_sh_wap[_n+10] - mfg_sh_wap[_n]
by countyid: gen d10_emp_i_sh_wap = emp_i_sh_wap[_n+10] - emp_i_sh_wap[_n]
*drop Lit
by countyid: gen d5_mfg_sh_wap = mfg_sh_wap[_n+5] - mfg_sh_wap[_n]
by countyid: gen d5_emp_i_sh_wap = emp_i_sh_wap[_n+5] - emp_i_sh_wap[_n]



*assert _merge == 3

sort countyid year 
order year countyid emp_i emp_mfg mfg_sh_emp wap mfg_sh_wap d10_mfg_sh_wap emp_i_sh_wap d10_emp_i_sh_wap 
save Dorn_10yr.dta, replace