# ShaleBoomDebt
Shale Boom Municipal Debt Replication Files

# 1. Introduction
The analysis is structured as a sequence of script files processing raw data, generating variables and identifying groups of communities for analysis, merging data files into a single file for analysis, and finally analyzing the data. The scripts save intermediate data files and final outputs in separate folders for organization purposes. 

For this reason, each script includes local macros identifying directories used by the script. These appear near the beginning of each Stata .do file labeled “DIRECTORIES” and are structured such that they should not require modification by the user. The scripts in sections 2 through 4 must be run in order.

Due to the structure of the data used in the final analyses, multiple versions of the main .do files exist for purposes of running the different scenarios used. These files, the folders they are contained in, their use, and their outputs are detailed in the step-by-step instructions below for clarity.

# 2. Data Processing – U.S. Bureau of Economic Analysis Files
The first folder is labeled “BEA Data Processing” and contains the Stata .do files “BEA_economic_data.do” and “BEA_industry_data.do,” respectively. These process raw BEA data for county economic characteristics and earnings by industry, saved as .csv files in the “BEA Data Files” folder. The scripts save .dta files in the “BEA DTA Files”

These two .do files can be run in any order and must be run prior to any other scripts for this analysis.

# 3. Community Group Identification
The next set of files perform initial assembly of data files and create the variables used for identifying the community group membership of each county for the analysis of debt. This folder also includes original and .dta versions of additional data sources for the analysis. This includes the U.S. Energy Information Administration’s (EIA’s) list of counties by shale play and U.S. Personal Consumption Expenditures (PCE) Chain-Type Price Index from the U.S. BEA downloaded from the Federal Reserve Economic Data (FRED).

## a. Control Variables
The first file to run is “Control Variables.do.” This assembles the BEA data files produced from the BEA data processing scripts. It also generates specific variables for later analyses from this data. 

The second file to run appears in the “Main Analysis” or “Sensitivity Analyses” folders, depending on which scenario is being run. For the primary analysis and all other analyses except for those listed below, use the file  
“Community_Group_Selection.do,” which merges the BEA industry earnings data and EIA shale play status data and generates variables used in later scripts to identify county community group membership and in the final analyses.

## b. Sensitivity Analyses
The ”Sensitivity Analyses” folder contains version of the “Community_Group_Selection.do” file for a subset of the sensitivity scenarios analyzed. The specific file names and corresponding sensitivity cases are listed below:

### i. $5M Minimum Oil and Gas Earnings
“Community_Group_Selection_min earnings sensitivity5M.do” – Run the analysis using a minimum oil and natural gas earnings level of $5 million, rather than $10 million, to qualify for the Shale Boom group of counties.

### ii. $30M Minimum Oil and Gas Earnings
“Community_Group_Selection_min earnings sensitivity30M.do” – Run the analysis using a minimum oil and natural gas earnings level of $30 million, rather than $10 million, to qualify for the Shale Boom group of counties.

### iii. 400k Maximum Population
“Community_Group_Selection_pop400k.do” – Run the analysis using a maximum county population for inclusion in the sample of 400,000, rather than 200,000.

# 4. Debt Analysis
This folder contains scripts to perform the final assembly of data files for the debt analysis and to perform the data analysis and produce the results reported in the paper. It also contains the annual outstanding debt by county data file that is the core of the analysis. In addition to assembling data, this file also creates the community group variables used in the analyses (i.e., Shale Boom, Comparison, Shale Geography) and filters the data sample based on the criteria described in the paper using the base assumptions. These files are grouped by those related to the main analyses and those primarily related to sensitivity analyses. The specific files and the analyses and outputs they produce are described in detail below.

## a. Main Analysis Folder
i. “Data_Assembly.do” assembles the primary data files that use the base assumptions for the analysis and produces a data sample and community groups using those assumptions. It requires the scripts from the prior steps be run first and uses the “Community_Group_Selection.do” version of the file for producing community group variables. This file saves a log file titled “Data_Assembly.smcl.”

ii.	“DDD_Analysis.do” performs the core data analysis. The file generates descriptive data visuals and tables, restructures the data to allow for the model design described in the paper, and performs the regression analysis. This file saves a log file tilted “Data_Analysis.smcl.” The key elements and associated results in this file are each described below:

1.  The file first generates the chart presented as Figure 4 of the main paper using descriptive data and saves the file with a corresponding name in the “Charts” folder.

2.  The file then restructures the data and creates key variables to facilitate the regression analysis. After doing so, it generates a table of summary statistics and exports this table as an Excel file named “dstats.xlsx” to the “Tables” folder.

