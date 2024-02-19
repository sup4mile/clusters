cap log close
log using no_mfg.log, replace

use DDIPW_complete4, clear
* output year lists for each county that does not have manufacturing employment at that year

gen countyid = fipstate * 1000 + fipscty
count if fipstate == .
drop if countyid == .
keep year - n1000_4 Lit countyid
order year fipstate fipscty countyid
bysort year fipstate fipscty: egen emp_man = sum(emp) if naics4 >= 3100 & naics4 <= 3399

count if emp_man == 0 // 0
replace emp_man = 0 if emp_man == .
by year fipstate fipscty: egen actual_mfg = max(emp_man)
duplicates drop year fipstate fipscty actual_mfg, force
duplicates report year countyid // 1
tab countyid if actual_mfg == 0

sort countyid year
list countyid year if actual_mfg == 0

order countyid year emp actual_mfg
by countyid: egen i = min(actual_mfg)
assert i >= 0
by countyid: gen no_mfg = (i == 0)
keep if no_mfg == 1
list countyid year actual_mfg

log close