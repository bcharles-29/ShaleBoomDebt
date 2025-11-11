*Created October 22, 2024
*Version 17

*** Clear memory before beginning analysis
clear

*** Housekeeping -  close any open log 
capture log close
set more off

log using debt_composition.log, replace

local CHARTS "/Charts"

*** Use only shale boom and comparison counties, match county geographic 
*** information with individual bond issuances

use annual_debt_percapita.dta
keep if year==2003
drop if shale_geo==1
drop if all_shale_growth==0 & all_comparison==0 & shale_geo==0

collapse (mean) pop (max) all_shale_growth, by(GEOID geoname county state)
save county_debt.dta, replace

merge 1:m GEOID using m6-trim.dta
drop if _merge==2
drop _merge

gen maturity_years = maturity_year-start_year

*** Identify total amount of debt by county group types

gen comparison_offering=0
replace comparison_offering=offering_amount if all_shale_growth==0
gen boom_offering=0
replace boom_offering=offering_amount if all_shale_growth==1

gen group="Comparison" if all_shale_growth==0
replace group="Shale Boom" if all_shale_growth==1

*** Specify debt issuances to analyze - issued during shale boom period with
*** maturities that plausibly align with future oil and gas production declines

cd "`CHARTS'"

preserve
keep if start_year>=2012 & start_year<=2015
keep if maturity_years>15

*** Drop pollution control bonds - typically very large but issued by small 
*** number of governments and providing a misleading picture of the most 
*** common/typical debt uses

drop if use_of_proceeds==40

*** Analyze debt proceed uses
*** First, identify top 5 types for combined debt of groups and create variables to identify each and an "All Other" category

treemap offering_amount, by(use_of_proceeds)
graph save treemap_use.gph, replace

replace use_of_proceeds=1000 if use_of_proceeds!=41 & use_of_proceeds!=12 & use_of_proceeds!=59 & use_of_proceeds!=14 & use_of_proceeds!=16
label define use_of_proceeds 1000 "All Other", add

gen educ_offering=0
replace educ_offering=1 if use_of_proceeds==41
gen general_offering=0
replace general_offering=1 if use_of_proceeds==12
gen highered_offering=0
replace highered_offering=1 if use_of_proceeds==14
gen watersew_offering=0
replace watersew_offering=1 if use_of_proceeds==59
gen hospitals_offering=0
replace hospitals_offering=1 if use_of_proceeds==16
gen allother_offering=0
replace allother_offering=1 if use_of_proceeds==1000
*
gen educ_amt=offering_amount*educ_offering
gen gen_amt=offering_amount*general_offering
gen highered_amt=offering_amount*general_offering
gen watersew_amt=offering_amount*watersew_offering
gen hospitals_amt=offering_amount*hospitals_offering
gen allother_amt=offering_amount*allother_offering

*** Create chart of debt by use of proceeds by group

graph hbar (sum) educ_amt gen_amt highered_amt watersew_amt hospitals_amt allother_amt, ///
	over(group) ///
	legend(label(1 "Pri./Sec. Ed.") label(2 "Gen. Purpose") label(3 "Higher Ed.") label(4 "Water/Sewer") label(5 "Hospitals") ///
	label(6 "All Other") pos(6) col(3))  ///
	ytitle("Percent of Total Group Issuance Amount") ///
	bar(1, color(ebblue))  ///
	bar(2, color(edkblue))  ///
	bar(3, color(emidblue)) ///
	bar(4, color(eltblue))	///
	bar(5, color(eltgreen))	///
	bar(6, color(erose))	///
	blabel(bar, position(center) format(%9.0f) size(vsmall))		///
	percentage stack
graph export Figure_5.pdf, replace

*** Analyze security types used
*** First, identify top 5 types for combined debt of groups and create variables to identify each and an "All Other" category

treemap offering_amount, by(security_code)
graph save treemap_security.gph, replace

replace security_code=1000 if security_code!=18 & security_code!=9 & security_code!=5 & security_code!=4 & security_code!=3
label define security_code 1000 "All Other", add

gen unlimGO_offering=0
replace unlimGO_offering=1 if security_code==18
gen rev_offering=0
replace rev_offering=1 if security_code==9
gen loan_offering=0
replace loan_offering=1 if security_code==5
gen limGO_offering=0
replace limGO_offering=1 if security_code==4
gen	lease_offering=0
replace lease_offering=1 if security_code==3
gen other_offering=0
replace other_offering=1 if security_code==1000

gen unlimGO_amt=offering_amount*unlimGO_offering
gen rev_amt=offering_amount*rev_offering
gen loan_amt=offering_amount*loan_offering
gen limGO_amt=offering_amount*limGO_offering
gen lease_amt=offering_amount*lease_offering
gen other_amt=offering_amount*lease_offering

*** Create chart of debt by security codes by group

graph hbar (sum) unlimGO_amt rev_amt loan_amt limGO_amt lease_amt other_amt, ///
	over(group) ///
	legend(label(1 "Unlimted G.O.") label(2 "Revenue") label(3 "Loan Agreement") label(4 "Limited G.O.") label(5 "Lease/Rental") ///
	label(6 "All Other") pos(6) col(3))  ///
	ytitle("Percent of Total Group Issuance Amount") ///
	bar(1, color(ebblue))  ///
	bar(2, color(edkblue))  ///
	bar(3, color(emidblue)) ///
	bar(4, color(eltblue))	///
	bar(5, color(eltgreen))	///
	bar(6, color(erose))	///
	blabel(bar, position(center) format(%9.0f) size(vsmall))	///
	percentage stack
graph save debtbygroup_security.gph, replace

	
restore

log close
clear
