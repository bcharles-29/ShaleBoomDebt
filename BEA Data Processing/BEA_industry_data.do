*Created June 21, 2024
*Version 17

* Clear memory before beginning analysis
clear
* Housekeeping -  close any open log 
capture log close
set more off


*** DIRECTORIES
local BEA_DATA "BEA Data Files/"
local BEA_STATA "../BEA DTA Files/"
local GROUPS "../../Community Group Identification/"

*** Set directory and output directories
cd "`BEA_DATA'"

*** Population Data

import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if description=="Population (persons) 2/"

ren v9 pop2001
ren v10 pop2002
ren v11 pop2003
ren v12 pop2004
ren v13	pop2005
ren v14 pop2006
ren v15 pop2007
ren v16	pop2008
ren v17 pop2009
ren v18 pop2010
ren v19 pop2011
ren v20 pop2012
ren v21 pop2013
ren v22 pop2014
ren v23 pop2015
ren v24 pop2016
ren v25 pop2017
ren v26	pop2018
ren v27 pop2019
ren v28 pop2020
ren v29 pop2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_POP.dta, replace
clear

*** Oil and Gas Extraction Earnings Data

cd "../`BEA_DATA'"
import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if industryclassification=="211"

ren v9 og2001
ren v10 og2002
ren v11 og2003
ren v12 og2004
ren v13	og2005
ren v14 og2006
ren v15 og2007
ren v16	og2008
ren v17 og2009
ren v18 og2010
ren v19 og2011
ren v20 og2012
ren v21 og2013
ren v22 og2014
ren v23 og2015
ren v24 og2016
ren v25 og2017
ren v26	og2018
ren v27 og2019
ren v28 og2020
ren v29 og2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_OG.dta, replace
clear

*** Mining Support (incl. Oil and Gas) Earnings
cd "../`BEA_DATA'"
import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if industryclassification=="213"

ren v9 minsup2001
ren v10 minsup2002
ren v11 minsup2003
ren v12 minsup2004
ren v13	minsup2005
ren v14 minsup2006
ren v15 minsup2007
ren v16	minsup2008
ren v17 minsup2009
ren v18 minsup2010
ren v19 minsup2011
ren v20 minsup2012
ren v21 minsup2013
ren v22 minsup2014
ren v23 minsup2015
ren v24 minsup2016
ren v25 minsup2017
ren v26	minsup2018
ren v27 minsup2019
ren v28 minsup2020
ren v29 minsup2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_MINSUP.dta, replace
clear

*** Earnings by Place of Work Data
cd "../`BEA_DATA'"
import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if description=="Earnings by place of work "

ren v9 totearn2001
ren v10 totearn2002
ren v11 totearn2003
ren v12 totearn2004
ren v13	totearn2005
ren v14 totearn2006
ren v15 totearn2007
ren v16	totearn2008
ren v17 totearn2009
ren v18 totearn2010
ren v19 totearn2011
ren v20 totearn2012
ren v21 totearn2013
ren v22 totearn2014
ren v23 totearn2015
ren v24 totearn2016
ren v25 totearn2017
ren v26	totearn2018
ren v27 totearn2019
ren v28 totearn2020
ren v29 totearn2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_TOT_EARN.dta, replace
clear

*** Construction Sector Earnings Data
cd "../`BEA_DATA'"
import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if industryclassification=="23"

ren v9 cons2001
ren v10 cons2002
ren v11 cons2003
ren v12 cons2004
ren v13	cons2005
ren v14 cons2006
ren v15 cons2007
ren v16	cons2008
ren v17 cons2009
ren v18 cons2010
ren v19 cons2011
ren v20 cons2012
ren v21 cons2013
ren v22 cons2014
ren v23 cons2015
ren v24 cons2016
ren v25 cons2017
ren v26	cons2018
ren v27 cons2019
ren v28 cons2020
ren v29 cons2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_CONS.dta, replace
clear

*** Manufacturing Sector Earnings Data
cd "../`BEA_DATA'"
import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if industryclassification=="31-33"

ren v9 manf2001
ren v10 manf2002
ren v11 manf2003
ren v12 manf2004
ren v13	manf2005
ren v14 manf2006
ren v15 manf2007
ren v16	manf2008
ren v17 manf2009
ren v18 manf2010
ren v19 manf2011
ren v20 manf2012
ren v21 manf2013
ren v22 manf2014
ren v23 manf2015
ren v24 manf2016
ren v25 manf2017
ren v26	manf2018
ren v27 manf2019
ren v28 manf2020
ren v29 manf2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_MANF.dta, replace
clear

