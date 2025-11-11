*Created June 25, 2024
*Version 17

* Clear memory before beginning analysis
clear

* Housekeeping -  close any open log 
capture log close
set more off

use CAINC30_all_clean.dta

*Use to vary years for beginning and end of analysis
local first_year 2001
local last_year 2021

*Drop years outside of period of analysis
drop if year<`first_year' | year>`last_year'

*** O&G data includes BOTH NAICS codes 211 (O&G extraction) and 213 (Mining Support)
*** 213 includes O&G field services, including drilling and other activities provided
*** by Halliburton, Schlumberger, etc. to develop extraction sites...lots of economic
*** impact (change in jobs, earnings) comes from this sector rather than 211 so use data including both categories.

merge m:m GEOID year using CAINC5N_all_with_mining_support.dta

*** Not matched from Master (i.e., _merge=1) are counties with no data except 
*** (NA) under emp. Not matched from Using (i.e., _merge=2) are county records
*** for years not being used and dropped from BEA economic data (CAINC30) file. 
*** Can drop all not matched observations as below.

drop if _merge==1 | _merge==2
drop _merge

*** Assess missing values from BEA data
gen cons_missing=0
replace cons_missing=1 if missing(cons)
gen manf_missing=0
replace manf_missing=1 if missing(manf)
gen retail_missing=0
replace retail_missing=1 if missing(retail)
gen farm_missing=0
replace farm_missing=1 if missing(farm)
tab cons_missing
tab manf_missing
tab retail_missing
tab farm_missing
pwcorr pop pcearn cons_missing manf_missing retail_missing farm_missing

*** Drop major industry missing data indicators
drop cons_missing manf_missing retail_missing farm_missing

*** Use to vary years for pre-analysis sector shares of earnings - 
*** pre-analysis period is all years prior to "end_sector_share" defined below
local begin_sector_share 2002
local end_sector_share 2004

*** Use to vary population cutoff to omit certain city sizes
local pop_level 200000
local extract_min_earnings 20000
by GEOID, sort: egen pop_max = max(pop) if year<`end_sector_share'

*** Generate variables for pre-analysis industry importance

*** First - indicators pre-analysis reliance on mining (including coal) or oil 
*** and natural gas; Use same criteria as for energy communities except omit 
*** for 10th percentile measure due to limited number of observations

*** Pre-Analysis Period Variables for Controls/Matching
by GEOID, sort: egen totearn_2003 = mean(totearn) if year<`end_sector_share' & year>`begin_sector_share'
by GEOID, sort: egen pop_2003 = mean(pop) if year<`end_sector_share' & year>`begin_sector_share'
by GEOID, sort: egen pcearn_2003 = mean(pcearn) if year<`end_sector_share' & year>`begin_sector_share'
by GEOID, sort: egen emp_2003 = mean(emp) if year<`end_sector_share' & year>`begin_sector_share'
by GEOID, sort: egen cons_2003 = mean(cons) if year<`end_sector_share' & year>`begin_sector_share'
by GEOID, sort: egen manf_2003 = mean(manf) if year<`end_sector_share' & year>`begin_sector_share'
by GEOID, sort: egen retail_2003 = mean(retail) if year<`end_sector_share' & year>`begin_sector_share'
by GEOID, sort: egen farm_2003 = mean(farm) if year<`end_sector_share' & year>`begin_sector_share'
by GEOID, sort: egen military_2003 = mean(military) if year<`end_sector_share' & year>`begin_sector_share'
by GEOID, sort: egen fed_2003 = mean(fed) if year<`end_sector_share' & year>`begin_sector_share'
by GEOID, sort: egen slgov_2003 = mean(slgov) if year<`end_sector_share' & year>`begin_sector_share'

*** Fill Pre-Analysis avearge values forward over time as constants
by GEOID (year), sort: replace totearn_2003 = totearn_2003[_n-1] if !missing(totearn_2003[_n-1])
by GEOID (year), sort: replace pop_2003 = pop_2003[_n-1] if !missing(pop_2003[_n-1])
by GEOID (year), sort: replace pcearn_2003 = pcearn_2003[_n-1] if !missing(pcearn_2003[_n-1])
by GEOID (year), sort: replace emp_2003 = emp_2003[_n-1] if !missing(emp_2003[_n-1])
by GEOID (year), sort: replace cons_2003 = cons_2003[_n-1] if !missing(cons_2003[_n-1])
by GEOID (year), sort: replace manf_2003 = manf_2003[_n-1] if !missing(manf_2003[_n-1])
by GEOID (year), sort: replace retail_2003 = retail_2003[_n-1] if !missing(retail_2003[_n-1])
by GEOID (year), sort: replace farm_2003 = farm_2003[_n-1] if !missing(farm_2003[_n-1])
by GEOID (year), sort: replace military_2003 = military_2003[_n-1] if !missing(military_2003[_n-1])
by GEOID (year), sort: replace fed_2003 = fed_2003[_n-1] if !missing(fed_2003[_n-1])
by GEOID (year), sort: replace slgov_2003 = slgov_2003[_n-1] if !missing(slgov_2003[_n-1])

gen conspct_2003 = cons_2003 / totearn_2003
gen manfpct_2003 = manf_2003 / totearn_2003
gen retailpct_2003 = retail_2003 / totearn_2003
gen farmpct_2003 = farm_2003 / totearn_2003

*** Label Pre-Analysis variables
label variable totearn_2003 "total earnings, 2003"
label variable pop_2003 "population, 2003"
label variable pcearn_2003 "per capita earnings, 2003"
label variable emp_2003 "employment, 2003"
label variable cons_2003 "construction earnings, 2003"
label variable manf_2003 "manufacturing earnings, 2003"
label variable retail_2003 "retail earnings, 2003"
label variable farm_2003 "farm earnings, 2003"
label variable military_2003 "military earnings, 2003"
label variable fed_2003 "federal government earnings, 2003"
label variable slgov_2003 "state and local government earnings, 2003"
label variable conspct_2003 "construction percentage share of total earnings, 2003"
label variable manfpct_2003  "manufacturing percentage share of total earnings, 2003"
label variable retailpct_2003 "retail percentage share of total earnings, 2003"
label variable farmpct_2003 "agriculture percentage share of total earnings, 2003"

save control_variables_all.dta, replace

clear

