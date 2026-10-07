/*******************************************************************************
  2142-construct-child.do
--------------------------------------------------------------------------------
  Authors:  DIL Data Team
            David Torres Leon (dtorresleon@uchicago.edu)
            Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:  7 October 2026

  Inputs:   ${data_box}/12-clean/122-child-clean.dta
  Outputs:  ${data_box}/13-construct/132-child-indicators.dta
            ${data_git}/13-construct/132-child-indicators.md  (iesave report)

  Summary:  Aggregates the child roster to the household: number of children
            under 5 listed, and diarrhoea in the past 48 hours and past 7
            days, measured three ways (number of children, share of children,
            any child). One row per household with a roster (ID: key).

  Notes:    - G4 is only asked if G3 = No, so a child with diarrhoea in the
              past 48 hours had it in the past 7 days: diarrhea_week is 1
              when G3 = Yes and G4 is missing, and G4 otherwise.
            - Households without a roster are not in this file. Whether their
              counts are 0 or missing is decided in 2149-construct-combine.do,
              where C6 is available.
            - Diarrhoea measured three ways: decision by L. Andrade,
              7 October 2026.
            - Variable labels and question codes come from
              4-documentation/Household_Water_Questionnaire.md.
*******************************************************************************/

**------------------------------------------------------------------------------
**# 1 Load data
**------------------------------------------------------------------------------

	use "${data_box}/12-clean/122-child-clean.dta", clear

	isid key child_index
	// isid hh_id child_index

*   Expected after the collapse: one row per household in the roster, and
*   every child counted once
	local n_children = _N
	unique key
	local n_households = r(unique)

**------------------------------------------------------------------------------
**# 2 Diarrhea events in the last week
**------------------------------------------------------------------------------

*   G4 (past 7 days) is skipped when G3 (past 48 hours) = Yes

	gen 	diarrhea_week = diarrhea_7d
	replace diarrhea_week = 1 if diarrhea_2d == 1 & missing(diarrhea_7d)

**------------------------------------------------------------------------------
**# 3 Aggregate to the household
**------------------------------------------------------------------------------

	collapse (count) n_children_roster   = child_index    ///
	         (max)   diarrhea_2d_any     = diarrhea_2d    ///
	                 diarrhea_week_any   = diarrhea_week  ///
			 (sum)   diarrhea_2d_total   = diarrhea_2d    ///
	                 diarrhea_week_total = diarrhea_week  ///
			 (mean)  diarrhea_2d_share   = diarrhea_2d    ///
	                 diarrhea_week_share = diarrhea_week  ///
	         (count) diarrhea_2d_count   = diarrhea_2d    ///
	                 diarrhea_week_count = diarrhea_week, ///
	         by(key)

	isid key
	assert _N == `n_households'
	sum n_children_roster
	assert r(sum) == `n_children'
	
	* Check that there there are no missing values to be implicitly handled
	assert 	diarrhea_2d_count > 0 &  diarrhea_week_count > 0
	assert 	diarrhea_week_count == n_children_roster
	assert 	!missing(diarrhea_2d_count) & !missing(diarrhea_week_count)
	drop 	*count

	lab def yesno 1 "Yes" 0 "No", replace
	lab val *any yesno

**------------------------------------------------------------------------------
**# 4 Labels
**------------------------------------------------------------------------------

**## 4.1 Section G: Children

	lab var n_children_roster 	"Children under 5 in the roster"
	lab var diarrhea_2d_total   "Number of children under 5 with diarrhea in the past 2 days"
	lab var diarrhea_week_total "Number of children under 5 with diarrhea in the past 7 days"
	lab var diarrhea_2d_share 	"Share of children under 5 with diarrhea in the past 2 days"
	lab var diarrhea_week_share "Share of children under 5 with diarrhea in the past 7 days"
	lab var diarrhea_2d_any   	"At least one child under 5 with diarrhea in the past 2 days"
	lab var diarrhea_week_any   "At least one child under 5 with diarrhea in the past 7 days"

**------------------------------------------------------------------------------
**# 5 Save
**------------------------------------------------------------------------------

	label data "Child indicators by household: 1 row = 1 submission with a roster. ID: key"

	ds, not(varlabel)
	if "`r(varlist)'" != "" {
		di as error "Variables without a label: `r(varlist)'"
		exit 459
	}
	
	order key n_* *2d* *week*

	local file "13-construct/132-child-indicators"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
		report(path("${data_git}/`file'.md") replace) ///
		replace

***************************************************************** End of do-file