*** Retail Trade Sector Earnings Data
cd "../`BEA_DATA'"
import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if industryclassification=="44-45"

ren v9 retail2001
ren v10 retail2002
ren v11 retail2003
ren v12 retail2004
ren v13	retail2005
ren v14 retail2006
ren v15 retail2007
ren v16	retail2008
ren v17 retail2009
ren v18 retail2010
ren v19 retail2011
ren v20 retail2012
ren v21 retail2013
ren v22 retail2014
ren v23 retail2015
ren v24 retail2016
ren v25 retail2017
ren v26	retail2018
ren v27 retail2019
ren v28 retail2020
ren v29 retail2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_RETAIL.dta, replace
clear

*** Farm Sector Earnings Data
cd "../`BEA_DATA'"
import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if industryclassification=="111-112"

ren v9 farm2001
ren v10 farm2002
ren v11 farm2003
ren v12 farm2004
ren v13	farm2005
ren v14 farm2006
ren v15 farm2007
ren v16	farm2008
ren v17 farm2009
ren v18 farm2010
ren v19 farm2011
ren v20 farm2012
ren v21 farm2013
ren v22 farm2014
ren v23 farm2015
ren v24 farm2016
ren v25 farm2017
ren v26	farm2018
ren v27 farm2019
ren v28 farm2020
ren v29 farm2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_FARM.dta, replace
clear

*** Forestry,fishing, and related activities Sector Earnings Data
cd "../`BEA_DATA'"
import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if industryclassification=="113-115"

ren v9 forest2001
ren v10 forest2002
ren v11 forest2003
ren v12 forest2004
ren v13	forest2005
ren v14 forest2006
ren v15 forest2007
ren v16	forest2008
ren v17 forest2009
ren v18 forest2010
ren v19 forest2011
ren v20 forest2012
ren v21 forest2013
ren v22 forest2014
ren v23 forest2015
ren v24 forest2016
ren v25 forest2017
ren v26	forest2018
ren v27 forest2019
ren v28 forest2020
ren v29 forest2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_FOREST.dta, replace
clear

*** Non-Oil & Gas Mining Sector Earnings Data
cd "../`BEA_DATA'"
import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if industryclassification=="212"

ren v9 mining2001
ren v10 mining2002
ren v11 mining2003
ren v12 mining2004
ren v13	mining2005
ren v14 mining2006
ren v15 mining2007
ren v16	mining2008
ren v17 mining2009
ren v18 mining2010
ren v19 mining2011
ren v20 mining2012
ren v21 mining2013
ren v22 mining2014
ren v23 mining2015
ren v24 mining2016
ren v25 mining2017
ren v26	mining2018
ren v27 mining2019
ren v28 mining2020
ren v29 mining2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_MININGexOG.dta, replace
clear

*** Federal Government Sector Earnings Data
cd "../`BEA_DATA'"
import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if description=="   Federal civilian "

ren v9 fed2001
ren v10 fed2002
ren v11 fed2003
ren v12 fed2004
ren v13	fed2005
ren v14 fed2006
ren v15 fed2007
ren v16	fed2008
ren v17 fed2009
ren v18 fed2010
ren v19 fed2011
ren v20 fed2012
ren v21 fed2013
ren v22 fed2014
ren v23 fed2015
ren v24 fed2016
ren v25 fed2017
ren v26	fed2018
ren v27 fed2019
ren v28 fed2020
ren v29 fed2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_FED.dta, replace
clear

*** Military Sector Earnings Data
cd "../`BEA_DATA'"
import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if description=="   Military "

ren v9 military2001
ren v10 military2002
ren v11 military2003
ren v12 military2004
ren v13	military2005
ren v14 military2006
ren v15 military2007
ren v16	military2008
ren v17 military2009
ren v18 military2010
ren v19 military2011
ren v20 military2012
ren v21 military2013
ren v22 military2014
ren v23 military2015
ren v24 military2016
ren v25 military2017
ren v26	military2018
ren v27 military2019
ren v28 military2020
ren v29 military2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_MILITARY.dta, replace
clear

*** State and Local Government Sector Earnings Data
cd "../`BEA_DATA'"
import delimited "CAINC5N__ALL_AREAS_2001_2021.csv"

keep if description=="   State and local "

