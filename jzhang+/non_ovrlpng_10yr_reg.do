*==========================================================================================================
*==========================================================================================================
 drop if year > 2007
********************************************************************************************************** 
* table 3 d10_mfg_sh_wap
********************************************************************************************************** 
ivregress 2sls d10_mfg_sh_wap (d10_ipw=d10_ipw_o) i.year [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_mfg_sh_wap (d10_ipw=d10_ipw_o) mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 2-digit NAICS
********************************************************************************************************** 
ivregress 2sls d10_mfg_sh_wap (d10_ipw=d10_ipw_o) hhi_2 i.year [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_mfg_sh_wap (d10_ipw=d10_ipw_o) hhi_2 mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 4-digit NAICS
********************************************************************************************************** 
ivregress 2sls d10_mfg_sh_wap (d10_ipw=d10_ipw_o) hhi_4 i.year [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_mfg_sh_wap (d10_ipw=d10_ipw_o) hhi_4 mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)

* replace d10_mfg_sh_wap with d10_emp_i_sh_wap

********************************************************************************************************** 
* table 3 d10_emp_i_sh_wap
********************************************************************************************************** 
ivregress 2sls d10_emp_i_sh_wap (d10_ipw=d10_ipw_o) i.year  [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_emp_i_sh_wap (d10_ipw=d10_ipw_o) mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 2-digit NAICS
********************************************************************************************************** 
ivregress 2sls d10_emp_i_sh_wap (d10_ipw=d10_ipw_o) hhi_2 i.year [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_emp_i_sh_wap (d10_ipw=d10_ipw_o) hhi_2 mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)

********************************************************************************************************** 
* add HHI @ 4-digit NAICS
********************************************************************************************************** 
ivregress 2sls d10_emp_i_sh_wap (d10_ipw=d10_ipw_o) hhi_4 i.year [aw=wt_emp_i], first cluster(fipstate)

ivregress 2sls d10_emp_i_sh_wap (d10_ipw=d10_ipw_o) hhi_4 mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)
log close

