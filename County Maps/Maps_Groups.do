*Created February 21, 2025
*Version 17

* Clear memory before beginning analysis
clear
* Housekeeping -  close any open log 
capture log close
set more off

local STATES "cb_2024_us_state_500k/"
local COUNTIES "../cb_2024_us_county_500k/"
local DEBT "../../Debt Analysis/Main Analysis/"
local COUNTIES2 "../../County Maps/cb_2024_us_county_500k/"

*** Set initial directory
cd "`STATES'"
spshape2dta cb_2024_us_state_500k, replace saving(states)

cd "`COUNTIES'"
spshape2dta cb_2024_us_county_500k, replace saving(counties)

cd "../`STATES'"
use states.dta

*** Drop counties in Alaska, Hawaii, Puerto Rico, Virgin Islands, Guam, and other island territories
drop if STATEFP=="02" | STATEFP=="15" | STATEFP=="72" | STATEFP=="78" | STATEFP=="60" | STATEFP=="66" | STATEFP=="69"

save lower48, replace
merge 1:m _ID using states_shp.dta 
keep if _m == 3
sort _ID shape_order
keep if _m == 3
drop _m rec_header

cd "`COUNTIES'"
save lower48_shp,replace
clear

use counties.dta

cd "`DEBT'"

merge 1:1 GEOID using regression_data.dta

*** Drop counties in Alaska, Hawaii, Puerto Rico, Virgin Islands, Guam, and other island territories
drop if STATEFP=="02" | STATEFP=="15" | STATEFP=="72" | STATEFP=="78" | STATEFP=="60" | STATEFP=="66" | STATEFP=="69"

gen shale=0 if shale_community==0
replace shale=1 if shale_community==1 & all_shale_growth==0
replace shale=2 if all_shale_growth==1

*** Create Figure 3
cd "`COUNTIES2'"

spmap shale using counties_shp, id(_ID) fcolor(BuYlRd) ///
	clmethod(unique) ///
	clnum(4) ///
	ndlabel("Dropped") ///
	legend(size(large) ///
	label(2 "Comparison" ) ///
	label(3 "Shale Geography") ///
	label(4 "Shale Boom")) ///
	polygon(data(lower48_shp) ocolor(black) osize(.5))
graph export Figure_3.pdf, replace	

clear



