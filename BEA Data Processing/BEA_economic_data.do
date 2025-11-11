*Created June 21, 2024

* Clear memory before beginning analysis
clear
* Housekeeping -  close any open log 
capture log close
set more off


*** DIRECTORIES
*cd "/Users/brandoncharles/data_files/Shale-Muni-Debt-Replication/BEA Data Processing"

local BEA_DATA "BEA Data Files/"
local BEA_STATA "../BEA DTA Files/"
local GROUPS "../../Community Group Identification/"

*** Set directory and output directories
cd "`BEA_DATA'"

*** Population Data

import delimited "CAINC30__ALL_AREAS_1969_2022.csv"

drop v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 v28 v29
keep if description==" Population (persons) 3/"

ren v30 pop1990
ren v31 pop1991
ren v32 pop1992
ren v33 pop1993
ren v34	pop1994
ren v35 pop1995
ren v36 pop1996
ren v37	pop1997
ren v38 pop1998
ren v39 pop1999
ren v40 pop2000
ren v41 pop2001
ren v42 pop2002
ren v43 pop2003
ren v44 pop2004
ren v45 pop2005
ren v46 pop2006
ren v47	pop2007
ren v48 pop2008
ren v49 pop2009
ren v50 pop2010
ren v51 pop2011
ren v52 pop2012
ren v53 pop2013
ren v54 pop2014
ren v55	pop2015
ren v56 pop2016
ren v57 pop2017
ren v58	pop2018
ren v59 pop2019
ren v60 pop2020
ren v61 pop2021
ren v62 pop2022

cd "`BEA_STATA'"
save CAINC30__ALL_AREAS_POP.dta, replace
clear

*** Per Capita Earnings Data
cd "../`BEA_DATA'"
import delimited "CAINC30__ALL_AREAS_1969_2022.csv"

drop v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 v28 v29
keep if description==" Per capita net earnings 4/"

ren v30 pcearn1990
ren v31 pcearn1991
ren v32 pcearn1992
ren v33 pcearn1993
ren v34	pcearn1994
ren v35 pcearn1995
ren v36 pcearn1996
ren v37	pcearn1997
ren v38 pcearn1998
ren v39 pcearn1999
ren v40 pcearn2000
ren v41 pcearn2001
ren v42 pcearn2002
ren v43 pcearn2003
ren v44 pcearn2004
ren v45 pcearn2005
ren v46 pcearn2006
ren v47	pcearn2007
ren v48 pcearn2008
ren v49 pcearn2009
ren v50 pcearn2010
ren v51 pcearn2011
ren v52 pcearn2012
ren v53 pcearn2013
ren v54 pcearn2014
ren v55	pcearn2015
ren v56 pcearn2016
ren v57 pcearn2017
ren v58	pcearn2018
ren v59 pcearn2019
ren v60 pcearn2020
ren v61 pcearn2021
ren v62 pcearn2022

cd "`BEA_STATA'"
save CAINC30__ALL_AREAS_PERCAPEARN.dta, replace
clear

*** Employment Data
cd "../`BEA_DATA'"
import delimited "CAINC30__ALL_AREAS_1969_2022.csv"

drop v9 v10 v11 v12 v13 v14 v15 v16 v17 v18 v19 v20 v21 v22 v23 v24 v25 v26 v27 v28 v29
keep if description=="Total employment (number of jobs) "

ren v30 emp1990
ren v31 emp1991
ren v32 emp1992
ren v33 emp1993
ren v34	emp1994
ren v35 emp1995
ren v36 emp1996
ren v37	emp1997
ren v38 emp1998
ren v39 emp1999
ren v40 emp2000
ren v41 emp2001
ren v42 emp2002
ren v43 emp2003
ren v44 emp2004
ren v45 emp2005
ren v46 emp2006
ren v47	emp2007
ren v48 emp2008
ren v49 emp2009
ren v50 emp2010
ren v51 emp2011
ren v52 emp2012
ren v53 emp2013
ren v54 emp2014
ren v55	emp2015
ren v56 emp2016
ren v57 emp2017
ren v58	emp2018
ren v59 emp2019
ren v60 emp2020
ren v61 emp2021
ren v62 emp2022

cd "`BEA_STATA'"
save CAINC30__ALL_AREAS_EMP.dta, replace
clear

*** Merge files with data for each variable
use CAINC30__ALL_AREAS_POP.dta
merge 1:1 geoname using CAINC30__ALL_AREAS_PERCAPEARN.dta
drop _merge
merge 1:1 geoname using CAINC30__ALL_AREAS_EMP.dta
drop _merge

save CAINC30_all.dta, replace
clear

use CAINC30_all.dta

*** Reshape data to long format
reshape long pop pcearn emp, i(geoname) j(year)

*** Drop state and national aggregate data
keep if ustrpos(geoname, ", ")

*** Label variables for clarity
label variable pop "total population"
label variable pcearn "per capita net earnings"
label variable emp "total employment, number of jobs"

*** Note 1: D indicates potential confidentiality issue with data
*** Note 2:	NA indicates data not available
*** See BEA data footnotes for details
*** Replace "D" and "NA" with blank space to facilitate destringing data

replace pop=" " if pop=="(D)"
replace pop=" " if pop=="(NA)"
replace pcearn=" " if pcearn=="(D)"
replace pcearn=" " if pcearn=="(NA)"
replace emp=" " if emp=="(D)"
replace emp=" " if emp=="(NA)"

destring pop pcearn emp, replace

***Add GEOID without quotes for matching as non-string
gen GEOID = regexs(0) if(regexm(geofips, "[0-9][0-9][0-9][0-9][0-9]"))
order GEOID

*** Remove extraneous variables
drop geofips region tablename linecode industryclassification description unit

cd "`GROUPS'"
save CAINC30_all_clean.dta, replace

clear
