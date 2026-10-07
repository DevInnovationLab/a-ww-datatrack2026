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
              past 48 hours had it in the past 7 days: diarrhea_7d_all fills
              G4 from G3 for those children. "Don't know" (.d) and
              "Declined" (.r) are not filled.
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

**------------------------------------------------------------------------------
**# 2 Diarrhea events in the last week
**------------------------------------------------------------------------------

	gen diarrhea_week = diarrhea_7d | diarrhea_2d

**------------------------------------------------------------------------------
**# 2 Aggregate to the household
**------------------------------------------------------------------------------

	collapse (count) n_children_roster   = child_index    ///
	         (sum)   diarrhea_2d_total   = diarrhea_2d    ///
	                 diarrhea_week_total = diarrhea_week  ///
	         (count) diarrhea_2d_count   = diarrhea_2d    ///
	                 diarrhea_week_count = diarrhea_week, ///
	         by(key)

	isid key
	
	* Check that there there are no missing values to be implicitly handled
	assert 	diarrhea_2d_count > 0 &  diarrhea_week_count > 0
	assert 	diarrhea_week_count == n_children_roster
	assert 	!missing(diarrhea_2d_count) & !missing(diarrhea_week_count)
	drop 	*count

**## 2.1 Diarrhoea indicators

	foreach period in 2d week {
		gen	diarrhea_`period'_any 	= diarrhea_`period'_total > 0
		gen	diarrhea_`period'_share = diarrhea_`period'_total / n_children_roster
	}

	lab def yesno 1 "Yes" 0 "No", replace
	lab val *any yesno

**------------------------------------------------------------------------------
**# 3 Labels
**------------------------------------------------------------------------------

**## 3.1 Section G: Children

	lab var n_children_roster 	"Children under 5 in the roster"
	lab var diarrhea_2d_total   "Number of children under 5 with diarrhea in the last 2 last"
	lab var diarrhea_week_total "Number of children under 5 with diarrhea in the last 7 days"
	lab var diarrhea_2d_share 	"Share of children under 5 with diarrhea in the last 2 last"
	lab var diarrhea_week_share "Share of children under 5 with diarrhea in the last 7 days"
	lab var diarrhea_2d_any   	"At least one child under 5 with diarrhea in the last 2 last"
	lab var diarrhea_week_any   "At least one child under 5 with diarrhea in the last 7 days"

**------------------------------------------------------------------------------
**# 4 Save
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
