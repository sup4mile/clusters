* REVISED version
* merge and construct 1992-2007 dataset 
** Dorn_IPW9207_new has fixed five countyids problems as listed in cty_clean_9216_new.do
use cty_clean_9216_final.dta, clear
merge 1:1 year fipstate fipscty countyid using Dorn_IPW9207_new.dta
tab countyid if _merge == 2
assert fipscty == 999 if _merge == 2
drop if _merge == 2
tab countyid if emp_mfg == .
tab countyid if wap == .  // 2201 2231 2232 2270 2280
gen mfg_sh_wap = emp_mfg / wap // have missing values due to wap == .

sort countyid year
* difference of mfg_sh_wap between 1992 and 2000
by countyid: gen d8_mfg_sh_wap = mfg_sh_wap[_n+8] - mfg_sh_wap[_n]
replace d8_mfg_sh_wap = d8_mfg_sh_wap * 10 / 8
* difference of mfg_sh_wap between 2000 and 2010
by countyid: gen d10_mfg_sh_wap = mfg_sh_wap[_n+10] - mfg_sh_wap[_n]
keep if year == 1992 | year == 2000
replace d10_mfg_sh_wap = d8_mfg_sh_wap if year == 1992
drop d8_mfg_sh_wap Lit
assert _merge == 3

sort countyid year 
order year countyid emp_i emp_mfg emp_sh_mfg wap mfg_sh_wap d10_mfg_sh_wap Dorn_DIPW Dorn_DIPW_o
save Dorn_9207.dta, replace

* regression 
* check whether each county has both 1992 and 2000 data
use Dorn_9207, clear
duplicates report countyid
gen yr1992 = 1 if year == 1992
replace yr1992 = 2 if year == 2000
by countyid: egen yr_sum = sum(yr1992)
tab countyid if yr_sum == 1  // 2231
tab countyid if yr_sum == 2  // 2332 2282
drop if countyid ==  2231 | countyid ==  2232 | countyid ==  2282
duplicates report countyid
drop yr1992 yr_sum

* change dipw into thousand dollars per worker unit
replace Dorn_DIPW = Dorn_DIPW / 1000
replace Dorn_DIPW_o = Dorn_DIPW_o / 1000
* percentage change of emp-wap ratio 
replace d10_mfg_sh_wap = 100 * d10_mfg_sh_wap

* county population weight 
by countyid: gen wt_emp_i = emp_i[1]
gen t2000 = (year == 2000)

cap log close
log using ivreg_table3_new, replace

* table 3 
ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) t2000, first cluster(fipstate)
ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) t2000 [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) emp_sh_mfg t2000, first cluster(fipstate)
ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) emp_sh_mfg t2000 [aw=wt_emp_i], first cluster(fipstate)
log close



/*
* ORIGINAL version ***** NOTICE Dorn_IPW9207 has changed. Original version please refers to zili/Dorn_IPW9207.dta

* Merge and construct 1992-2007 dataset 
use cty_clean_9216_final.dta, clear
merge 1:1 year fipstate fipscty countyid using Dorn_IPW9207.dta
// drop the using only part, most with countyid --999
drop if _merge==2
tab countyid if emp_mfg == .
tab countyid if wap == .  // 2201 2231 2232 2270 2280
gen mfg_sh_wap = emp_mfg/wap // have missing values due to wap == .
sort countyid year
by countyid: gen d10_mfg_sh_wap =  mfg_sh_wap[_n+10]-mfg_sh_wap[_n]
keep if year == 1992 | year == 2000
sort countyid year 
drop Lit
order year countyid emp_i emp_mfg emp_sh_mfg wap mfg_sh_wap d10_mfg_sh_wap Dorn_DIPW Dorn_DIPW_o
save Dorn_9207.dta, replace

* Regression analysis
* check whether each county has both 1992 and 2000 data
use Dorn_9207, clear
duplicates report countyid
gen yr1992 = 1 if year == 1992
replace yr1992 = 2 if year == 2000
by countyid: egen yr_sum = sum(yr1992)
tab countyid if yr_sum == 1
tab countyid if yr_sum == 2
drop if countyid ==  2231 | countyid ==  2232 | countyid ==  2282
duplicates report countyid
drop yr1992 yr_sum

* change dipw into thousand dollars per worker unit
replace Dorn_DIPW = Dorn_DIPW / 1000
replace Dorn_DIPW_o = Dorn_DIPW_o / 1000
* percentage change of emp-wap ratio 
replace d10_mfg_sh_wap = 100 * d10_mfg_sh_wap

* county population weight 
by countyid: gen wt_emp_i = emp_i[1]
gen t2000 = (year == 2000)

cap log close
log using ivreg_table3, replace

* table 3 
ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) t2000, first cluster(fipstate)
ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) t2000 [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) emp_sh_mfg t2000, first cluster(fipstate)
ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) emp_sh_mfg t2000 [aw=wt_emp_i], first cluster(fipstate)
log close


