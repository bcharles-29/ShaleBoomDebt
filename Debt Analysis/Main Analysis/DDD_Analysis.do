*Created August 26, 2024
*Version 17
*
*
* Clear memory before beginning analysis
clear
* Housekeeping -  close any open log 
capture log close
set more off

local CHARTS "Charts/"
local TABLES "Tables/"

log using Data_Analysis, replace

*Use annual per capita debt data set
use annual_debt_percapita.dta

*Create ID
egen id = group(GEOID)
tsset id year

*Create chart showing mean county debt, normalized by 2003 capita, by group for each year available
**Create chart versions with vertical lines showing treatment identification and pre/post-treatment periods
cd "`CHARTS'"

preserve
keep if all_comparison==1 | all_shale_growth==1
collapse (mean) pcdebt, by(all_shale_growth year)
drop if year<2003
gen shale_pcdebt=pcdebt if all_shale_growth==1
gen comparison_pcdebt=pcdebt if all_shale_growth==0


twoway line pcdebt year if all_shale_growth==0, lcolor(eltgreen) || line pcdebt year if all_shale_growth==1, ///
	legend(label(1 "Comparison") label(2 "Shale Boom") pos(6) col(2)) ///
	ytitle("Mean Normalized County Debt, $2017") ///
	ylabel(0(500)6000, labsize(med) format(%9.0fc)) ///
	xtitle("") ///
	xlabel(2003(1)2021, angle(45) labsize(med)) ///
	lcolor(edkblue) ///
	xline(2004, lcolor(red)) xline(2007, lcolor(red)) ///
	xline(2012, lcolor(red)) xline(2015, lcolor(red))	
graph save Figure_4.gph, replace

restore


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
gen pcdebt_2015 = pcdebt if year==2015
by id (year), sort: replace pcdebt_2015 = pcdebt_2015[_n+1] if missing(pcdebt_2015)


*** Create pre-boom population growth variables
gen pop_2001 = pop if year==2001
by id (year), sort: replace pop_2001 = pop_2001[_n-1] if missing(pop_2001)
gen pop_2007 = pop if year==2007
by id (year), sort: replace pop_2007 = pop_2007[_n-1] if missing(pop_2007)

*** Keep only last year of data used - transforming into cross sectional data
keep if year==2015

*** Keep only needed variables
keep GEOID year geoname county state energy_community shale_community boom_growth all_shale_growth shale_geo all_comparison shale_status pop_2003 pcearn_2003 emp_2003 conspct_2003 manfpct_2003 retailpct_2003 farmpct_2003 military_2003 fed_2003 slgov_2003 pcdebt_2004 pcdebt_2007 pcdebt_2008 pcdebt_2011 pcdebt_2012 pcdebt_2015 pop_2001 pop_2007

label variable pcdebt_2004 "Normalized Real Debt Stock, 2004"
label variable pcdebt_2007 "Normalized Real Debt Stock, 2007"
label variable pcdebt_2008 "Normalized Real Debt Stock, 2008"
label variable pcdebt_2011 "Normalized Real Debt Stock, 2011"
label variable pcdebt_2012 "Normalized Real Debt Stock, 2012"
label variable pcdebt_2015 "Normalized Real Debt Stock, 2015"
label variable pop_2001 "county population, 2001"
label variable pop_2007 "county population, 2007"

*** Drop large urban population communities where energy_comunity equals 0 - not used in analysis, but tab before dropping these shows there are about 83
tab energy_community all_shale_growth
tab energy_community shale_status
drop if energy_community==0
tab energy_community all_shale_growth
tab energy_community shale_status

*** Generate debt differences - no need to adjust for number of years because each period is of equal length
gen d_debt_0407 = pcdebt_2007-pcdebt_2004
gen d_debt_1215 = pcdebt_2015-pcdebt_2012
gen dd_debt = d_debt_1215 - d_debt_0407

*** Generate pre-boom population growth
gen pop_growth = pop_2007 - pop_2001
gen pop_growth_pct = pop_growth/pop_2001

label variable d_debt_0407 "Debt Growth in 2004-07"
label variable d_debt_1215 "Debt Growth in 2012-15"
label variable dd_debt "Debt Growth Difference, 2012-15 & 2004-07"
label variable pop_growth "population growth, 2001 through 2007"
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

cd ".."
save regression_data.dta, replace

*** Change in debt growth for shale boom counties by states
preserve
keep if all_shale_growth==1
tab state, summarize(dd_debt)
restore

cd "`TABLES'"

