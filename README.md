# clusters

This project analyzes the effect of industry concentration on employment dynamics. 
The raw data consist of the County Business Pattern (CBP) and the imports data from the United Nations Comtrade Database. The time periods in the current data sets are 1992-2016 for CBP and 1992-2019 for imports data. 

The main data cleaning tasks are (1) compile the employment data in CBP and deal with employment noise imputation (2) combine imports data from other countries and reclassify all imports data from Harmonized System (HS)code to the North American Industry Classification System (NAICS) code (3) change the Standardized Industry Code (SIC) into the NAICS code in the 1992-1997 employment data. There are other minor changes in the industry and county classification over the year. The main data analysis task is a 2SLS. All files are stored in the Linux Project V:\ic

--------------------------------------------------------------------------------------------------------
Raw data sources 
1. Employment data: County Business Patterns from the U.S. Census 1992-2016  
	
	Retrieved from https://www.census.gov/programs-surveys/cbp.html 
	
	Data -> County Business Patterns Data-> CBP Datasets -> Year -> Complete County File
	
2. Imports data: United Nations Comtrade Database 1992-2016 
	
	Retrieved from https://www.comtrade.un.org 
	
	To get import data from China: Select year ->Reporters: USA -> Partners: China -> Trade flows: Import _> HS Codes: AG6 -All 6-digit HS commodities -> get data 
--------------------------------------------------------------------------------------------------------
Data Cleaning 

Part One - Employment data

File path: jzhang 

1. Change raw data into dta format 
	 
	cbp_related/cbp_raw_to_dta.do
	
	read in: cbpYYco.txt (the raw CBP data txt file, Yy is the year)
	
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



Part Two - Imports Data 
File path: Imports data 

1. Raw data used
	
	Imports from China: im_from_China.dta (1992-2019) 
	
	Imports from other countries: C7 (1992-2016) 
	
	C7/other_process.do 
	merge all imports from AUS, Den, Fin, Germ, Newz, Spain, Swiss, Jap to one dta file

2. Change imports data industry classifications from Harmonized System (HS) code into NAICS 
	6hs-6naics.do
	
	The data after cleaning is other_naics4_agg.dta



Part Three - Construct the final data set
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
--------------------------------------------------------------------------------------------------------
Data Analysis

        
Final dataset from the data cleaning phase: jzhang+/cty_clean_9216_final.dta

Import data construction: 201026_9216data_construction.do
	
Merge and construct 1992-2007 dataset, then perform the 2SLS: 201026_overlapping_reg.do 
	

