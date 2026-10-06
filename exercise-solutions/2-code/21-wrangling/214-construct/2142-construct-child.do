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
**# 1 Children: one row per child
**------------------------------------------------------------------------------

	use "${data_box}/12-clean/122-child-clean.dta", clear

	isid key child_index
	assert _N == 1585

**## 1.1 Diarrhoea in the past 7 days, including the G4 skip

*   G4 is blank by design when G3 = Yes. Only the skipped cases (.) are
*   filled; "don't know" (.d) and "declined" (.r) stay as they are.

	count if diarrhea_2d == 1 & diarrhea_7d == .
	assert r(N) == 165

	gen diarrhea_7d_all = diarrhea_7d
	replace diarrhea_7d_all = 1 if diarrhea_2d == 1 & diarrhea_7d == .
	assert !missing(diarrhea_7d_all) if !missing(diarrhea_2d)

**------------------------------------------------------------------------------
**# 2 Aggregate to the household
**------------------------------------------------------------------------------

	gen child = 1

	collapse (count) n_children_roster = child           ///
	         (sum)   n_diarrhea_2d     = diarrhea_2d     ///
	                 n_diarrhea_7d     = diarrhea_7d_all ///
	         (count) n_answered_2d     = diarrhea_2d     ///
	                 n_answered_7d     = diarrhea_7d_all, ///
	         by(key)

	isid key
	assert _N == 938

**## 2.1 Diarrhoea indicators

*   collapse (sum) returns 0 when no child has an answer: make that missing.
*   Shares and any-child indicators need at least one answer.

	foreach d in 2d 7d {
		replace n_diarrhea_`d' = . if n_answered_`d' == 0

		gen share_diarrhea_`d' = n_diarrhea_`d' / n_answered_`d' ///
			if n_answered_`d' > 0 & !missing(n_answered_`d')
		gen any_diarrhea_`d'   = n_diarrhea_`d' > 0 ///
			if n_answered_`d' > 0 & !missing(n_answered_`d')

		assert inrange(share_diarrhea_`d', 0, 1) if !missing(share_diarrhea_`d')
		assert n_diarrhea_`d' <= n_children_roster if !missing(n_diarrhea_`d')
	}

	lab def yesno 1 "Yes" 0 "No", replace
	lab val any_diarrhea_2d any_diarrhea_7d yesno

**------------------------------------------------------------------------------
**# 3 Labels
**------------------------------------------------------------------------------

**## 3.1 Section G: Children

	lab var key               "SurveyCTO submission ID (unique row ID)"
	lab var n_children_roster "G. Children under 5 in the roster"
	lab var n_answered_2d     "G3. Children <5 with a G3 answer"
	lab var n_answered_7d     "G3-G4. Children <5 with a 7-day answer"
	lab var n_diarrhea_2d     "G3. Children <5 with diarrhoea, past 48 hours"
	lab var n_diarrhea_7d     "G3-G4. Children <5 with diarrhoea, past 7 days"
	lab var share_diarrhea_2d "G3. Share of children <5 with diarrhoea, past 48 hours"
	lab var share_diarrhea_7d "G3-G4. Share of children <5 with diarrhoea, past 7 days"
	lab var any_diarrhea_2d   "G3. Any child <5 with diarrhoea, past 48 hours"
	lab var any_diarrhea_7d   "G3-G4. Any child <5 with diarrhoea, past 7 days"

**------------------------------------------------------------------------------
**# 4 Save
**------------------------------------------------------------------------------

	label data "Child indicators by household: 1 row = 1 submission with a roster. ID: key"

	ds, not(varlabel)
	if "`r(varlist)'" != "" {
		di as error "Variables without a label: `r(varlist)'"
		exit 459
	}

	local file "13-construct/132-child-indicators"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
		report(path("${data_git}/`file'.md") replace) ///
		replace