3.  The file next preserves the data and runs the main regressions discussed in the paper, including both the OLS and IPW model versions, compiling the results in the “results.doc” file (included in Table 3 of the main document) and the 95 percent confidence interval for the IPW model in “ipw_CI.doc” (Table 4 of the main document). This and other regression files from this script are saved to the “Tables” folder.

4.  The file next runs the sensitivity case presented in section I and Table 1 of Appendix B, because this sensitivity case runs on the same data as the main analysis. This analysis drops observations to test the model’s sensitivity to their omission. The script compiles these results in the file “results_droppedobs.doc.”

5.  The file next performs the counterfactual comparison analysis described in Appendix C, with the results viewable in the log file for the analysis.

iii. The files “DDD_Analysis_1518.do” and “DDD_Analysis_1821.do” perform regression analyses that are substantially the same as the primary regression analysis in “DDD_Analysis.do,” but with the post-treatment period shifted back to the years 2015 through 2018 and 2018 through 2021. These files produce the results presented in Table 5 of the main document. The script compiles the results from the 2015-2018 analysis in “results_1518yr.doc” and the results from the 2018-2021 analysis in “results_1821yr.doc” in the “Tables” folder.

iv.	The file “DDD_Analysis_1215_annual.do” performs regression analyses identical to the primary models described in Section 4.ii. above, except that it annualizes the growth in outstanding debt rather than the growth reflecting the full three-year period. This means that the resulting Shale Boom coefficients provide estimates of the annual incremental accumulation of debt due to the shale boom. These results are used for comparison with the alternate post-treatment period definitions, the length of which vary, discussed in section II of Appendix B. The script compiles the results, presented in Table 2 of Appendix B, in “results_1215yr.doc” in the “Tables” folder.

v.	The file “Debt_Characteristics.do” analyzes the characteristics of individual municipal bond issuances from 2012 through 2015 with a maturity date greater than 15 years in the future as discussed in section V.B. and illustrated in Figure 5 of the main paper. It relies on the raw individual bond issuance data. Because licensing agreements prevent providing the individual bond issuance data file directly, the script can only be run by users who have access to the Mergent database.  This script performs the following steps contributing to the discussion in section V.B. and to Figure 5 of the paper:

1.	Analyzes the debt issuance data pooled and by group (Shale Boom and Comparison) by generating treemaps illustrating the 5 largest specific uses of debt proceeds, creating an “All Other” category for uses other than the top 5. The treemaps are saved as “treemap_use.gph,” “treemap_use_comp.gph,” and “treemap_use_boom.gph,” respectively, the “Charts” folder.

2.	Creates a bar chart illustrating the percentage share of the total debt issued by counties in each group for each of the top 5 use of proceeds categories and the “All Other” category. This chart is saved as “Figure_5.pdf” in the “Charts” folder.

3.	Creates a bar chart illustrating the percentage share of the total debt issued by counties in each group for each of the top 5 security type categories and the “All Other” category, which informs the discussion of debt security types in section V.B. of the main paper. This chart is saved as “debtbygroup_security.gph” in the “Charts” folder.

## b. Sensitivity Analyses Folder

i.	The scripts in this folder support the analyses discussed in sections II and III of Appendix B.

ii.	This folder includes one additional data file, a list of counties that have at any point issued one or more pollution control bonds (PCBs), “pcb_list.dta.” This data file was produced from the raw bond issuance data by keeping only those bond issuances with the PCB code in the Use of Proceeds field, and then collapsing that set of issuances to the county level to produce a list of counties with PCB bond issuances. The data file with the PCB counties is included in this folder for replication purposes rather than the bond issuance data and a script for producing the PCB file because licensing agreements prevent providing the individual bond issuance data file directly.

iii.	Scenario-specific data assembly files perform the same data assembly as with the primary data, but using different assumptions from the base scenario. The files then produce data samples and community groups using those assumptions. It requires the scripts from the prior steps be run first and uses the appropriate scenario-specific versions of “Community_Group_Selection.do” be run first to produce community group variables. These analyses are discussed in section III of Appendix B. The specific data assembly files are as follows:

1. “Data_Assembly_sensitivity5M.do” corresponds to the case using a $5 million minimum oil and gas earnings threshold for a county to be included in the Shale Boom group.  This file saves a log file titled “Data_Assembly_sensitivity5M.smcl.”

2. “Data_Assembly_sensitivity30M.do” corresponds to the case using a $30 million minimum oil and gas earnings threshold for a county to be included in the Shale Boom group.  This file saves a log file titled “Data_Assembly_sensitivity30M.smcl.”

