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
              hh_children (a household self-report) and the actual child
              roster do NOT match: hh_children sums to 1631 children, but the
              roster holds 1629. One household (key uuid:11cda278-5ad1-4913-
              b0b6-957cdc40f500) reports 2 children in hh_children yet fills
              no child slots. The child table's row count is driven by the
              roster, never by hh_children; the discrepancy is a data-quality
              issue preserved for the HFC stage, not reconciled here.

              hh_children is household-level
              information, so it is dropped before the reshape and lives only
              in household-tidy.dta, not child-tidy.dta.
*******************************************************************************/

	use "${data_raw}/household_water_questionnaire-deid.dta", clear

**------------------------------------------------------------------------------
**# 1 Identify units of observation present									 
**------------------------------------------------------------------------------

	* Two units of observation are mixed in this wide file:
	*   - household level: one row per submission (key)
	*   - child level:     child_age_*, diarrhea_2d_*, diarrhea_7d_* hold up to
	*                       3 children per household row
	* Split them into one tidy table per unit of observation.

**------------------------------------------------------------------------------
**# 2 Household-level information
**------------------------------------------------------------------------------

	preserve

		* Drop the child-level columns; keep one row per household
		drop child_age_* diarrhea_2d_* diarrhea_7d_*

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

	* Expected child rows = filled roster slots (a non-missing child age),
	* NOT the self-reported hh_children -- the two disagree and reconciling
	* them is out of scope (see header Notes).
	egen slot_filled = rownonmiss(child_age_1 child_age_2 child_age_3)
	su   slot_filled, meanonly
	local n_children = r(sum)
	drop slot_filled


**## 3.2 Keep relevant variables
**------------------------------------------------------------------------------

	keep key child_age_* diarrhea_2d_* diarrhea_7d_*


**## 3.3 Change the relationship between rows and columns
**------------------------------------------------------------------------------

	reshape long child_age_ diarrhea_2d_ diarrhea_7d_, i(key) j(child_index)
	rename *_ *

	* reshape emits 3 child slots per household; keep only filled roster
	* slots, identified by a non-missing child age
	drop if missing(child_age)

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
