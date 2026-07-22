/*******************************************************************************
  3-tidy.do  ·  Reshape child module into its own table
--------------------------------------------------------------------------------
  Author(s):  DIL Data Team
              David Torres Leon (dtorresleon@uchicago.edu)
              Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:    July 2026

  Inputs:     data/raw/household_water_questionnaire-deid.dta

  Outputs:    data/tidy/household-tidy.dta   (id: key)
              data/tidy/household-tidy.md    (iesave report)
              data/tidy/child-tidy.dta       (id: key child_index)
              data/tidy/child-tidy.md        (iesave report)

  Summary:    The child module arrived WIDE: child_age_1..3, diarrhea_2d_1..3,
              diarrhea_7d_1..3 (one household row holding up to 3 children).
              Tidy rule: 1 table = 1 unit of observation. Children deserve
              their own table, one row per child.

  Notes:      The three checks that make reshaping safe:
                - unique IDs before and after
                - expected observation counts
                - documentation of what each table now is
              One household (key uuid:11cda278-5ad1-4913-b0b6-957cdc40f500)
              lists children in hh_children but has no valid child-level data
              for them; it is excluded only from the expected-count check
              below, not from the data itself. 

              hh_children is household-level
              information, so it is dropped before the reshape and lives only
              in household-tidy.dta, not child-tidy.dta.
*******************************************************************************/

	use "${data_raw}/household_water_questionnaire-deid.dta", clear

**------------------------------------------------------------------------------
**# 1 Identify units of observation present									 
**------------------------------------------------------------------------------


**------------------------------------------------------------------------------
**# 2 Household-level information
**------------------------------------------------------------------------------

	preserve


		iesave "${data_tidy}/household-tidy.dta", ///
			idvars(key) ///
			version(14) ///
			replace userinfo ///
			report(path("${data_tidy}/household-tidy.md") replace)

	restore

**------------------------------------------------------------------------------
**# 3 Child-level information
**------------------------------------------------------------------------------

**## 3.1 Check expected number of obs
**------------------------------------------------------------------------------
	

**## 3.2 Keep relevant variables
**------------------------------------------------------------------------------


**## 3.3 Change the relationship between rows and columns
**------------------------------------------------------------------------------

	reshape long /*[ variables here ]*/, i(key) j(child_index)
	rename *_ *

**## 3.4 Confirm the ID and number of observations
**------------------------------------------------------------------------------

	isid key child_index, sort
	assert _N == `n_children'

**## 3.5 Save data
**------------------------------------------------------------------------------

	iesave "${data_tidy}/child-tidy.dta", ///
		idvars(key child_index) ///
		version(14) ///
		replace userinfo ///
		report(path("${data_tidy}/child-tidy.md") replace)

********************************************************************************