3. “Data_Assembly_sensitivity400k.do” corresponds to the case using a 400,000-person population threshold for a county to be included in the data sample for the analysis.  This file saves a log file titled “Data_Assembly_sensitivity400k.smcl.”

4. “Data_Assembly_sensitivityNoPCB.do” corresponds to the case dropping counties that have issued Pollution Control Bonds (PCBs) from the data sample for the analysis. This file saves a log file titled “Data_Assembly_sensitivityNoPCB.smcl.”

iv.	Case-specific data analysis files for testing alternative key assumptions perform the same data analysis as with the primary data (e.g., in the DDD_Analysis.do file), but using different assumptions from the base scenario. The files then produce analytical results using those assumptions. It requires the scripts from the prior steps be run first and uses the appropriate scenario-specific versions of “Community_Group_Selection.do” and “Data_Assembly.do” be run first to produce community group variables and assemble the data for analysis. These analyses are discussed in section III of Appendix B. The specific data analysis files are as follows:

1. “DDD_Analysis_sensitivity5M.do” corresponds to the case using a $5 million minimum oil and gas earnings threshold for a county to be included in the Shale Boom group. This file saves a log file titled “Data_Analysis_sensitivity5M.smcl.”  This file compiles results in a file titled “results_sensitivity5M.doc,” which are presented in Table 3 of Appendix B.

2. “DDD_Analysis_sensitivity30M.do” corresponds to the case using a $30 million minimum oil and gas earnings threshold for a county to be included in the Shale Boom group. This file saves a log file titled “Data_Analysis_sensitivity30M.smcl.” This file compiles results in a file titled “results_sensitivity30M.doc,” which are presented in Table 3 of Appendix B.

3. “DDD_Analysis_sensitivity400k.do” corresponds to the case using a 400,000-person population threshold for a county to be included in the data sample for the analysis. This file saves a log file titled “Data_Analysis_sensitivity400k.smcl.” This file compiles results in a file titled “results_sensitivity400k.doc,” which are presented in Table 3 of Appendix B.

4. “DDD_Analysis_sensitivityNoPCB.do” corresponds to the case dropping counties that have issued Pollution Control Bonds (PCBs) from the data sample for the analysis. This file saves a log file titled “Data_Analysis_sensitivityNoPCB.smcl.” This file compiles results in a file titled “results_sensitivityNoPCB.doc,” which are presented in Table 3 of Appendix B.

v.	Case-specific data analysis files for testing alternative treatment period definitions perform the same data analysis as with the primary data (e.g., in the DDD_Analysis.do file), but using slightly different definitions for the post-treatment period compared with the base scenario. The files then produce analytical results using those assumptions. These scripts use the base assumption versions of “Community_Group_Selection.do” and “Data_Assembly.do” and do not require that scenario-specific community group selection and data assembly scripts be run prior to the relevant data analysis script. These analyses are discussed in section II of Appendix B. The specific data analysis files are as follows:

1. “DDD_Analysis_sensitivity1114_annual.do” corresponds to the case using a 2011 through 2014 post-treatment period definition for the analysis. This file saves a log file titled “Data_Analysis_1114.smcl.” This file compiles results in a file titled “results_1114.doc,” which are presented in Table 2 of Appendix B.

2. “DDD_Analysis_sensitivity1216_annual.do” corresponds to the case using a 2012 through 2016 post-treatment period definition for the analysis. This file saves a log file titled “Data_Analysis_1216.smcl.” This file compiles results in a file titled “results_1216.doc,” which are presented in Table 2 of Appendix B.

3. “DDD_Analysis_sensitivity1316_annual.do” corresponds to the case using a 2013 through 2016 post-treatment period definition for the analysis. This file saves a log file titled “Data_Analysis_1316.smcl.” This file compiles results in a file titled “results_1316.doc,” which are presented in Table 2 of Appendix B.

# 5. County Maps
This folder contains the data and Stata script for producing the map of U.S. counties by community group presented as Figure 3 of the main paper. The analysis uses U.S. Census Bureau cartographic boundary shape files which, as the script notes, have been converted to Stata data files. The script merges the U.S. state and county shape files with a data file produced by the main data analysis file (“DDD_Analysis.do”) that includes the community group variables used for the regression analysis.

Thus, this script must be run after the “DDD_Analysis.do,” and all other scripts from the main analysis, have been run. The script saves the chart as “Figure_3.pdf” in the county data subfolder (“cb_2024_us_state_500k”) within the “County Maps” folder.