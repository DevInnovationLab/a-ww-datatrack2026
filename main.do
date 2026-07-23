/*******************************************************************************
         Data Ingestion, Cleaning & Tidying - DIL Welcome Week Session
                               MASTER.do
********************************************************************************

  Authors:   DIL Data Team
             David Torres Leon (dtorresleon@uchicago.edu)
			 Luiza Andrade (luizaandrade@uchicago.edu)

  Updated:   July 2026
  Version:   Stata 15

  Summary:   MOCK, TEACHING version of an ingestion/tidying/cleaning pipeline.
             It starts from a deliberately messy raw export of the Chlorine
             Testing survey (the same instrument from the measurement session)
             and ends with tidy, labeled, de-identified datasets that are
             ready for tomorrow's High-Frequency Checks session.

             THE ONE RULE: these do-files change the SHAPE and FORMAT of the
             data, never its CONTENT. You will meet duplicates, outliers, and
             contradictions along the way. LEAVE THEM IN. Finding and acting
             on them is tomorrow's job.

  Outline:   I.  Initial setup

             II. Run do-files
                1. Import the raw export
                2. De-identify
                3. Tidy: reshape the child module
                4. Clean: harmonize, encode, label (household + child)

*******************************************************************************/

**------------------------------------------------------------------------------
**# 1 Select parts of the code to run
**------------------------------------------------------------------------------
	
	local import		1
	local deidentify	1
	local tidy			1
	local clean			1
	
**------------------------------------------------------------------------------
**# 2 Set file paths
**------------------------------------------------------------------------------

* Main GitHub folder -----------------------------------------------------------

	* Enter the file path to the github folder every new machine you use
	* Type 'di c(username)' to see the name of your machine
	
	// Luiza
	if "`c(username)'" == "luizaandrade" {
		global github "/Users/luizaandrade/Documents/GitHub"
	}

	// YOU
	else if "`c(username)'" == "" {
		global github ""
	}

* Subfolders -------------------------------------------------------------------

	global repo		  "${github}/a-ww-datatrack2026"
	global code       "${repo}/code"
	global data_raw   "${repo}/data/raw"
	global data_tidy  "${repo}/data/tidy"
	global data_clean "${repo}/data/clean"
	global output     "${repo}/output"
	global doc 		  "${repo}/documentation"

**------------------------------------------------------------------------------
**# 3 Initial settings
**------------------------------------------------------------------------------

	* Find user-written commands in GitHub
	sysdir set  PLUS "${code}/ado"
	
    adopath ++  PLUS
    adopath ++  BASE
	
	* Set initial configurations as much as allowed by Stata version
	ieboilstart, v(16.0)
	`r(version)'

**------------------------------------------------------------------------------
**# 4 Run code
**------------------------------------------------------------------------------

**## 4.1 Import
/*------------------------------------------------------------------------------
	Imports the raw csv export into a working .dta.

  Inputs:   data/raw/household_water_questionnaire__v1.csv
  Outputs:  data/raw/household_water_questionnaire.dta
------------------------------------------------------------------------------*/

	if `import' do "${code}/1-import.do"

**## 4.2 Deidentify
/*------------------------------------------------------------------------------
		Splits off direct identifiers into a PII crosswalk

  Inputs:   data/raw/household_water_questionnaire.dta
  Outputs:  data/raw/household_water_questionnaire-crosswalk-PII.dta
            data/raw/household_water_questionnaire-deid.dta
------------------------------------------------------------------------------*/

	if `deidentify' do "${code}/2-deidentify.do"

**## 4.3 Tidy
/*-------------------------------------------------------------------------------
		 Separates units of observations into tidy data sets
		 
  Inputs:   data/raw/household_water_questionnaire-deid.dta
  Outputs:  data/tidy/household-tidy.dta
            data/tidy/child-tidy.dta
------------------------------------------------------------------------------*/

	if `tidy' do "${code}/3-tidy.do"

**## 4.5 Cleaning
*-------------------------------------------------------------------------------
*  		 Adjust data format to use in Stata

  if `clean' {

 **## 4.5.1 Household-level data
/*------------------------------------------------------------------------------
  Inputs:   data/tidy/household-tidy.dta
  Outputs:  data/clean/household-clean.dta
            documentation/data-dictionaries/household-clean.xlsx
------------------------------------------------------------------------------*/
		do "${code}/4-clean-household.do"

**## 4.5.2 Child-level data
/*------------------------------------------------------------------------------
  Inputs:   data/tidy/child-tidy.dta
  Outputs:  data/clean/child-clean.dta
            documentation/data-dictionaries/child-clean.xlsx
------------------------------------------------------------------------------*/
		
		do "${code}/5-clean-child.do"

	}

********************************************************************************
