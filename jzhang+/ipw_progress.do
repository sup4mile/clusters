use "append_97naics4.dta", clear

*merge m:1 year naics4 using hs_cn10.dta
merge m:1 year naics4 using hs_cn_new.dta

bysort year fipstate fipscty: egen Lit = sum(emp) // total employment at county-level
bysort year naics4: egen Ljt = sum(emp) // total employment at industry-level

gen DI_ijt10 = emp/Ljt*diff10  // diff10_i_t: change in import in industry 
gen DI_ijt5 = emp/Ljt*diff5
gen DI_ijt3 = emp/Ljt*diff3
gen DI_ijt1 = emp/Ljt*diff1
gen I_ijt = emp/Ljt*sum_dollar

bysort year fipstate fipscty: egen DI_it10 = total(DI_ijt10) // dollar change in import at county level
bysort year fipstate fipscty: egen DI_it5 = total(DI_ijt5)
bysort year fipstate fipscty: egen DI_it3 = total(DI_ijt3)
bysort year fipstate fipscty: egen DI_it1 = total(DI_ijt1)
bysort year fipstate fipscty: egen I_it = total(I_ijt)

gen D10_IPW = DI_it10/Lit 
gen D5_IPW = DI_it5/Lit
gen D3_IPW = DI_it3/Lit
gen D_IPW = DI_it1/Lit
gen IPW = I_it/Lit

sort year fipstate fipscty naics4

* HHI calculation
gen emp_in_cty = emp/Lit
gen eic2 = emp_in_cty^2
bysort year fipstate fipscty: egen hhit = total(eic2)

label variable diff10 "decadal changes in imports value per industry"
label variable diff5 "five-year changes in imports value per industry"
label variable Lit "employment in county i at time t"
label variable Ljt "employment in industry j at time t"
label variable DI_ijt10 "employment/Ljt*diff10"
label variable DI_ijt5 "employment/Ljt*diff5"
label variable DI_it10 "add up all DI_ijt across industry j in decadal change"
label variable DI_it5 "add up all DI_ijt across industry j in five-year change"
label variable D10_IPW "Decadal Difference in IPW in county i at time t"
label variable D5_IPW "Five-year Difference in IPW in county i at time t"
label variable IPW "Imports per worker in county i at time t"
label variable hhit "HHI index at time t"
save DDIPW98_new, replace

/////////////////////////////////////////////////////////////////////////////////////////

use "sic_naics4", clear

*merge m:1 year naics4 using hs_cn10.dta
merge m:1 year naics4 using hs_cn_new.dta

bysort year fipstate fipscty: egen Lit = sum(emp)
bysort year naics4: egen Ljt = sum(emp)

gen DI_ijt10 = emp/Ljt*diff10
gen DI_ijt5 = emp/Ljt*diff5
gen DI_ijt3 = emp/Ljt*diff3
gen DI_ijt1 = emp/Ljt*diff1
gen I_ijt = emp/Ljt*sum_dollar

bysort year fipstate fipscty: egen DI_it10 = total(DI_ijt10)
bysort year fipstate fipscty: egen DI_it5 = total(DI_ijt5)
bysort year fipstate fipscty: egen DI_it3 = total(DI_ijt3)
bysort year fipstate fipscty: egen DI_it1 = total(DI_ijt1)
bysort year fipstate fipscty: egen I_it = total(I_ijt)

gen D10_IPW = DI_it10/Lit
gen D5_IPW = DI_it5/Lit
gen D3_IPW = DI_it3/Lit
gen D_IPW = DI_it1/Lit
gen IPW = I_it/Lit

sort year fipstate fipscty naics4

* HHI calculation
gen emp_in_cty = emp/Lit
gen eic2 = emp_in_cty^2
bysort year fipstate fipscty: egen hhit = total(eic2)

label variable diff10 "decadal changes in imports value per industry"
label variable diff5 "five-year changes in imports value per industry"
label variable Lit "employment in county i at time t"
label variable Ljt "employment in industry j at time t"
label variable DI_ijt10 "employment/Ljt*diff10"
label variable DI_ijt5 "employment/Ljt*diff5"
label variable DI_it10 "add up all DI_ijt across industry j in decadal change"
label variable DI_it5 "add up all DI_ijt across industry j in five-year change"
label variable D10_IPW "Decadal Difference in IPW in county i at time t"
label variable D5_IPW "Five-year Difference in IPW in county i at time t"
label variable IPW "Imports per worker in county i at time t"
label variable hhit "HHI index at time t"
save DDIPW92_new, replace

append using DDIPW98_new
save DDIPW_complete3, replace

/////////////////////////////////////////////////////////////////////////////////////////
* merge with other_country imports data
use DDIPW_complete3.dta, clear
rename _merge us_merge
merge m:1 year naics4 using other_naics4_agg.dta
drop if year==1990 | year==1991 | year==2017
//bysort year fipstate fipscty: egen Lit = sum(emp)
//bysort year naics4: egen Ljt = sum(emp)

gen DI_ijt10_o = emp/Ljt*diff10_o
gen DI_ijt5_o = emp/Ljt*diff5_o
gen DI_ijt3_o = emp/Ljt*diff3_o
gen DI_ijt_o = emp/Ljt*diff_o
gen I_ijt_o = emp/Ljt*dollar_o
//gen I_ijt = emp/Ljt*sum_dollar

bysort year fipstate fipscty: egen DI_it10_o = total(DI_ijt10_o)
bysort year fipstate fipscty: egen DI_it5_o = total(DI_ijt5_o)
bysort year fipstate fipscty: egen DI_it3_o = total(DI_ijt3_o)
bysort year fipstate fipscty: egen DI_it_o = total(DI_ijt_o)
bysort year fipstate fipscty: egen I_it_o = total(I_ijt_o)

gen D10_IPW_o = DI_it10_o/Lit
gen D5_IPW_o = DI_it5_o/Lit
gen D3_IPW_o = DI_it3_o/Lit
gen D_IPW_o = DI_it_o/Lit
gen IPW_o = I_it_o/Lit

sort year fipstate fipscty naics4

label variable diff10_o "decadal changes in imports value per industry for other countries"
label variable diff5_o "five-year changes in imports value per industry for other countries"
label variable diff3_o "three-year changes in imports value per industry for other countries"
label variable diff_o "one-year changes in imports value per industry for other countries"
label variable D10_IPW_o "Decadal Difference in IPW in county i at time t for other countries"
label variable D5_IPW_o "Five-year Difference in IPW in county i at time t for other countries"
label variable D3_IPW_o "three-year Difference in IPW in county i at time t for other countries"
label variable D_IPW_o "one-year Difference in IPW in county i at time t for other countries"
label variable IPW_o "Chinese exports per U.S. worker to other countriesin county i at time t"

save DDIPW_complete4, replace










