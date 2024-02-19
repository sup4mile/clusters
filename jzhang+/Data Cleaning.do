********************************************************************************
*
*							 Data Cleaning
*
********************************************************************************
/* 
We exclude using only data by drop fipstate==.; master only data doesn't matter
since we treat the imports change as zero by using total() computating DIPW 
*/
ssc install blindschemes
ssc install xtavplot
cd "V:\ic\zili"

* us imports regression preprocessing
clear
use DDIPW_complete3.dta
gen DIPW = D5_IPW/1000
replace IPW = IPW/1000
gen countyid=fipstate*1000+fipscty
order year fipstate fipscty countyid naics4 emp est Lit Ljt DIPW hhit
duplicates drop year countyid Lit DIPW, force
drop if fipstate == .
drop if year == 1990 | year == 1991 // no imports data on 1990, 1991
xtset countyid year   //unbalanced panel, gaps year in some counties
egen max_gap = max(year-year[_n-1]), by(countyid)
tab countyid if max_gap>1
drop if countyid == 9999 | countyid == 10999 | countyid == 15999 | countyid == 23999 | countyid == 33999 | countyid == 44999 | countyid == 48269| countyid == 48301 | countyid == 50999
gen lLit = log(Lit)
/*gen d_lLit = D.lLit
gen d3_lLit = S3.lLit
gen d5_lLit = S5.lLit
gen d10_lLit = S10.lLit
*/
gen F10_lLit = F10.lLit
gen d10_lLit = F10_lLit - lLit
gen F5_lLit = F5.lLit
gen d5_lLit = F5_lLit - lLit
tab year // monotone
save temp, replace

* manufacturing regression preprocessing
use DDIPW_complete3.dta
gen DIPW = D5_IPW/1000
replace IPW = IPW/1000
drop if _merge==2  //why emerge this case where 2016 does not have 3133..in CBP
drop if year == 1990 | year == 1991
bysort year fipstate fipscty: egen mLit = sum(emp) if naics4 >= 3100 & naics4 <= 3399
gen share_manu = mLit/Lit
gen countyid=fipstate*1000+fipscty
order year fipstate fipscty countyid naics4 emp est mLit share_manu Ljt DIPW hhit
drop if mLit==.
duplicates drop year countyid mLit DIPW, force
xtset countyid year   //unbalanced panel, gaps year in some counties
egen max_gap = max(year-year[_n-1]), by(countyid)
tab countyid if max_gap>1
codebook countyid if max_gap>1
drop if countyid == 9999 | countyid == 10999 | countyid == 15999 | countyid == 23999 | countyid == 33999 | countyid == 44999 | countyid == 48269| countyid == 48301 | countyid == 50999// 132 county has gaps year, delete all of them?
gen lmLit = log(mLit)
gen F10_lmLit = F10.lmLit
gen d10_lmLit = F10_lmLit - lmLit
gen F5_lmLit = F5.lmLit
gen d5_lmLit = F5_lmLit - lmLit
tab year
save temp_m, replace

* IV regression preprocessing
clear
use everything.dta
gen countyid=fipstate*1000+fipscty
drop if fipstate == . // drop using only data, master only diff==., treat as 0 in DIPW calculation 

replace D10_IPW_o = D10_IPW_o/1000
replace D5_IPW_o = D5_IPW_o/1000
replace D3_IPW_o = D3_IPW_o/1000
replace D_IPW_o = D_IPW_o/1000
replace D10_IPW = D10_IPW/1000
replace D5_IPW = D5_IPW/1000
replace IPW = IPW/1000
duplicates drop year countyid, force
order year fipstate fipscty countyid naics4 Lit Ljt IPW D5_IPW D10_IPW D_IPW_o D3_IPW_o D5_IPW_o D10_IPW_o hhit

drop naics- diff1
drop emp_in_cty-ap_nf

xtset countyid year   //unbalanced panel, gaps year in some counties
egen max_gap = max(year-year[_n-1]), by(countyid)
tab countyid if max_gap>1
drop if countyid == 9999 | countyid == 10999 | countyid == 15999 | countyid == 23999 | countyid == 33999 | countyid == 44999 | countyid == 48269| countyid == 48301 | countyid == 50999

gen lLit = log(Lit)
gen F10_lLit = F10.lLit
gen d10_lLit = F10_lLit - lLit
gen F5_lLit = F5.lLit
gen d5_lLit = F5_lLit - lLit
gen F3_lLit = F3.lLit
gen d3_lLit = F3_lLit - lLit
gen F_lLit = F.lLit
gen d_lLit = F_lLit - lLit
tab year // monotone
save iv_clean, replace

