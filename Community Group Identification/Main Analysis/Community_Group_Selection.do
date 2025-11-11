*Created June 21, 2024
*Version 17
*
*
* Clear memory before beginning analysis
clear
* Housekeeping -  close any open log 
capture log close
set more off

*DIRECTORIES
local DATA ".."
local GROUPS "Main Analysis/"

log using Community_Group_Selection, replace

*Set directory and output directories
cd "`DATA'"

import delimited using EIA_County_shaleplay_ccml_forStata.csv, stringcols(1/6)

gen shale_county=1 if shalecountyyyes=="Y"
drop shalecountyyyes state statecode subdiv countycode countyname
ren remarks shale_detail
ren geoid GEOID
drop if missing(GEOID)
recast str5 GEOID
save EIA_shale_county_list.dta, replace
*
clear

*Use to vary when shale boom starts
local end_pretreat 2007

*Use to vary population cutoff to omit large urban areas
local pop_level 200000

***	Use to vary mininum earnings level cutoff of $10M; currently based on 
***	approximately the 90the percentile of county mean oil and natural 
***	gas extraction (including support services) earnings in 2001-2007
local og_min_earnings 10000

***	High energy community threshold based on pre-boom mean and min O&G 
***	earnings exceeding approximately 70th percentile (capture communities with 
***	clear history of oil and gas production and economic importance, not 
***	recent development only), medium energy community based on 30th percentile
local med_og_earnings_min 18539
local high_og_earnings_min 51650

use CAINC5N_all_with_mining_support.dta

***	Define shale communities based on geography using EIA list of shale counties
merge m:m GEOID using EIA_shale_county_list.dta
replace shale_county=0 if missing(shale_county)
drop _merge

***	Define energy communities based on pre-shale boom earnings and 
***	population size cutoff for large urban areas
keep if year<=`end_pretreat'

collapse (max) shale_community = shale_county ///
		(min) pop_min = pop ///
		(mean) pop_mean = pop ///
		(max) pop_max = pop ///
		(min) og_tot_min = og_tot ///
		(max) og_tot_max = og_tot, by(geoname GEOID)

label variable shale_community "county in shale geography (0/1)"
label variable og_tot_min "min O&G earnings in 2001-2007, thousands of dollars"
label variable og_tot_max "max O&G earnings in 2001-2007, thousands of dollars"
label variable pop_min "min number of persons in 2001-2007"
label variable pop_max "max number of persons in 2001-2007"

* Create indicator variable for counties with oil and gas earnings 
* exceeding minimum threshold
gen energy_production=0
replace energy_production=1 if og_tot_min>`og_min_earnings'

* Find 70th and 30th percentile minimum and mean pre-boom O&G earnings 
* per capita to use as threshold for high energy community minimum earnings
preserve
keep if energy_production==1
pctile pct10 = og_tot_min, nq(10)
list pct10 in 1/10
** 70th percentile minimum is $51,650
** 30th percentile minimum is $18,539
restore

* Define energy community group variable categorizing counties based on 
* 1) having minimum energy production above min. threshold; 2) the level 
* of pre-boom (2001-07) oil and gas earnings; 3) having a population size 
* smaller than the large urban area cutoff.

*** Note: Ultimately, energy_community equals zero only for counties that
*** exceed the large urban area size cutoff.
gen energy_community=0

* Energy community equals 2 for medium energy-producing communities, 
* where pre-boom production exceeds the 30th percentile and population size
* is smaller than the large urban area cutoff.
replace energy_community=2 if energy_production==1 & og_tot_min>=`med_og_earnings_min' & pop_max<=`pop_level'

* Energy community equals 3 for high energy-producing communities, 
* where pre-boom production exceeds the 70th percentile and population size
* is smaller than the large urban area cutoff.
replace energy_community=3 if energy_production==1 & og_tot_min>=`high_og_earnings_min' & pop_max<=`pop_level'

* Energy community equals 1 for communities with low, but not necessarily zero, 
* oil and gas earnings, and population size is smaller than the large 
* urban area cutoff.
replace energy_community=1 if energy_community!=2 & energy_community!=3 & pop_max<=`pop_level'

keep GEOID geoname shale_community energy_community

cd "`GROUPS'"

save Community_Groups_1.dta, replace
clear

* Set directory, locals, and output directories

* Use to vary when shale boom starts (so years used to construct energy community and comparison groups)
local end_pretreat 2007
local end_early_boom 2011

cd "`DATA'"

use CAINC5N_all_with_mining_support.dta

*** Define 2008-2011 boom growth as 10% or more growth in total oil and gas 
*** earnings (oil and gas extraction plus mining support NAICS codes)

*** Limit to counties with mininmum total earnings to avoid large growth on very small base counties
*** Limit to counties below population threhold to avoid large urban areas

by GEOID, sort: egen pop_2003=mean(pop) if year==2003
by GEOID (year), sort: replace pop_2003 = pop_2003[_n-1] if !missing(pop_2003[_n-1])

keep if year>=`end_pretreat' & year<=`end_early_boom'
by GEOID, sort: egen ogtot_2008=mean(og_tot) if year==2008
by GEOID, sort: egen ogtot_2011=mean(og_tot) if year==2011
by GEOID (year), sort: replace ogtot_2008 = ogtot_2008[_n-1] if !missing(ogtot_2008[_n-1])

keep if year==2011
gen ogtot_change=ogtot_2011-ogtot_2008
gen ogtot_pct_change=ogtot_change/ogtot_2008

gen boom_growth = 0
replace boom_growth = 1 if ogtot_pct_change>=0.1 & pop_2003<=`pop_level'
replace boom_growth = 0 if ogtot_2011<`og_min_earnings'

* Keep only needed variables
keep GEOID geoname boom_growth

cd "`GROUPS'"

save Community_Groups_2.dta, replace

clear


log close
