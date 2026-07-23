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

	ds child_* diarrhea_* // This is why we use prefixes for variables in the same module
	local child_vars = r(varlist)

**------------------------------------------------------------------------------
**# 2 Household-level information
**------------------------------------------------------------------------------

	preserve

		drop `child_vars'

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
	preserve

		* This household lists two children in the household, but there is
		* no valid information for them
		drop if key == "uuid:11cda278-5ad1-4913-b0b6-957cdc40f500"

		collapse (sum) hh_children
		sum hh_children

		local n_children = r(mean)

	restore

**## 3.2 Keep relevant variables
**------------------------------------------------------------------------------

	keep key `child_vars'

**## 3.3 Change the relationship between rows and columns
**------------------------------------------------------------------------------

	reshape long child_age_ diarrhea_2d_ diarrhea_7d_, i(key) j(child_index)
	rename *_ *

**## 3.4 Confirm the ID and number of observations
**------------------------------------------------------------------------------

	egen valid_child = rownonmiss(child_age-diarrhea_7d), strok
	replace valid_child = valid_child > 0
	keep if valid_child
	drop valid_child

	/* This is how I found the household with no valid child data
	preserve

		collapse (sum) valid_child, by(key hh_children)

		br if valid_child != hh_children

	restore
	*/

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
