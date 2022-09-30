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

	1. employment data (2022/cbp)
	
	   1990-1997: sic_naic4_2019.dta
	   
	   1998-2016: append_97naics4_2019.dta
	   
	2. Working age population data (2022/WORKING AGE POP)
	
	   working_age_pop (dta or csv)
	   
	3. import data (2022/imports)
	
## Data Cleaning

### Part One - Commuting Zone (CZ) Employment data

File path: 2022/CZ_assign

1. Add CZ identifier to each observation

    use the USDA CZ file as a reference: USDA_cz00.xls
    
    the reference document to deal with county division changes: County_Change.pdf
    
    code file: cz_identifier.py
    
    readin: USDA_cz00, sic_naic4_2019, and append_97naics4_2019
    
    result: sic_naic4_2019_cz and append_97naics4_2019_cz
    
2. Aggregate county-level observation to CZ-level

   code file: cz_aggregation.py
   
   readin: USDA_cz00, sic_naic4_2019_cz, append_97naics4_2019_cz, and working_age_pop
   
   result: 90-97_cz_wap.dta and 98-16_cz_wap.dta
    
