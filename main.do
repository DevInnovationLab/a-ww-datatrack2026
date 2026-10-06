/*******************************************************************************
						DIL Welcome Week India 2026
                           Data track main script
********************************************************************************

  Authors:   DIL Data Team
             David Torres Leon (dtorresleon@uchicago.edu)
			 Luiza Andrade (luizaandrade@uchicago.edu)

  Updated:   October 2026
  Version:   Stata 15

*******************************************************************************/
**#  I. Initial setup
********************************************************************************

**## Users ---------------------------------------------------------------------

	if "`c(username)'" == "luizaandrade" {
		global github 	"/Users/luizaandrade/Documents/GitHub/a-wwdatatrack2026"
		global box		"/Users/luizaandrade/Library/CloudStorage/Box-Box/a-wwdatatrack2026"
	}

**## Subfolders -------------------------------------------------------------

	global code 			"${github}/2-code"
	global data_box			"${box}/1-data"
	global data_git			"${github}/1-data"
	global output 			"${github}/3-output/32-overleaf/321-exhibits"
	
**## Stata session ----------------------------------------------------------
	 ieboilstart , versionnumber(15.1) adopath("${code}/20-programs/ado", strict) noclear
    `r(version)'
	
********************************************************************************
**#  II. Run do-files
********************************************************************************

* Switch each step on or off with if (1) / if (0)

/*------------------------------------------------------------------------------
  00-import.do                                          [COMPLETE - read it]
--------------------------------------------------------------------------------
  Imports the csv as text, declares the type of every variable, converts the
  SurveyCTO date-times, splits the GPS column, and shows why hh_id cannot be
  the row ID (SurveyCTO's key can).
------------------------------------------------------------------------------*/

	if (1) do "${code}/21-wrangling/210-import.do"

/*------------------------------------------------------------------------------
  01-deidentify.do                                                [YOUR TURN]
--------------------------------------------------------------------------------
  Saves the crosswalk (key + identifiers) to 00_pii, then drops the
  identifiers: children's names, the device phone number and the GPS point.
------------------------------------------------------------------------------*/

	if (1) do "${code}/21-wrangling/211-deidentify.do"

/*------------------------------------------------------------------------------
  02-tidy-reshape.do                                              [YOUR TURN]
--------------------------------------------------------------------------------
  The children roster (Section G) arrived wide: child_age_1..3,
  diarrhea_2d_1..3, diarrhea_7d_1..3. Reshape it into its own table, one row
  per child, and check IDs and counts before and after.
------------------------------------------------------------------------------*/

	if (1) do "${code}/21-wrangling/212-tidy-reshape.do"

/*------------------------------------------------------------------------------
  03-clean-label.do                                               [YOUR TURN]
--------------------------------------------------------------------------------
  Turns the special codes (-999 Don't know, -888 Declined) into labeled
  extended missing values, attaches value labels from the form's choices,
  and adds variable labels from the questionnaire.
------------------------------------------------------------------------------*/

	if (1) do "${code}/21-wrangling/213-clean-label.do"

/*------------------------------------------------------------------------------
  04-codebook-verify.do                                 [COMPLETE - run it]
--------------------------------------------------------------------------------
  Exports a codebook to excel and runs the HFC-readiness check. If every
  check passes, it says so: your tables are tomorrow's input.
------------------------------------------------------------------------------*/

	if (1) do "${code}/04-codebook-verify.do"