ren v9 slgov2001
ren v10 slgov2002
ren v11 slgov2003
ren v12 slgov2004
ren v13	slgov2005
ren v14 slgov2006
ren v15 slgov2007
ren v16	slgov2008
ren v17 slgov2009
ren v18 slgov2010
ren v19 slgov2011
ren v20 slgov2012
ren v21 slgov2013
ren v22 slgov2014
ren v23 slgov2015
ren v24 slgov2016
ren v25 slgov2017
ren v26	slgov2018
ren v27 slgov2019
ren v28 slgov2020
ren v29 slgov2021

cd "`BEA_STATA'"
save CAINC5N__ALL_AREAS_SLGOV.dta, replace
clear


*** Merge files with data for each variable

use CAINC5N__ALL_AREAS_POP.dta
merge 1:1 geoname using CAINC5N__ALL_AREAS_OG.dta
drop _merge
merge 1:1 geoname using CAINC5N__ALL_AREAS_MINSUP.dta
drop _merge
merge 1:1 geoname using CAINC5N__ALL_AREAS_TOT_EARN.dta
drop _merge
merge 1:1 geoname using CAINC5N__ALL_AREAS_CONS.dta
drop _merge
merge 1:1 geoname using CAINC5N__ALL_AREAS_MANF.dta
drop _merge
merge 1:1 geoname using CAINC5N__ALL_AREAS_RETAIL.dta
drop _merge
merge 1:1 geoname using CAINC5N__ALL_AREAS_FARM.dta
drop _merge
merge 1:1 geoname using CAINC5N__ALL_AREAS_FOREST.dta
drop _merge
merge 1:1 geoname using CAINC5N__ALL_AREAS_MININGexOG.dta
drop _merge
merge 1:1 geoname using CAINC5N__ALL_AREAS_FED.dta
drop _merge
merge 1:1 geoname using CAINC5N__ALL_AREAS_MILITARY.dta
drop _merge
merge 1:1 geoname using CAINC5N__ALL_AREAS_SLGOV.dta
drop _merge

*** Reshape data to long format
reshape long pop og minsup totearn cons manf retail farm forest mining fed military slgov, i(geoname) j(year)

*** Drop state and national aggregate data_files/Shale-Muni-Debt-Replication/BEA
keep if ustrpos(geoname, ", ")

*** Label sector variables for clarity
label variable pop "total population"
label variable og "oil and natural gas sector earnings, thousands of dollars"
label variable minsup "mining support sector earnings, including oil and natural gas services, thousands of dollars"
label variable totearn "total earnings, thousands of dollars"
label variable cons "construction sector earnings, thousands of dollars"
label variable manf "manufacturing sector earnings, thousands of dollars"
label variable retail "retail sector earnings, thousands of dollars"
label variable farm "farming sector earnings, thousands of dollars"
label variable forest "forestry, fishing, and related activities sector earnings, thousands of dollars"
label variable mining "mining sector earnings, excluding oil and natural gas, thousands of dollars"
label variable fed "federal government sector earnings, thousands of dollars"
label variable military "military sector earnings, thousands of dollars"
label variable slgov "state and local government sector earnings, thousands of dollars"

save CAINC5N_all_counties.dta, replace

*** Note 1: D indicates potential confidentiality issue with data
*** Note 2:	NA indicates data not available
*** See BEA data footnotes for details
*** Replace "D" and "NA" with blank space to facilitate destringing data

replace pop=" " if pop=="(D)"
replace pop=" " if pop=="(NA)"
replace og="" if og=="(D)"
replace og="" if og=="(NA)"
replace minsup="" if minsup=="(D)"
replace minsup="" if minsup=="(NA)"
replace totearn="" if totearn=="(D)"
replace totearn="" if totearn=="(NA)"
replace cons="" if cons=="(D)"
replace cons="" if cons=="(NA)"
replace manf="" if manf=="(D)"
replace manf="" if manf=="(NA)"
replace retail="" if retail=="(D)"
replace retail="" if retail=="(NA)"
replace farm="" if farm=="(D)"
replace farm="" if farm=="(NA)"
replace forest="" if forest=="(D)"
replace forest="" if forest=="(NA)"
replace mining="" if mining=="(D)"
replace mining="" if mining=="(NA)"
replace fed="" if fed=="(D)"
replace fed="" if fed=="(NA)"
replace military="" if military=="(D)"
replace military="" if military=="(NA)"
replace slgov="" if slgov=="(D)"
replace slgov="" if slgov=="(NA)"

	///	Need to fill missing values to avoid dropping large number of counties	///
	///	that have one or more years of missing data for one or more industry sectors ///

