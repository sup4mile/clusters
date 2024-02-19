use cty_clean_9216_new.dta, clear
count if countyid == 51515 | countyid == 51109 | countyid == 51560 | countyid == 51005 | countyid == 51780 | countyid == 51083
drop if countyid == 51515 | countyid == 51109 | countyid == 51560 | countyid == 51005 | countyid == 51780 | countyid == 51083
append using va_cty_clean_9216_new.dta
sort countyid year

save cty_clean_9216_final.dta, replace

* re-check unmatched wap left
count if _merge_wap == 1  // 47 observations
tab countyid if _merge_wap == 1  // 2201 2231 2232 2270 2280
count if wap < emp_i
tab countyid if wap < emp_i  // 785 observations

* gaps in years for some countyid embedded in CBP data
xtset countyid year  // with gaps
egen max_gap = max(year-year[_n-1]), by(countyid)
tab countyid if max_gap > 1  // 48269 48301
tab year if countyid == 48269  // no year 2001 2002 2005~2015
tab year if countyid == 48301  // no year 2005 2006 2011
** PENDING: drop if countyid == 48269 | countyid == 48301
** assert max_gap == 1
drop max_gap

use cty_clean_9216_final, clear
count if countyid == 12086  // 25
count if countyid == 46102  // 25
replace fipscty = 86 if fipstate == 12 & fipscty == 25
replace fipscty = 102 if fipstate == 46 & fipscty == 113
assert countyid == 1000 * fipstate + fipscty
save cty_clean_9216_final, replace
