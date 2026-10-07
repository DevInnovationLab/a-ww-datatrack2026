/*******************************************************************************
  2141-construct-household.do
--------------------------------------------------------------------------------
  Authors:  DIL Data Team
            David Torres Leon (dtorresleon@uchicago.edu)
            Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:  7 October 2026

  Inputs:   ${data_box}/12-clean/121-household-clean.dta
  Outputs:  ${data_box}/13-construct/131-household-indicators.dta
            ${data_git}/13-construct/131-household-indicators.md  (iesave report)

  Summary:  Builds the household-level indicators: hours since the stored
            water was collected, in 12-hour groups, and whether chlorine was
            added on at least one of the past 7 days. Keeps every clean
            household variable next to them. One row per consenting
            submission (ID: key).

  Notes:    - Decisions made with L. Andrade on 7 October 2026:
              * D6 is grouped into 12-hour categories, so the 99 code
                ("more than 72 hours") keeps its meaning.
              * "Treated with chlorine" = chlorine on at least one day in the
                past 7 (E1 > 0). D7 (chlorine added to the stored water) is
                kept as well. E1 and E2 stay separate: a day with both
                chlorine and boiling would be counted twice if added.
              * Respondent's age and sex (C1, C2) stand in for the person
                responsible for water: the questionnaire doesn't ask who
                that is. Their labels say so.
            - Duplicated hh_id and out-of-range answers are kept as they are,
              for the HFC session. Their counts are asserted, so a new case
              stops the code.
            - Variable labels and question codes come from
              4-documentation/Household_Water_Questionnaire.md.
*******************************************************************************/

**------------------------------------------------------------------------------
**# 1 Load data
**------------------------------------------------------------------------------

	use "${data_box}/12-clean/121-household-clean.dta", clear

	isid key
	//isid hh_id

*   Expected: one row per clean household submission, kept through the end
	local n_households = _N

**------------------------------------------------------------------------------
**# 2 Indicators
**------------------------------------------------------------------------------

**## 2.1 Hours since the stored water was collected, in 12-hour groups

*   D6 is hours (0-72) or 99 = "more than 72 hours". Two answers above 72
*   that aren't 99 (out of the form's range) are also more than 72 hours.
*   Extended missing values (.d, .r) are carried over.

	gen 	storage_time_cat = .
	replace storage_time_cat = 1 if inrange(storage_time,  0, 12)
	replace storage_time_cat = 2 if storage_time > 12 & storage_time <= 24
	replace storage_time_cat = 3 if storage_time > 24 & storage_time <= 36
	replace storage_time_cat = 4 if storage_time > 36 & storage_time <= 48
	replace storage_time_cat = 5 if storage_time > 48 & storage_time <= 72
	replace storage_time_cat = 6 if storage_time > 72 & !missing(storage_time)
	replace storage_time_cat = storage_time if storage_time > .

	lab def storage_cat 1 "0-12 hours"  ///
						2 "12-24 hours" ///
						3 "24-36 hours" ///
	                    4 "36-48 hours" ///
						5 "48-72 hours" ///
	                    6 "More than 72 hours" ///
	                    .d "Don't know" ///
						.r "Declined to answer"
	lab val storage_time_cat storage_cat

**## 2.2 Chlorine in the past 7 days
	
	gen 	treat_chlorine_any 	= treat_chlorine > 0 if !missing(treat_chlorine)
	gen 	treat_boil_any 		= treat_boil 	 > 0 if !missing(treat_boil)

	lab val *_any 	 yesno

**------------------------------------------------------------------------------
**# 3 Labels
**------------------------------------------------------------------------------

	lab var storage_time_cat 	"Time since water was collected"
	lab var treat_chlorine_any 	"Treated water with chlorine on at least 1 of the past 7 days"
	lab var treat_boil_any 		"Boiled drinking water on at least 1 of the past 7 days"
	
	isid key
	assert _N == `n_households'

	ds, not(varlabel)
	if "`r(varlist)'" != "" {
		di as error "Variables without a label: `r(varlist)'"
		exit 459
	}

**------------------------------------------------------------------------------
**# 4 Save
**------------------------------------------------------------------------------

	order storage_time_cat,   after(storage_time)
	order treat_chlorine_any, after(treat_chlorine)
	order treat_boil_any	, after(treat_boil)

	local file "13-construct/131-household-indicators"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
		report(path("${data_git}/`file'.md") replace) ///
		replace

***************************************************************** End of do-file