*** Replace missing values in major industry sector categories EXCEPT 
*** oil and gas extraction and mining support with average of available data

***	For oil and gas and mining support sectors, replace missing values with 
*** pre- and post-shale boom averages to avoid imputing large boom period values
*** where much smaller or zero value is more appropriate

*** Note 1: This will still leave some missing values for counties that have 
*** no available data to average, but greatly reduces missing values

*** Note 2: most counties have just 1-2 missing values for  large/broad sectors 
*** such as construction, retail, manufacturing, and agriculture/farming.
*** Oil and gas extraction, mining, and mining support have larger stretches of 
*** missing data and more frequently missing initial values

*** Note 3: About 5% of records have at least one of construction, manufacturing, 
*** retail, and farm data missing based on indicator variable tabulation. 
*** About 40% of records having missing oil and gas or mining support data, 
*** though this includes lots of counties with nearly zero or very few earnings from either.

*Create numeric id variable and set time series data
egen id = group(geofips)
tsset id year

*Destring industry earnings variables
destring pop og minsup totearn cons manf retail farm forest mining fed military slgov, replace

***	For most industries/sectors, generate mean by county with available data, 
***	fill with mean by county/industry where data still missing 

***	For oil and gas and mining support, upward trends due to shale boom make 
***	applying averages from full data set problematic. Instead, fill with 
***	separate averages for pre-2008 years and 2008 and later years.

bysort id: egen og_mean_pre = mean(og) if year<2008
bysort id: egen og_mean_post = mean(og) if year>=2008
bysort id: egen minsup_mean_pre = mean(minsup) if year<2008
bysort id: egen minsup_mean_post = mean(minsup) if year>=2008
bysort id: egen cons_mean = mean(cons)
bysort id: egen manf_mean = mean(manf)
bysort id: egen retail_mean = mean(retail)
bysort id: egen farm_mean = mean(farm)
bysort id: egen forest_mean = mean(forest)
bysort id: egen mining_mean = mean(mining)
bysort id: egen fed_mean = mean(fed)
bysort id: egen military_mean = mean(military)
bysort id: egen slgov_mean = mean(slgov)
*
*
by id (year), sort: replace og = og_mean_pre if missing(og) & year<2008
by id (year), sort: replace og = og_mean_post if missing(og) & year>=2008
by id (year), sort: replace minsup = minsup_mean_pre if missing(minsup) & year<2008
by id (year), sort: replace minsup = minsup_mean_post if missing(minsup) & year>=2008
by id (year), sort: replace cons = cons_mean if missing(cons)
by id (year), sort: replace manf = manf_mean if missing(manf)
by id (year), sort: replace retail = retail_mean if missing(retail)
by id (year), sort: replace farm = farm_mean if missing(farm)
by id (year), sort: replace forest = forest_mean if missing(forest)
by id (year), sort: replace mining = mining_mean if missing(mining)
by id (year), sort: replace fed = fed_mean if missing(fed)
by id (year), sort: replace military = military_mean if missing(military)
by id (year), sort: replace slgov = slgov_mean if missing(slgov)

***	If oil and gas or mining is still missing, impute zero industry earnings for county/year
replace og = 0 if missing(og)
replace minsup=0 if missing(minsup)

***	Define total oil and gas earnings as oil and gas extraction sector + 
***	mining support services. Not all mining support is for oil and natural gas 
***	extraction, but growth in this sector's earnings during boom attributable 
***	to shale boom oil and natural gas industry activity.
gen og_tot = og + minsup

*** Generate industry sector share of total county earnings variables.
gen cons_pct_earn= (cons/totearn)*100
gen manf_pct_earn= (manf/totearn)*100
gen retail_pct_earn= (retail/totearn)*100
gen farm_pct_earn= (farm/totearn)*100

*** Add GEOID without quotes for matching as non-string
gen GEOID = regexs(0) if(regexm(geofips, "[0-9][0-9][0-9][0-9][0-9]"))
order GEOID

*** Drop unneeded variables
drop geofips region tablename linecode industryclassification description unit og_mean_pre og_mean_post minsup_mean_pre minsup_mean_post cons_mean manf_mean retail_mean farm_mean forest_mean mining_mean fed_mean military_mean slgov_mean

cd "`GROUPS'"
save CAINC5N_all_with_mining_support.dta, replace

clear

