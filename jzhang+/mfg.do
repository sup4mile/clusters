/*
County manufacturing employment: level, 1, 3, 5, and 10-year changes
Variable names: emp_mfg, d1_emp_mfg, d3_emp_mfg, d5_emp_mfg, d10_emp_mfg

County manufacturing employment share: level
Variable name: emp_sh_mfg
*/

use DDIPW_complete4.dta, clear

* check obs with only instruments data
tab naics4 if _merge == 2
tab fipstate if _merge == 2, missing
drop if _merge == 2 
gen countyid = fipstate * 1000 + fipscty
count if fipstate == .
drop if countyid == .
keep year fipstate fipscty countyid naics4 emp Lit
order year fipstate fipscty countyid naics4 emp Lit
tab year  // not all counties have data for each year from 1992 to 2016

* find counties without mfg naics code
bysort year countyid: gen is_mfg = (naics4 >= 3100 & naics4 <= 3399)
* if a county does not have mfg code, all is_mfg is 0
by year countyid: egen has_mfg = max(is_mfg)
tab countyid if has_mfg == 0  // 210 counties without naics4 some year
tab has_mfg
tab countyid if emp == 0  // at year county industry level

* Version 2: think of counties with no mfg naics code as 0 emp_mfg some year
bysort year countyid: egen emp_mfg = sum(emp * is_mfg)
assert emp_mfg == 0 if has_mfg == 0
assert has_mfg == 0 if emp_mfg == 0
assert emp_mfg < .
duplicates drop year countyid emp_mfg, force
sort countyid year 

xtset countyid year  // with gaps

/*
by countyid: egen max_gap = max(year-year[_n-1])
tab countyid if max_gap > 1
drop if countyid == 9999 | countyid == 10999 | countyid == 15999 | countyid == 23999 | countyid == 33999 | countyid == 44999 | countyid == 48269 | countyid == 48301 | countyid == 50999
assert max_gap == 1

xtset countyid year  // no gap, but exist counties having less than 25 observations
*/

gen f1_emp_mfg = F.emp_mfg
gen f3_emp_mfg = F3.emp_mfg
gen f5_emp_mfg = F5.emp_mfg
gen f10_emp_mfg = F10.emp_mfg

gen d1_emp_mfg = f1_emp_mfg - emp_mfg
gen d3_emp_mfg = f3_emp_mfg - emp_mfg
gen d5_emp_mfg = f5_emp_mfg - emp_mfg
gen d10_emp_mfg = f10_emp_mfg - emp_mfg

gen emp_sh_mfg = emp_mfg / Lit

drop is_mfg has_mfg f*_emp_mfg naics4 emp Lit
order year fipstate fipscty countyid emp_mfg emp_sh_mfg

save mfg_v2_gap.dta, replace


/*
* Version 1: drop all time-series observations of counties that do not have mfg, and for the rest of counties with mfg, compute level and change data
bysort countyid: egen omit = min(has_mfg) 
tab countyid if omit == 0  // same 210 counties as has_mfg == 0 case
drop if omit == 0
assert has_mfg == 1

* all counties left in dataset have some manufacture code for all years
bysort year countyid: egen emp_mfg = sum(emp * is_mfg)
assert emp_mfg < .
assert emp_mfg > 0
duplicates drop year countyid emp_mfg, force
sort countyid year 

xtset countyid year  // no gap but exist counties having less than 25 observations

gen f1_emp_mfg = F.emp_mfg
gen f3_emp_mfg = F3.emp_mfg
gen f5_emp_mfg = F5.emp_mfg
gen f10_emp_mfg = F10.emp_mfg

gen d1_emp_mfg = f1_emp_mfg - emp_mfg
gen d3_emp_mfg = f3_emp_mfg - emp_mfg
gen d5_emp_mfg = f5_emp_mfg - emp_mfg
gen d10_emp_mfg = f10_emp_mfg - emp_mfg

gen emp_sh_mfg = emp_mfg / Lit

drop is_mfg has_mfg omit f*_emp_mfg naics4 emp Lit
order year fipstate fipscty countyid emp_mfg emp_sh_mfg

save mfg_v1.dta, replace
*/