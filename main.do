/*******************************************************************************
	
						  Development Innovation Lab
						    Template main do-file
						  
FOR THIS TEMPLATE TO WORK CORRECTLY, EDIT THE FILE PATHS IN SECTION 2 TO MATCH YOUR COMPUTER
						  
--------------------------------------------------------------------------------
	1 Select parts of the code to run
------------------------------------------------------------------------------*/
	
	local import		0
	local deidentify	0
	local clean			0
	local tidy			0
	local construct		0
	local analyze		0
	
/*------------------------------------------------------------------------------
	2 Set file paths
------------------------------------------------------------------------------*/

	* Enter the file path to the project folder in Box for every new machine you use
	* Type 'di c(username)' to see the name of your machine
	if c(username) == "luizaandrade" {
		global box 		"C:/Users/luizaandrade/Box/project-folder"
		global github	"C:/Users/luizaandrade/GitHub/dil-template-repo"
	}
	else if c(username) == "username" {
		global box 		"C:/Users/username/Box/project-folder"
		global github	"C:/Users/username/GitHub/dil-template-repo"
	}
	
	global	code		"${github}/code"
	global	data_box	"${box}/data"
	global  data_git	"${github}/data"
	global	doc_box		"${box}/documentation"
	global	doc_git		"${github}/documentation"
	global	output		"${github}/output"
	
/*------------------------------------------------------------------------------
	3 Initial settings
------------------------------------------------------------------------------*/

	* Find user-written commands in GitHub
	sysdir set  PLUS "${code}/ado"
	
    adopath ++  PLUS
    adopath ++  BASE
	
	* Set initial configurations as much as allowed by Stata version
	ieboilstart, v(16.0)
	`r(version)'
	
/*------------------------------------------------------------------------------
	4 Run code
------------------------------------------------------------------------------*/

	if `import' do "${code}/1-import.do"

**## 4.2 Deidentify
/*------------------------------------------------------------------------------
		Splits off direct identifiers into a PII crosswalk

  Inputs:   data/raw/household_water_questionnaire.dta
  Outputs:  data/raw/household_water_questionnaire-crosswalk-PII.dta
            data/raw/household_water_questionnaire-deid.dta
------------------------------------------------------------------------------*/

	if `deidentify' do "${code}/2-deidentify.do"							  // <------------ YOUR TURN

**## 4.3 Tidy
/*-------------------------------------------------------------------------------
		 Separates units of observations into tidy data sets
		 
  Inputs:   data/raw/household_water_questionnaire-deid.dta
  Outputs:  data/tidy/household-tidy.dta
            data/tidy/child-tidy.dta
------------------------------------------------------------------------------*/

	if `tidy' do "${code}/3-tidy.do"										  // <------------ YOUR TURN

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
		do "${code}/4-clean-household.do"									  // <------------ YOUR TURN

**## 4.5.2 Child-level data
/*------------------------------------------------------------------------------
  Inputs:   data/tidy/child-tidy.dta
  Outputs:  data/clean/child-clean.dta
            documentation/data-dictionaries/child-clean.xlsx
------------------------------------------------------------------------------*/
		do "${code}/5-clean-child.do"
  }

************************************************************ End of main do-file
