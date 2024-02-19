//redo "Dorn_9207_Reg.do"
* regression 
* check whether each county has both 1992 and 2000 data
use Dorn_10yr, clear
duplicates tag countyid, g(dup)
drop if dup != 24
drop dup

* change dipw into thousand dollars per worker unit
replace d10_ipw = d10_ipw / 1000
replace d10_ipw_o = d10_ipw_o / 1000
replace d5_ipw = d5_ipw / 1000
replace d5_ipw_o = d5_ipw_o / 1000

* county population weight 
by countyid: gen wt_emp_i = emp_i[1]

* Keep only non-overlapping long-differences:
keep if year==1992 | year==1997 | year==2002 | year==2007 | year==2011
cap log close
log using ivreg_non_ovrlpg.log, replace
 
********************************************************************************************************** 
* table 3 d5_mfg_sh_wap
********************************************************************************************************** 
ivregress 2sls d5_mfg_sh_wap (d5_ipw=d5_ipw_o) [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d5_mfg_sh_wap (d5_ipw=d5_ipw_o) mfg_sh_emp [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 2-digit NAICS
********************************************************************************************************** 
ivregress 2sls d5_mfg_sh_wap (d5_ipw=d5_ipw_o) hhi_2  [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d5_mfg_sh_wap (d5_ipw=d5_ipw_o) hhi_2 mfg_sh_emp  [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 4-digit NAICS
********************************************************************************************************** 
ivregress 2sls d5_mfg_sh_wap (d5_ipw=d5_ipw_o) hhi_4  [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d5_mfg_sh_wap (d5_ipw=d5_ipw_o) hhi_4 mfg_sh_emp  [aw=wt_emp_i], first cluster(fipstate)


* replace d5_mfg_sh_wap with d5_emp_i_sh_wap

********************************************************************************************************** 
* table 3 d5_emp_i_sh_wap
********************************************************************************************************** 
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) mfg_sh_emp [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 2-digit NAICS
********************************************************************************************************** 
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) hhi_2 [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) hhi_2 mfg_sh_emp [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 4-digit NAICS
********************************************************************************************************** 
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) hhi_4 [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) hhi_4 mfg_sh_emp [aw=wt_emp_i], first cluster(fipstate)


*==========================================================================================================
*==========================================================================================================
 
********************************************************************************************************** 
* table 3 d10_mfg_sh_wap
********************************************************************************************************** 
ivregress 2sls d10_mfg_sh_wap (d10_ipw=d10_ipw_o) [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_mfg_sh_wap (d10_ipw=d10_ipw_o) mfg_sh_emp [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 2-digit NAICS
********************************************************************************************************** 
ivregress 2sls d10_mfg_sh_wap (d10_ipw=d10_ipw_o) hhi_2  [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_mfg_sh_wap (d10_ipw=d10_ipw_o) hhi_2 mfg_sh_emp  [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 4-digit NAICS
********************************************************************************************************** 
ivregress 2sls d10_mfg_sh_wap (d10_ipw=d10_ipw_o) hhi_4  [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_mfg_sh_wap (d10_ipw=d10_ipw_o) hhi_4 mfg_sh_emp  [aw=wt_emp_i], first cluster(fipstate)

* replace d10_mfg_sh_wap with d10_emp_i_sh_wap

********************************************************************************************************** 
* table 3 d10_emp_i_sh_wap
********************************************************************************************************** 
ivregress 2sls d10_emp_i_sh_wap (d10_ipw=d10_ipw_o) [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_emp_i_sh_wap (d10_ipw=d10_ipw_o) mfg_sh_emp [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 2-digit NAICS
********************************************************************************************************** 
ivregress 2sls d10_emp_i_sh_wap (d10_ipw=d10_ipw_o) hhi_2 [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_emp_i_sh_wap (d10_ipw=d10_ipw_o) hhi_2 mfg_sh_emp [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 4-digit NAICS
********************************************************************************************************** 
ivregress 2sls d10_emp_i_sh_wap (d10_ipw=d10_ipw_o) hhi_4 [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_emp_i_sh_wap (d10_ipw=d10_ipw_o) hhi_4 mfg_sh_emp [aw=wt_emp_i], first cluster(fipstate)
log close


*=========================================================================================
*adding year dummy
drop if year > 2012
cap log close
log using ivreg_overlapping_year_dummy.log, replace
 
********************************************************************************************************** 
* table 3 d5_mfg_sh_wap
********************************************************************************************************** 
ivregress 2sls d5_mfg_sh_wap (d5_ipw=d5_ipw_o) i.year [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d5_mfg_sh_wap (d5_ipw=d5_ipw_o) mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 2-digit NAICS
********************************************************************************************************** 
ivregress 2sls d5_mfg_sh_wap (d5_ipw=d5_ipw_o) hhi_2 i.year [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d5_mfg_sh_wap (d5_ipw=d5_ipw_o) hhi_2 mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 4-digit NAICS
********************************************************************************************************** 
ivregress 2sls d5_mfg_sh_wap (d5_ipw=d5_ipw_o) hhi_4 i.year [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d5_mfg_sh_wap (d5_ipw=d5_ipw_o) hhi_4 mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)


* replace d5_mfg_sh_wap with d5_emp_i_sh_wap

********************************************************************************************************** 
* table 3 d5_emp_i_sh_wap
********************************************************************************************************** 
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) i.year [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 2-digit NAICS
********************************************************************************************************** 
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) hhi_2 i.year [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) hhi_2 mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 4-digit NAICS
********************************************************************************************************** 
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) hhi_4 i.year [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) hhi_4 mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)

log close

