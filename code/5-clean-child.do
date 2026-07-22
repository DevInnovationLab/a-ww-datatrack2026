/*******************************************************************************
  5-clean-child.do  ·  Label child-level data
--------------------------------------------------------------------------------
  Author(s):  DIL Data Team
              David Torres Leon (dtorresleon@uchicago.edu)
              Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:    July 2026

  Inputs:     data/tidy/child-tidy.dta

  Outputs:    data/clean/child-clean.dta    (id: key child_index)
              data/clean/child-clean.md     (iesave report)
              documentation/data-dictionaries/child-clean.xlsx
                                             (iecodebook mini-codebook)

  Summary:    Right shape is not right format. Labels the child-level module
              (age, diarrhea in the past 2/7 days) so the file explains
              itself. Remember the one rule: representation changes, values
              don't.

  Notes:      Variable labels use the question wording and question codes
              (e.g. G2) from the SurveyCTO form in documentation/Household
              Water Questionnaire - V1.xlsx.
*******************************************************************************/

	use "${data_tidy}/child-tidy.dta", clear

**------------------------------------------------------------------------------
**# 1 Confirm the ID
**------------------------------------------------------------------------------

	isid key child_index

**------------------------------------------------------------------------------
**# 2 Explore data
**------------------------------------------------------------------------------

	codebook

**------------------------------------------------------------------------------
**# 3 Label categories (extracted from survey form)
**------------------------------------------------------------------------------

	local 	 dummy_vars 	diarrhea_2d diarrhea_7d
	lab def 				yesno 	1 "Yes" ///
									0 "No"
	lab val `dummy_vars'	yesno

**------------------------------------------------------------------------------
**# 4 Label variables
**------------------------------------------------------------------------------

	lab var key         "Unique submission ID"
	lab var child_index "Child index (within submission)"
	lab var child_age   "(G2) Child's age, in months"
	lab var diarrhea_2d "(G3) Child had diarrhea in the past 2 days"
	lab var diarrhea_7d "(G4) Child had diarrhea in the past 7 days"

**------------------------------------------------------------------------------
**# 5 Save and export codebook
**------------------------------------------------------------------------------

	iesave "${data_clean}/child-clean.dta", ///
		idvars(key child_index) ///
		version(14) ///
		replace userinfo ///
		report(path("${data_clean}/child-clean.md") replace)

	iecodebook export using "${doc}/data-dictionaries/child-clean.xlsx", replace

********************************************************************************
