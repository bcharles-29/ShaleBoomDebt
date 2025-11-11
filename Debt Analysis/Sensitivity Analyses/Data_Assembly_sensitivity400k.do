*Created Jul 17, 2024
*Version 17
*
*
* Clear memory before beginning analysis
clear
* Housekeeping -  close any open log 
capture log close
set more off
*

local DEBT "../Main Analysis"
local GROUPS "../../Community Group Identification/Sensitivity Analyses"
local DEBT_INFILL "../Debt Analysis/Main Analysis"
local SENSITIVITY "../Sensitivity Analyses"
local DATA "../../Community Group Identification"
local SENSITIVITY2 "../Debt Analysis/Sensitivity Analyses"

log using Data_Assembly_sensitivity400k, replace

cd "`DEBT'"

*** Use Mergent data processed to provide annual incremental debt and 
*** outstanding debt stock by county/year.
use annual-m6.dta

*** Fill in years with no issuance/maturity data (meaning there is no 
*** observation for that year/county), carry forward cumulative issuances.
*** from previous years where year added. First need to create 
*** non-string id for tsset.
egen id = group(GEOID)
tsset id year
tsfill
bysort id: carryforward GEOID debt, replace
replace amount=0 if missing(amount)

save annual-m6-infill.dta, replace

*** Change directory to merge energy/comparison community group data 
*** based on BEA data analysis.
cd "`GROUPS'"

use Community_Groups_1_pop400k.dta

merge m:m GEOID using Community_Groups_2_pop400k.dta
drop _merge

*** Create treatment status variables
gen all_comparison=0
replace all_comparison=1 if shale_community==0 & energy_community!=0
gen shale_geo=0
replace shale_geo=1 if shale_community==1 & boom_growth==0 & energy_community!=0
gen all_shale_growth=0
replace all_shale_growth=1 if shale_community==1 & boom_growth==1 & energy_community!=0

*** Change directory to merge in BEA economic and industry variables.
cd ".."

merge m:m GEOID using control_variables_all.dta

*** Note on merge: all records merge cleanly, "Not Matched"=0
*** Confirm all observations have a GEOID, county, and state
drop if geoname=="" & GEOID==""
split geoname, p(", ")
ren geoname1 county
ren geoname2 state
drop if county=="" & state==""

*** Drop counties/county-equivalents in Alaska and Hawaii.
drop if state=="AK" | state=="AK*" | state=="HI" | state=="HI*"

*** Clean up unwanted variables.
order year, before(energy_community)
sort GEOID year
drop _merge

*** Change directory to merge in Mergent data.
cd "`DEBT_INFILL'"

merge m:m GEOID year using annual-m6-infill.dta

*** Notes on merge: Missing matches from "master" file (BEA data, i.e. 
*** _merge==1) are those for which debt data is missing (i.e., no debt issued, 
*** do not appear in Mergent data). Missing matches from "using" file (Mergent 
*** data, i.e. _merge==2) are those for which the year of data appears in the 
*** Mergent data but not the BEA data (i.e., the year is not in the range 
*** 2001-2021).

*** Note: dropping all observations with empty name fields as below drops all 
*** unmatched observations that appear in the debt data only (i.e., _merge==2)
drop if geoname=="" & county=="" & state=="" & geoname3==""

*** Drop VA counties where county and cities are combined (drops 105 obs.).
drop if geoname3!=""

*** Fill debt and debt change (i.e., "amount") with zero if 
*** missing - indicates initial values in debt data file did not exist,
replace amount=0 if missing(amount)
replace debt=0 if missing(debt)

*** Drop unwanted variables.
drop _merge
drop id

*** Destring employment data
destring(emp), replace force

*** Drop counties with definitions modified over time.
drop if ustrpos(state, "*")

cd "`SENSITIVITY'"

save annual_debt_percapita_sensitivity400k.dta, replace

*** Change directory to merge in inflation data.
cd "`DATA'"

merge m:1 year using pce_inflation.dta
drop if _merge==1 | _merge==2
drop _merge
sort GEOID year

*** Adjust debt for inflation using PCE (base 2017)
gen real_debt = debt * cum_pce

*** Create debt per capita (2003 population) variable.
gen pcdebt=debt/pop_2003

*** Clean up and label variables.
order GEOID year geoname county state geoname3
order energy_community shale_community boom_growth all_shale_growth shale_geo all_comparison, before(pop)
label variable energy_community "O&G earnings level 2001-2007 (0 indicates urban area)"
label variable shale_community "located in shale play"
label variable boom_growth "meets boom criteria"
label variable all_shale_growth "meets shale and boom criteria"
label variable og_tot "O&G earnings including mining support"
label variable cons_pct_earn "construction share county earnings"
label variable manf_pct_earn "manufacturing share county earnings"
label variable retail_pct_earn "retail share county earnings"
label variable farm_pct_earn "farm share county earnings"
label variable amount "annual change in outstanding debt"
label variable debt "current stock of outstanding debt"
label variable real_debt "outstanding debt, $2017"
label variable pcdebt "outstanding debt, $2017 per capita (2003 population)"
drop geoname3

cd "`SENSITIVITY2'"

save annual_debt_percapita_sensitivity400k.dta, replace

clear

log close
