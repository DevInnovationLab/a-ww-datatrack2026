/*******************************************************************************
  214-construct.do
--------------------------------------------------------------------------------
  Authors:  DIL Data Team
            David Torres Leon (dtorresleon@uchicago.edu)
            Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:  7 October 2026

  Inputs:   ${data_box}/12-clean/121-household-clean.dta
            ${data_box}/12-clean/122-child-clean.dta
  Outputs:  ${data_box}/13-construct/131-household-construct.dta
            ${data_git}/13-construct/131-household-construct.md  (iesave report)

  Summary:  Builds the household-level analysis dataset, one row per
            submission (ID: key). Brings the child roster up to the household
            (number of children under 5 and diarrhoea in the past 2 and 7
            days, as a count, a share and an any-child indicator), groups the
            hours since the stored water was collected into 12-hour
            categories, adds whether chlorine was used in the past 7 days,
            and keeps the household variables the analysis uses.
            Consenting submissions only (non-consents are dropped in
            2131-clean-household.do and 2132-clean-child.do).

  Notes:    - Decisions made with L. Andrade on 7 October 2026:
              * Respondent's age and sex (C1, C2) stand in for the person
                responsible for water: the questionnaire doesn't ask who that
                is.
              * Diarrhoea is measured three ways (count, share, any child).
              * D6 is grouped into 12-hour categories, so the 99 code
                ("more than 72 hours") keeps its meaning.
              * "Treated with chlorine" = chlorine on at least one day in the
                past 7 (E1 > 0). D7 (chlorine added to the stored water) is
                kept as well. E1 and E2 stay separate: a day with both
                chlorine and boiling would be counted twice if added.
            - G4 is only asked if G3 = No, so a child with diarrhoea in the
              past 48 hours had it in the past 7 days: diarrhea_7d_all fills
              G4 from G3 for those children.
            - Households with no child roster get 0 children only when C6 = 0
              (Section G was skipped because there were none). Otherwise
              their child variables stay missing.
            - Duplicated hh_id, out-of-range answers and skip-pattern
              violations are kept as they are, for the HFC session. The
              counts asserted below document them, so a new case stops the
              code.
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

	gen diarrhea_7d_all = diarrhea_7d
	replace diarrhea_7d_all = 1 if diarrhea_2d == 1 & diarrhea_7d == .
	assert !missing(diarrhea_7d_all) if !missing(diarrhea_2d)

	count if diarrhea_2d == 1 & diarrhea_7d == .
	assert r(N) == 165

**## 1.2 Household level

	gen child = 1

	collapse (count) n_children_roster = child           ///
	         (sum)   n_diarrhea_2d     = diarrhea_2d     ///
	                 n_diarrhea_7d     = diarrhea_7d_all ///
	         (count) n_answered_2d     = diarrhea_2d     ///
	                 n_answered_7d     = diarrhea_7d_all, ///
	         by(key)

	isid key
	assert _N == 938

*   collapse (sum) returns 0 when no child has an answer: make that missing

	foreach d in 2d 7d {
		replace n_diarrhea_`d' = . if n_answered_`d' == 0
	}

	tempfile children
	save `children'

**------------------------------------------------------------------------------
**# 2 Households: one row per submission
**------------------------------------------------------------------------------

	use "${data_box}/12-clean/121-household-clean.dta", clear

	isid key
	assert _N == 1254

*   hh_id is not unique: 6 values have two submissions each. Both are kept
*   (key is the ID); which one counts is for the HFC session.

	duplicates tag hh_id, gen(dup_hh_id)
	count if dup_hh_id > 0
	assert r(N) == 12
	drop dup_hh_id

	assert consent == 1

	keep key hh_id village_id enumerator ///
		 resp_age resp_sex hh_size hh_children     ///
		 hh_watersource stored_yn stored_container stored_covered stored_clean ///
		 storage_time stored_chlorine treat_chlorine treat_boil water_safety water_satisfaction

**------------------------------------------------------------------------------
**# 3 Merge children onto households
**------------------------------------------------------------------------------

*   1:1 on key. The child file's hh_id, village_id and enumerator were dropped
*   by the collapse: those come from the household file.
*   Expected: 938 households with a roster match, 316 without, and no child
*   roster without a household.

	merge 1:1 key using `children'

	assert _merge != 2
	count if _merge == 3
	assert r(N) == 938
	count if _merge == 1
	assert r(N) == 316

**## 3.1 Households without a roster

*   No roster and C6 = 0: Section G was skipped because there are no children
*   under 5, so the counts are true zeros. Shares and any-child indicators stay
*   missing (there is no child to have diarrhoea).

	foreach v in n_children_roster n_diarrhea_2d n_diarrhea_7d {
		replace `v' = 0 if _merge == 1 & hh_children == 0
	}

*   No roster although C6 > 0 (2 households): left missing, for the HFC session

	count if _merge == 1 & hh_children > 0 & !missing(hh_children)
	assert r(N) == 2

*   Roster size differs from C6 (1 household): kept, for the HFC session

	count if _merge == 3 & n_children_roster != hh_children
	assert r(N) == 1

	drop _merge

**------------------------------------------------------------------------------
**# 4 Constructed indicators
**------------------------------------------------------------------------------

**## 4.1 Diarrhoea

	foreach d in 2d 7d {
		gen share_diarrhea_`d' = n_diarrhea_`d' / n_answered_`d' ///
			if n_answered_`d' > 0 & !missing(n_answered_`d')
		gen any_diarrhea_`d'   = n_diarrhea_`d' > 0 ///
			if n_answered_`d' > 0 & !missing(n_answered_`d')

		assert inrange(share_diarrhea_`d', 0, 1) if !missing(share_diarrhea_`d')
		assert n_diarrhea_`d' <= n_children_roster if !missing(n_diarrhea_`d')
	}

**## 4.2 Hours since the stored water was collected, in 12-hour groups

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

**## 4.3 Chlorine in the past 7 days

*   E1 > 0. Answers above 7 days (out of range) are kept, for the HFC session.

	gen treat_chlorine_any = treat_chlorine > 0 if !missing(treat_chlorine)
	lab val treat_chlorine_any yesno

	count if treat_chlorine > 7 & !missing(treat_chlorine)
	assert r(N) == 3
	count if treat_boil > 7 & !missing(treat_boil)
	assert r(N) == 2

	lab val any_diarrhea_2d any_diarrhea_7d yesno

**------------------------------------------------------------------------------
**# 5 Labels
**------------------------------------------------------------------------------

**## 5.1 Section C: Respondent & household

	lab var resp_age          "C1. Respondent's age (years) - stands in for person responsible for water"
	lab var resp_sex          "C2. Respondent's sex - stands in for person responsible for water"
	lab var n_children_roster "G. Children under 5 in the roster (0 if C6 = 0)"

**## 5.2 Section D: Storage

	lab var storage_time_cat  "D6. Hours since water was collected, 12-hour groups"

**## 5.3 Section E: Treatment

	lab var treat_chlorine_any "E1. Chlorine added on at least 1 of the past 7 days"

**## 5.4 Section G: Children

	lab var n_diarrhea_2d     "G3. Children <5 with diarrhoea, past 48 hours (0 if C6 = 0)"
	lab var n_diarrhea_7d     "G3-G4. Children <5 with diarrhoea, past 7 days (0 if C6 = 0)"
	lab var n_answered_2d     "G3. Children <5 with a G3 answer"
	lab var n_answered_7d     "G3-G4. Children <5 with a 7-day answer"
	lab var share_diarrhea_2d "G3. Share of children <5 with diarrhoea, past 48 hours"
	lab var share_diarrhea_7d "G3-G4. Share of children <5 with diarrhoea, past 7 days"
	lab var any_diarrhea_2d   "G3. Any child <5 with diarrhoea, past 48 hours"
	lab var any_diarrhea_7d   "G3-G4. Any child <5 with diarrhoea, past 7 days"

**------------------------------------------------------------------------------
**# 6 Check and save
**------------------------------------------------------------------------------

	order key hh_id village_id enumerator                                ///
	      resp_age resp_sex hh_size hh_children n_children_roster         ///
	      n_answered_2d n_diarrhea_2d share_diarrhea_2d any_diarrhea_2d   ///
	      n_answered_7d n_diarrhea_7d share_diarrhea_7d any_diarrhea_7d   ///
	      hh_watersource stored_yn stored_container stored_covered        ///
	      stored_clean storage_time storage_time_cat stored_chlorine      ///
	      treat_chlorine treat_chlorine_any treat_boil                    ///
	      water_safety water_satisfaction

	isid key
	assert _N == 1254

*   Every variable has a label

	ds, not(varlabel)
	if "`r(varlist)'" != "" {
		di as error "Variables without a label: `r(varlist)'"
		exit 459
	}

	local file "13-construct/131-household-construct"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
		report(path("${data_git}/`file'.md") replace) ///
		replace
