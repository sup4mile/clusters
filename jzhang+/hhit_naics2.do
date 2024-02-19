* hhi in naics2 level for each county
use DDIPW_complete3.dta, clear

gen naics2 = int(naics4/100)
keep year fipstate fipscty naics4 naics2 emp 
sort year fipstate fipscty naics2
order year fipstate fipscty naics2
collapse (sum) emp, by (year fipstate fipscty naics2)
rename emp emp2

bysort year fipstate fipscty: egen Lit2 = sum(emp2)
count if Lit2 == 0 // 193
gen emp_in_cty = emp2/Lit2  // 193 missing values
gen eic2 = emp_in_cty^2     // 193 missing values
bysort year fipstate fipscty: egen hhit2 = sum(eic2)
count if hhit2 == 0 // 193

keep year fipstate fipscty hhit2
duplicates drop 

tab year
drop if year < 1992 | year > 2016

count if fipstate == . | fipscty == . // 25
count if fipstate == . & fipscty == . // 25
tab year if fipstate == . | fipscty == . // one in each year
drop if fipstate == . | fipscty == .

save hhit2.dta, replace