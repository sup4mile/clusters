# clusters

This project analyzes the effect of industry concentration on employment dynamics. 
The raw data consist of the County Business Pattern (CBP) and the imports data from the United Nations Comtrade Database. The time periods in the current data sets are 1992-2016 for CBP and 1992-2019 for imports data. 

The main data cleaning tasks are:
1. compile the employment data in CBP and deal with employment noise imputation 
2. combine imports data from other countries and reclassify all imports data from Harmonized System (HS)code to the North American Industry Classification System (NAICS) code 
3. change the Standardized Industry Code (SIC) into the NAICS code in the 1992-1997 employment data. There are other minor changes in the industry and county classification over the year. The main data analysis task is a 2SLS. All files are stored in the Linux Project V:\ic

--------------------------------------------------------------------------------------------------------

## Raw data sources 
1. Employment data: County Business Patterns from the U.S. Census 1992-2016  
	
	Retrieved from https://www.census.gov/programs-surveys/cbp.html 
	
	Data -> County Business Patterns Data-> CBP Datasets -> Year -> Complete County File
	
2. Imports data: United Nations Comtrade Database 1992-2016 
	
	Retrieved from https://comtrade.un.org/
	
	To get import data from China: Get data -> Select year ->Reporters: USA -> Partners: China -> Trade flows: Import _> HS Codes: AG6 -All 6-digit HS commodities -> get data 
	
3. Working age population data by county: Census Intercensal Datasets
	
	1990-2000 retrieved from https://www.census.gov/data/datasets/time-series/demo/popest/intercensal-1990-2000-state-and-county-characteristics.html
	
	2000-2010 retrieved from https://www.census.gov/data/datasets/time-series/demo/popest/intercensal-2000-2010-counties.html
	
	The do file to merge: WORKING AGE POP/WAP2000_2010_stata.do
	
	read in: WAP2000_2010.csv, WAPyyyy.csv (yyyy is each year from 1990 to 1999)
	
	result: working_age_pop.dta and working_age_pop.csv
--------------------------------------------------------------------------------------------------------
## Data Cleaning 

### Part One - Employment data

File path: jzhang 

1. Change raw data into dta format 
	 
	cbp_related/cbp_raw_to_dta.do
	
	read in: cbpYYco.txt (the raw CBP data txt file, YY is the year)
	
	result: cbpYYYYco.dta (this is the input raw data for imputation)

2. Imputation of employment data for each year 
	
	cbp_related/Dorn_cbptemp_1991.do
        	
	imputation of noise in the CBP data 
        
	read in: cbp1991co.csv or .dta
        result: cbp1991temp.dta
        (same process for year 1994, 2016, 2018) 
	
	See cbp_related/cbp2017_imputations.log for an example log of imputation on 2017 data 

3. Append each year’s employment data into 
	append_97naics4.dta 



### Part Two - Imports Data 
File path: Imports data 

1. Raw data used
	
	Imports from China: im_from_China.dta (1992-2019) 
	
	Imports from other countries: C7 (1992-2016) 
	
	C7/other_process.do 
	merge all imports from AUS, Den, Fin, Germ, Newz, Spain, Swiss, Jap to one dta file (other_agg.dta)

2. Change imports data industry classifications from Harmonized System (HS) code into NAICS 
	6hs-6naics.do
	
	The data after cleaning is other_naics4_agg.dta



### Part Three - Construct the final data set
File path: jzhang+

Note: From 1990 to 1997, the data used SIC (the Standard Industry Code) to classify industries. In 1998-2016, the data used the NAICS code. After the data cleaning, all industry classifications are in NAICS code. 

ipw_progress.do 

1. employment data 
	
	1990-1997:  sic_naics4.dta
	
	1998-2016: append_97naics4.dta
	
2. import from China data: 1992-2017: hs_cn_new.dta
	
	Generate 1, 3, 5, 10 year differences in import in jzhang+/ipw_progress.do 
	
	Save new data as DDIPW92_new.dta and DDIPW98_new.dta 
	
	Combine two data sets to get DDIPW_complete3_new.dta 
	
3. import from other countries data: other_naics4_agg.dta
	
	Combine imports from China and imports from other countries to get DDIPW_complete4_new.dta 
	
	Change of county ID in virginia: va_ctyid_new 
	
	Final step: cty_clean_9216_new.do 

## Data Analysis

        
Final dataset from the data cleaning phase: jzhang+/cty_clean_9216_final.dta

Import data construction: 201026_9216data_construction.do
	
