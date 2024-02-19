//cd V:\ic\zili
//us-China imports growth
use hs_cn_new.dta
keep if year == 1992 | year == 2000 | year == 2007
by naics4: gen d_impgrow = sum_dollar[2]-sum_dollar[1]
by naics4: replace d_impgrow = sum_dollar[3]-sum_dollar[2] if year == 2000
drop if d_impgrow ==.
keep if year == 1992 | year == 2000
keep year naics4 sum_dollar d_impgrow
replace d_impgrow = d_impgrow*10/8 if year == 1992
replace d_impgrow = d_impgrow*10/7 if year == 2000
save hs_cn_9207.dta, replace

//other countries- China imports growth
use other_naics4_agg.dta 
keep if year == 1992 | year ==2000 | year == 2007
by naics4: gen d_impgrow_o = dollar_o[2]-dollar_o[1]
by naics4: replace d_impgrow_o = dollar_o[3]-dollar_o[2] if year == 2000
drop if d_impgrow ==.
keep if year == 1992 | year == 2000
keep year naics4 d_impgrow_o
replace d_impgrow_o = d_impgrow_o*10/8 if year == 1992
replace d_impgrow_o = d_impgrow_o*10/7 if year == 2000
save other_naics4_agg_9207.dta, replace
