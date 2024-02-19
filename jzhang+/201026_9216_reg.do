//redo "Dorn_9207_Reg.do"
* regression 
* check whether each county has both 1992 and 2000 data
use Dorn_9216, clear
duplicates report countyid
gen yr = 1 if year == 1992
replace yr = 2 if year == 2000
replace yr = 3 if year == 2007
by countyid: egen yr_sum = sum(yr)
tab countyid if yr_sum != 6  
drop if countyid ==  2231 | countyid ==  2232 | countyid ==  2282
drop if countyid ==  8014 | countyid ==  11001 | countyid ==  48269
duplicates report countyid
drop yr yr_sum

* change dipw into thousand dollars per worker unit
replace Dorn_DIPW = Dorn_DIPW / 1000
replace Dorn_DIPW_o = Dorn_DIPW_o / 1000
* percentage change of emp-wap ratio 
replace d10_mfg_sh_wap = 100 * d10_mfg_sh_wap
replace d10_emp_i_sh_wap = 100 * d10_emp_i_sh_wap

* county population weight 
by countyid: gen wt_emp_i = emp_i[1]
gen t2000 = (year == 2000)
gen t2007 = (year == 2007)


cap log close
log using ivreg_9216_mfg.log, replace

* table 3 
ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) t2000 t2007 [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) mfg_sh_emp t2000 t2007 [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 2-digit NAICS
********************************************************************************************************** 
ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) hhi_2 t2000 t2007 [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) hhi_2 mfg_sh_emp t2000 t2007 [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 4-digit NAICS
********************************************************************************************************** 
ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) hhi_4 t2000 t2007 [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_mfg_sh_wap (Dorn_DIPW=Dorn_DIPW_o) hhi_4 mfg_sh_emp t2000 t2007 [aw=wt_emp_i], first cluster(fipstate)
log close


* replace d10_mfg_sh_wap with d10_emp_i_sh_wap

cap log close
log using ivreg_9216_empi.log, replace

* table 3 
ivregress 2sls d10_emp_i_sh_wap (Dorn_DIPW=Dorn_DIPW_o) t2000 t2007 [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_emp_i_sh_wap (Dorn_DIPW=Dorn_DIPW_o) mfg_sh_emp t2000 t2007 [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 2-digit NAICS
********************************************************************************************************** 
ivregress 2sls d10_emp_i_sh_wap (Dorn_DIPW=Dorn_DIPW_o) hhi_2 t2000 t2007 [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_emp_i_sh_wap (Dorn_DIPW=Dorn_DIPW_o) hhi_2 mfg_sh_emp t2000 t2007 [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 4-digit NAICS
********************************************************************************************************** 
ivregress 2sls d10_emp_i_sh_wap (Dorn_DIPW=Dorn_DIPW_o) hhi_4 t2000 t2007 [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_emp_i_sh_wap (Dorn_DIPW=Dorn_DIPW_o) hhi_4 mfg_sh_emp t2000 t2007 [aw=wt_emp_i], first cluster(fipstate)
log close

