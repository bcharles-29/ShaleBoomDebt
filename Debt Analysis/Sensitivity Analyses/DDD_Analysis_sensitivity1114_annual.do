*Created August 26, 2024
*Version 17
*
*
* Clear memory before beginning analysis
clear
* Housekeeping -  close any open log 
capture log close
set more off

local DEBT "../Main Analysis"
local SENSITIVITY "../Sensitivity Analyses"
local TABLES "Tables/"

log using Data_Analysis_1114, replace

cd "`DEBT'"
*Use annual per capita debt data set
use annual_debt_percapita.dta

cd "`SENSITIVITY'"
*Create ID
egen id = group(GEOID)
tsset id year

*** Create variables for each year/variable combination needed
*** pcdebt is inflation-adjusted debt normalized by 2003 population
gen pcdebt_2004 = pcdebt if year==2004
by id (year), sort: replace pcdebt_2004 = pcdebt_2004[_n-1] if missing(pcdebt_2004)
gen pcdebt_2007 = pcdebt if year==2007
by id (year), sort: replace pcdebt_2007 = pcdebt_2007[_n-1] if missing(pcdebt_2007)
gen pcdebt_2008 = pcdebt if year==2008
by id (year), sort: replace pcdebt_2008 = pcdebt_2008[_n-1] if missing(pcdebt_2008)
gen pcdebt_2011 = pcdebt if year==2011
by id (year), sort: replace pcdebt_2011 = pcdebt_2011[_n-1] if missing(pcdebt_2011)
gen pcdebt_2012 = pcdebt if year==2012
by id (year), sort: replace pcdebt_2012 = pcdebt_2012[_n-1] if missing(pcdebt_2012)
gen pcdebt_2014 = pcdebt if year==2014
by id (year), sort: replace pcdebt_2014 = pcdebt_2014[_n+1] if missing(pcdebt_2014)


*** Create pre-boom population growth variables
gen pop_2001 = pop if year==2001
by id (year), sort: replace pop_2001 = pop_2001[_n-1] if missing(pop_2001)
gen pop_2007 = pop if year==2007
by id (year), sort: replace pop_2007 = pop_2007[_n-1] if missing(pop_2007)

*** Keep only last year of data used - transforming into cross sectional data
keep if year==2014

*** Keep only needed variables
keep GEOID year geoname county state energy_community shale_community boom_growth all_shale_growth shale_geo all_comparison pop_2003 pcearn_2003 emp_2003 conspct_2003 manfpct_2003 retailpct_2003 farmpct_2003 military_2003 fed_2003 slgov_2003 pcdebt_2004 pcdebt_2007 pcdebt_2008 pcdebt_2011 pcdebt_2012 pcdebt_2014 pop_2001 pop_2007


label variable pcdebt_2004 "Normalized Real Debt Stock, 2004"
label variable pcdebt_2007 "Normalized Real Debt Stock, 2007"
label variable pcdebt_2008 "Normalized Real Debt Stock, 2008"
label variable pcdebt_2011 "Normalized Real Debt Stock, 2011"
label variable pcdebt_2012 "Normalized Real Debt Stock, 2012"
label variable pcdebt_2014 "Normalized Real Debt Stock, 2014"
label variable pop_2001 "county population, 2001"
label variable pop_2007 "county population, 2007"

*** Drop large urban population communities where energy_comunity equals 0
drop if energy_community==0

*** Generate debt differences - annualize debt differences to facilitate comparison across time periods with different lengths
gen d_debt_0407_yr = (pcdebt_2007-pcdebt_2004)/3
gen d_debt_1114_yr = (pcdebt_2014-pcdebt_2011)/3
gen dd_debt = d_debt_1114_yr - d_debt_0407_yr

*** Generate pre-boom population growth
gen pop_growth = pop_2007 - pop_2001
gen pop_growth_pct = pop_growth/pop_2001

label variable d_debt_0407 "Debt Growth in 2004-07"
label variable d_debt_1114 "Debt Growth in 2011-14"
label variable dd_debt "Debt Growth Difference, 2011-14 & 2004-07"
label var all_shale_growth "Shale Boom"
label var shale_geo "Shale Geography"
label var pcearn_2003 "Earn. Per Cap., 2003"
label var pop_2003 "Population, 2003"
label var emp_2003 "Employment, 2003"
label var farmpct_2003 "Agriculture %, 2003"
label var conspct_2003 "Construction %, 2003"
label var manfpct_2003 "Manufacturing %, 2003"
label var retailpct_2003 "Retail %, 2003"
label var pop_growth_pct "Percentage Population Growth, 2001-07"

cd "`TABLES'"

*** Regression Models

*** OLS models with robust standard errors

preserve
keep if all_comparison==1 | all_shale_growth==1
reg dd_debt all_shale_growth, robust
reg dd_debt all_shale_growth pcearn_2003 pop_growth_pct, robust
reg dd_debt all_shale_growth pcearn_2003 pop_growth_pct pop_2003 emp_2003 farmpct_2003 conspct_2003 manfpct_2003 retailpct_2003, robust
outreg2 using results_1114.doc, label ctitle(OLS)

*** IPW models with robust standard errors

*** Generate predicated treatment group probabilities
logit all_shale_growth pcearn_2003
predict p_shaleg, pr

*** Use inverse of predicated treatment group probabilities to create weights
gen w=.
replace w=1/p_shaleg if all_shale_growth==1
replace w=1/(1-p_shaleg) if all_shale_growth==0
summarize w

*** Run regression models using weights

reg dd_debt all_shale_growth [pweight=w], robust
outreg2 using results_1114.doc, append label ctitle(IPW, No Controls)

reg dd_debt all_shale_growth pcearn_2003 pop_growth_pct [pweight=w], robust
outreg2 using results_1114.doc, append label ctitle(IPW, Earnings)

reg dd_debt all_shale_growth pcearn_2003 pop_growth_pct pop_2003 emp_2003 farmpct_2003 conspct_2003 manfpct_2003 retailpct_2003 [pweight=w], robust
outreg2 using results_1114.doc, append label ctitle(IPW, All Controls)

restore


log close
clear