Merge and construct 1992-2007 dataset, then perform the 2SLS: 201026_overlapping_reg.do 
	
--------------------------------------------------------------------------------------------------------
# 2022 Fall Updates

The section below keeps track of the updates in 2022 Fall. 

## Raw data file

1. employment data (File path: ic/data/raw_data/cbp)
	
    1990-1997: sic_naic4_2019.dta
	   
    1998-2016: append_97naics4_2019.dta
	   
2. Working age population data (File path: ic/data/raw_data/WORKING AGE POP)
	
    working_age_pop (dta or csv)
	   
3. import data (ic/old data)
    US imports from China: hs_cn_new
    
    other countries' imports from China: other_naics4_agg
	
	
## Weight of HS10-HS6:
Other countries only have HS6 inteade of HS10 codes. We estimate weights HS10 in its HS10 based on the US import record. Therfore, we need to weight these HS6 to US HS10 codes. 6hs-6naics.do (old_data/Imports data) calculate weights and apply these weights to other countries' imports from China. cw_hs6_naics6_yby.dta (old_data/Imports data) is the datafile after splitting  6-digit other countries’ imports into 10-digit code, and hs_sic_naics_imports_89_117....dta (old_data/Imports data) is the reference for crosswalk from HS10 to NAICS6. Two final import datafiles are described above.

	
## Data Cleaning

### Part One - Commuting Zone (CZ) level data (ic/code/commuting_zone_CZ)

1. cz_identifier.py 

    **Purpose**: Add CZ identifier to each observation
    
    readin: USDA_cz00, sic_naic4_2019, and append_97naics4_2019
    
    output: sic_naic4_2019_cz and append_97naics4_2019_cz  (File path: ic/data/community_zone_CZ/)
    
    Remark: use the USDA CZ file as a reference: USDA_cz00.xls, and the reference document to deal with county division changes is County_Change.pdf
    
2. cz_aggregation.py

    **Purpose**: 
    	1) Aggregate county-level observation to CZ-level
	2) Assign each CZ with a state code based on the employment
   
    readin: USDA_cz00, sic_naic4_2019_cz, and append_97naics4_2019_cz,
      
    output: 90-97_cz.csv and 98-16_cz.csv  (File path: ic/data/community_zone_CZ/)
   
3. wap_cz.py

    **Purpose**: Aggregate county-level working age population to CZ-level
    
    readin: USDA_cz00
    
    output: wap_cz.csv (File path: ic/data/community_zone_CZ/)
    
### Part Two - Forward 1, 3, 5, 10-year differences (ic/code/diff_computation)

1. ipt_diff&hhi.do

    **Purpose**: 
    	1) Calculate forward differences of imports (in dollars)
	2) Calculate forward differences of imports per worker (in dollars)
	3) Calculate HHI at both 4-digit NAICS and 2-digit NAICS levels for each CZ
                         
    readin: 90-97_cz.csv,  98-16_cz.csv, hs_cn_new.dta, and other_naics4_agg.dta 
    
    intermediate output: 98-16_cz_ipt_dif.dta, 90-97_cz_ipt_diff.dta, and 90-16_cz_ipt_diff.dta (File path: ic/data/diff_computation/)
    
    final output: 90-16_cz_ipt_diff_allcountries.dta and hhi_naics2.dta (File path: ic/data/diff_computation/)
    
    
2. other_diff.do

    **Purpose**: 
    	1) Clean up CZ-level working age population and calculate forward differences of it
	2) Calculate forward differences of manufacturing industry
	3) Calculate forward differences of CZ employment share in working age population
	4) Merge HHI and all forward differences into a final datafile
                         
    readin: wap_cz.csv and 90-16_cz_ipt_diff_allcountries.dta
    
    intermediate output: wap_cz_cleaned.dta and manufacturing_gap.dta (File path: ic/data/diff_computation/)
    
    final output: cz_clean_file.dta (File path: ic/data/diff_computation/)
    
    
    
### Part Three - Regression (ic/code/regression)

All regression do files readin: cz_clean_file.dta (File path: ic/data/diff_computation/)
    
1. emp_sh_wap_regress.do

    Regress change of employment share in WAP on changes in import per workers, manu employ share in employ, hhi_4, and the interaction of changes in import per workers with hhi_4 under different year stacks
    
2. log_emp_regress.do

    Regress log difference in employement on changes in import per workers, manu employ share in employ, hhi_4, and the interaction of changes in import per workers with hhi_4 under different year stacks
