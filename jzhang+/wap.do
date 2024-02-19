/* create 1,3,5,10 difference for wap
use working_age_pop.dta, clear
tab year
drop if year < 1992

xtset countyid year

gen f1_wap = F.wap
gen f3_wap = F3.wap
gen f5_wap = F5.wap
gen f10_wap = F10.wap

gen d1_wap = f1_wap - wap
gen d3_wap = f3_wap - wap
gen d5_wap = f5_wap - wap
gen d10_wap = f10_wap - wap

drop f*_wap
save wap.dta, replace
*/

* special case checks
use wap.dta, clear
// 12025 Dade County was renamed Miami-Dade County with a new FIPS code 12086 on July 22, 1997
tab year if countyid == 12025 // no observation
tab year if countyid == 12086 // 25 years

// 46113 Shannon County was renamed Oglala Lakota County with a new FIPS code 46102 on May 1, 2015
tab year if countyid == 46113 // up to 2009
tab year if countyid == 46102 // since 2010
** fix by replacing old code with new code
count if countyid == 46113  // 18
count if countyid == 46102  // 7
replace countyid = 46102 if countyid == 46113
count if countyid == 46102  // 25

// 51515 City of Bedford was merged with Bedford County 51109 on July 1, 2013.
tab year if countyid == 51515 // up to 2009
tab year if countyid == 51109 // 25 years
** PENDING: hard to fix due to other data in the row

// 51560 was added to 51005 on July 1, 2001.
tab year if countyid == 51560 // up to 1999
tab year if countyid == 51005 // 25 years
** PENDING: hard to fix due to other data in the row

// 51780 was added to 51083 on June 30, 1995.
tab year if countyid == 51780 // no observation
tab year if countyid == 51083 // 25 years
** PENDING: hard to fix due to other data in the row

* re-sort
sort countyid year

save wap_new.dta, replace