*** Summary statistics by group
preserve
keep if all_comparison==1 | all_shale_growth==1
tabstat pcdebt_2004, by(all_shale_growth) stats(N mean sd range)
tabstat pop_2003 pop_growth_pct pcearn_2003 emp_2003 farmpct_2003 conspct_2003 manfpct_2003 retailpct_2003, by(all_shale_growth) stats(N mean sd range) columns(statistics)
*
table () (all_shale_growth), statistic (mean d_debt_0407 pop_2003 pop_growth_pct pcearn_2003 emp_2003 farmpct_2003 conspct_2003 manfpct_2003 retailpct_2003)
*
table (command) (result), ///
			command(Comparison_Mean = r(mu_1) Comparison_SD = r(sd_1) /// 
				Shale_Boom_Mean = r(mu_2) Shale_Boom_SD = r(sd_2) /// 
				pvalue = r(p): ttest d_debt_0407, by(all_shale_growth)) ///
			command(Comparison_Mean = r(mu_1) Comparison_SD = r(sd_1) /// 
				Shale_Boom_Mean = r(mu_2) Shale_Boom_SD = r(sd_2) ///
				pvalue = r(p): ttest pop_2003, by(all_shale_growth)) ///
			command(Comparison_Mean = r(mu_1) Comparison_SD = r(sd_1) /// 
				Shale_Boom_Mean = r(mu_2) Shale_Boom_SD = r(sd_2) ///
				pvalue = r(p): ttest pop_growth_pct, by(all_shale_growth)) ///
			command(Comparison_Mean = r(mu_1) Comparison_SD = r(sd_1) ///
				Shale_Boom_Mean = r(mu_2) Shale_Boom_SD = r(sd_2) /// 
				pvalue = r(p): ttest pcearn_2003, by(all_shale_growth)) ///
			command(Comparison_Mean = r(mu_1) Comparison_SD = r(sd_1) ///
				Shale_Boom_Mean = r(mu_2) Shale_Boom_SD = r(sd_2) /// 
				pvalue = r(p): ttest emp_2003, by(all_shale_growth)) ///
			command(Comparison_Mean = r(mu_1) Comparison_SD = r(sd_1) ///
				Shale_Boom_Mean = r(mu_2) Shale_Boom_SD = r(sd_2) /// 
				pvalue = r(p): ttest farmpct_2003, by(all_shale_growth)) ///
			command(Comparison_Mean = r(mu_1) Comparison_SD = r(sd_1) ///
				Shale_Boom_Mean = r(mu_2) Shale_Boom_SD = r(sd_2) /// 
				pvalue = r(p): ttest conspct_2003, by(all_shale_growth)) ///
			command(Comparison_Mean = r(mu_1) Comparison_SD = r(sd_1) ///
				Shale_Boom_Mean = r(mu_2) Shale_Boom_SD = r(sd_2) /// 
				pvalue = r(p): ttest manfpct_2003, by(all_shale_growth)) ///
			command(Comparison_Mean = r(mu_1) Comparison_SD = r(sd_1) ///
				Shale_Boom_Mean = r(mu_2) Shale_Boom_SD = r(sd_2) /// 
				pvalue = r(p): ttest retailpct_2003, by(all_shale_growth)) ///
			nformat(%5.3f) style(table-right)
*
collect label list command, all
collect label levels command 1 "Debt Growth, 2004-07"  2 "2003 Population" 3 "Population Growth %, 2001-07" 4 "2003 Per Capita Earnings" 5 "2003 Employment" 6 "2003 Agriculture % Earnings" 7 "2003 Construction % Earnings" 8 "2003 Manufacturing % Earnings" 9 "2003 Retail % Earnings", modify
*
collect label list result, all
collect label levels result Comparison_Mean "Comparison Mean" Comparison_SD "Comparison SD" Shale_Boom_Mean "Shale Boom Mean" Shale_Boom_SD "Shale Boom SD" pvalue "t-test p-value", modify
*
collect style cell result, basestyle nformat(%9.3fc) halign(center) ///
			valign(top) 
collect style cell result[Comparison_Mean Comparison_SD ///
		Shale_Boom_Mean Shale_Boom_SD], nformat(%9.2fc)
*
collect preview
*
collect export dstats.xlsx, replace
*
restore


*** Regression Models

*** OLS models with robust standard errors

preserve
keep if all_comparison==1 | all_shale_growth==1
reg dd_debt all_shale_growth, robust
reg dd_debt all_shale_growth pcearn_2003 pop_growth_pct, robust
reg dd_debt all_shale_growth pcearn_2003 pop_growth_pct pop_2003 emp_2003 farmpct_2003 conspct_2003 manfpct_2003 retailpct_2003, robust
outreg2 using results.doc, label ctitle(OLS)


*** IPW models with robust standard errors

*** Generate predicated treatment group probabilities

logit all_shale_growth pcearn_2003 pop_growth_pct
predict p_shaleg, pr

