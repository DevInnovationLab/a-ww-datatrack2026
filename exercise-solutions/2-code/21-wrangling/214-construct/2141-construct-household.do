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
**# 1 Households: one row per submission
**------------------------------------------------------------------------------

	use "${data_box}/12-clean/121-household-clean.dta", clear

	isid key
	assert _N == 1254
	assert consent == 1

*   hh_id is not unique: 6 values have two submissions each. Both are kept
*   (key is the ID); which one counts is for the HFC session.

	duplicates tag hh_id, gen(dup_hh_id)
	count if dup_hh_id > 0
	assert r(N) == 12
	drop dup_hh_id

**------------------------------------------------------------------------------
**# 2 Indicators
**------------------------------------------------------------------------------

**## 2.1 Hours since the stored water was collected, in 12-hour groups

*   D6 is hours (0-72) or 99 = "more than 72 hours". Two answers above 72
*   that aren't 99 (out of the form's range) are also more than 72 hours.
*   Extended missing values (.d, .r) are carried over.

	count if storage_time > 72 & storage_time != 99 & !missing(storage_time)
	assert r(N) == 2

	gen storage_time_cat = .
	replace storage_time_cat = 1 if inrange(storage_time,  0, 12)
	replace storage_time_cat = 2 if storage_time > 12 & storage_time <= 24
	replace storage_time_cat = 3 if storage_time > 24 & storage_time <= 36
	replace storage_time_cat = 4 if storage_time > 36 & storage_time <= 48
	replace storage_time_cat = 5 if storage_time > 48 & storage_time <= 60
	replace storage_time_cat = 6 if storage_time > 60 & storage_time <= 72
	replace storage_time_cat = 7 if storage_time > 72 & !missing(storage_time)
	replace storage_time_cat = storage_time if storage_time > .

	assert missing(storage_time_cat) == missing(storage_time)
	assert storage_time_cat == 7 if storage_time == 99

	lab def storage_cat 1 "0-12 hours"  2 "13-24 hours" 3 "25-36 hours" ///
	                    4 "37-48 hours" 5 "49-60 hours" 6 "61-72 hours" ///
	                    7 "More than 72 hours"                          ///
	                    .d "Don't know" .r "Declined to answer"
	lab val storage_time_cat storage_cat

**## 2.2 Chlorine in the past 7 days

*   E1 > 0. Answers above 7 days (out of range) are kept, for the HFC session.

	count if treat_chlorine > 7 & !missing(treat_chlorine)
	assert r(N) == 3
	count if treat_boil > 7 & !missing(treat_boil)
	assert r(N) == 2

	gen treat_chlorine_any = treat_chlorine > 0 if !missing(treat_chlorine)
	lab val treat_chlorine_any yesno

**------------------------------------------------------------------------------
**# 3 Labels
**------------------------------------------------------------------------------

**## 3.1 Section C: Respondent & household

	lab var resp_age "C1. Respondent's age (years) - stands in for person responsible for water"
	lab var resp_sex "C2. Respondent's sex - stands in for person responsible for water"

**## 3.2 Section D: Storage

	lab var storage_time_cat "D6. Hours since water was collected, 12-hour groups"

**## 3.3 Section E: Treatment

	lab var treat_chlorine_any "E1. Chlorine added on at least 1 of the past 7 days"

**------------------------------------------------------------------------------
**# 4 Save
**------------------------------------------------------------------------------

	order storage_time_cat,   after(storage_time)
	order treat_chlorine_any, after(treat_chlorine)

	ds, not(varlabel)
	if "`r(varlist)'" != "" {
		di as error "Variables without a label: `r(varlist)'"
		exit 459
	}

	local file "13-construct/131-household-indicators"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
		report(path("${data_git}/`file'.md") replace) ///
		replace
