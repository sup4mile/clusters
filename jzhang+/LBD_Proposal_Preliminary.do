use Dorn_10yr, clear
duplicates tag countyid, g(dup)
drop if dup != 24
drop dup

* change dipw into thousand dollars per worker unit
replace d10_ipw = d10_ipw / 1000
replace d10_ipw_o = d10_ipw_o / 1000
* percentage change of emp-wap ratio 
replace d5_ipw = d5_ipw / 1000
replace d5_ipw_o = d5_ipw_o / 1000

* county population weight 
by countyid: gen wt_emp_i = emp_i[1]



* Regressions for LBD proposal presentation:
* Slide 1.a and 1.b:
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) mfg_sh_emp [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) i.year [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)
* for stacked differences:
keep if year==1992 |year==1997 |year==2002 |year==2007 |year==2011
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) mfg_sh_emp [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) i.year [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) mfg_sh_emp i.year [aw=wt_emp_i], first cluster(fipstate)

* Slide 2.a:
reg d5_emp_i_sh_wap hhi_2 i.year [aw=wt_emp_i], cluster(fipstate)
reg d5_emp_i_sh_wap hhi_4 i.year [aw=wt_emp_i], cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) hhi_4 i.year [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) hhi_4 mfg_sh_wap i.year [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) c.hhi_4##c.mfg_sh_wap i.year [aw=wt_emp_i], first cluster(fipstate)

* Slide 2.b:
reg d5_emp_i_sh_wap hhi_2 [aw=wt_emp_i], cluster(fipstate)
reg d5_emp_i_sh_wap hhi_4 [aw=wt_emp_i], cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) hhi_4 [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) hhi_4 mfg_sh_wap [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw=d5_ipw_o) c.hhi_4##c.mfg_sh_wap [aw=wt_emp_i], first cluster(fipstate)

* Slide 3:
ivregress 2sls d5_emp_i_sh_wap (d5_ipw c.d5_ipw#c.hhi_4 = d5_ipw_o c.d5_ipw_o#c.hhi_4)  mfg_sh_wap i.year [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw c.d5_ipw#c.hhi_4 = d5_ipw_o c.d5_ipw_o#c.hhi_4) hhi_4 mfg_sh_wap i.year [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw c.d5_ipw#c.hhi_4 = d5_ipw_o c.d5_ipw_o#c.hhi_4) mfg_sh_wap [aw=wt_emp_i], first cluster(fipstate)
ivregress 2sls d5_emp_i_sh_wap (d5_ipw c.d5_ipw#c.hhi_4 = d5_ipw_o c.d5_ipw_o#c.hhi_4) hhi_4 mfg_sh_wap [aw=wt_emp_i], first cluster(fipstate)