*** Use inverse of predicated treatment group probabilities to create weights
gen w=.
replace w=1/p_shaleg if all_shale_growth==1
replace w=1/(1-p_shaleg) if all_shale_growth==0
summarize w

*** Run regression models using weights

reg dd_debt all_shale_growth [pweight=w], robust
outreg2 using results.doc, append label ctitle(IPW, No Controls)

reg dd_debt all_shale_growth pcearn_2003 pop_growth_pct [pweight=w], robust
outreg2 using results.doc, append label ctitle(IPW, Earnings & Pop. Growth)

reg dd_debt all_shale_growth pcearn_2003 pop_growth_pct pop_2003 emp_2003 farmpct_2003 conspct_2003 manfpct_2003 retailpct_2003 [pweight=w], robust
outreg2 using results.doc, append label ctitle(IPW, All Controls)
outreg2 using ipw_CI.doc, stat(ci) keep(all_shale_growth) label ctitle(95% Confidence Interval)

*** Sensititivity test: 
*** Run IPW models without observations that main model with all control variables drops

gen data_missing=0
replace data_missing=1 if missing(farmpct_2003) | missing(conspct_2003) | missing(conspct_2003) | missing(manfpct_2003) | missing(retailpct_2003) | missing(emp_2003) | missing(pop_2003)
drop if data_missing==1

reg dd_debt all_shale_growth [pweight=w], robust
outreg2 using results_droppedobs.doc, append label ctitle(IPW, No Controls)

reg dd_debt all_shale_growth pcearn_2003 pop_growth_pct [pweight=w], robust
outreg2 using results_droppedobs.doc, append label ctitle(IPW, Per Capita Earnings and Pop. Growth)

reg dd_debt all_shale_growth pcearn_2003 pop_growth_pct pop_2003 emp_2003 farmpct_2003 conspct_2003 manfpct_2003 retailpct_2003 [pweight=w], robust
outreg2 using results_droppedobs.doc, append label ctitle(IPW, All Controls)

restore

*** Will incremental shale boom debt accumulation matter in future years?
*** Generate predicted values for future debt boom vs. counterfactual comparison

*** Generate fitted values for each scenario - counterfactual is fitted values with shale boom variable set to zero
preserve
keep if all_comparison==1 | all_shale_growth==1

*** Generate predicated treatment group probabilities
logit all_shale_growth pcearn_2003 pop_growth_pct
predict p_shaleg, pr

*** Use inverse of predicated treatment group probabilities to create weights
gen w=.
replace w=1/p_shaleg if all_shale_growth==1
replace w=1/(1-p_shaleg) if all_shale_growth==0
summarize w

*** Create second boom variable to use for generating a 
*** shale boom county-only mean predicted debt values
gen shale_boom=all_shale_growth

*** Run IPW regression and predict y values including shale boom indicator
reg dd_debt all_shale_growth pcearn_2003 pop_growth_pct pop_2003 emp_2003 farmpct_2003 conspct_2003 manfpct_2003 retailpct_2003 [pweight=w]
predict yhat_boom

*** Re-run IPW regression and predict y values when 
*** shale boom indicator always equals zero
replace all_shale_growth=0
reg dd_debt all_shale_growth pcearn_2003 pop_growth_pct pop_2003 emp_2003 farmpct_2003 conspct_2003 manfpct_2003 retailpct_2003 [pweight=w]
predict yhat_counter

*** Calculate and display mean predicted 2012-2015 debt accumulation (y-hat)
*** for shale boom and counterfactual scenarios
by shale_boom, sort: egen boom_mean=mean(yhat_boom)
by shale_boom, sort: egen counter_mean=mean(yhat_counter)
sum boom_mean if shale_boom==1
sum counter_mean if shale_boom==1

restore

*** Sensitivity test: Re-run analysis with shale geography and boom growth + interaction term
*** How much does including non-boom shale geographies and including separate 
*** variables for boom criteria and shale geography status affect results?

*
preserve

*** Drop if population is very small
*** Very small populations will generate misleading normalized debt growth values

drop if pop_2003<100

reg dd_debt all_shale_growth boom_growth shale_community, robust
outreg2 using results_shaleinteraction.doc, label ctitle(OLS)

reg dd_debt all_shale_growth boom_growth shale_community pcearn_2003 pop_growth_pct, robust
outreg2 using results_shaleinteraction.doc, label ctitle(OLS)

reg dd_debt all_shale_growth boom_growth shale_community pcearn_2003 pop_growth_pct pop_2003 emp_2003 farmpct_2003 conspct_2003 manfpct_2003 retailpct_2003, robust
outreg2 using results_shaleinteraction.doc, label ctitle(OLS)

lincom all_shale_growth + shale_community

lincom all_shale_growth + boom_growth + shale_community

restore


log close
clear
