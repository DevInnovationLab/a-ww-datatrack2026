/*******************************************************************************
  2149-construct-combine.do
--------------------------------------------------------------------------------
  Authors:  DIL Data Team
            David Torres Leon (dtorresleon@uchicago.edu)
            Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:  7 October 2026

  Inputs:   ${data_box}/13-construct/131-household-indicators.dta
            ${data_box}/13-construct/132-child-indicators.dta
  Outputs:  ${data_box}/13-construct/133-household-constructed.dta
            ${data_git}/13-construct/133-household-constructed.md  (iesave report)
            ${data_box}/13-construct/139-household-analysis.dta
            ${data_git}/13-construct/139-household-analysis.md  (iesave report)

  Summary:  Merges the child indicators onto the household indicators, sets
            the child counts of households without children under 5 to 0,
            and saves two datasets, one row per consenting submission
            (ID: key): the constructed data with every variable, and the
            analysis data with the analysis variables only. Every variable is
            described in
            4-documentation/41-data/412-data-dictionaries/139-household-analysis.md.

  Notes:    - Households with no roster get 0 children only when C6 = 0
              (Section G was skipped because there were none). Otherwise
              their child variables stay missing. Shares and any-child
              indicators stay missing: there is no child to have diarrhoea.
            - Number of children under 5 = C6 (hh_children). The roster count
              is only used to check it.
            - Roster/C6 mismatches are kept as they are, for the HFC session.
              Their counts are asserted, so a new case stops the code.
*******************************************************************************/

**------------------------------------------------------------------------------
**# 1 Merge child indicators onto households
**------------------------------------------------------------------------------

	use "${data_box}/13-construct/131-household-indicators.dta", clear
	isid key
	assert _N == 1254

*   1:1 on key. The two files share no variable other than key.
*   Expected: 938 households with a roster, 316 without, and no roster
*   without a household.

	merge 1:1 key using "${data_box}/13-construct/132-child-indicators.dta"

	assert _merge != 2
	count if _merge == 3
	assert r(N) == 938
	count if _merge == 1
	assert r(N) == 316

**------------------------------------------------------------------------------
**# 2 Households without a roster
**------------------------------------------------------------------------------

*   No roster and C6 = 0: Section G was skipped because there are no children
*   under 5, so the counts are true zeros.

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

	lab var n_diarrhea_2d "G3. Children <5 with diarrhoea, past 48 hours (0 if C6 = 0)"
	lab var n_diarrhea_7d "G3-G4. Children <5 with diarrhoea, past 7 days (0 if C6 = 0)"
	lab var n_children_roster "G. Children under 5 in the roster (0 if C6 = 0)"

**------------------------------------------------------------------------------
**# 3 Constructed data: every variable
**------------------------------------------------------------------------------

	isid key
	assert _N == 1254

	ds, not(varlabel)
	if "`r(varlist)'" != "" {
		di as error "Variables without a label: `r(varlist)'"
		exit 459
	}

	label data "Household constructed data: 1 row = 1 consenting submission. ID: key"

	local file "13-construct/133-household-constructed"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
		report(path("${data_git}/`file'.md") replace) ///
		replace

**------------------------------------------------------------------------------
**# 4 Analysis variables
**------------------------------------------------------------------------------

	keep key village_id                                                  ///
	     resp_age resp_sex hh_size hh_children                           ///
	     n_diarrhea_2d share_diarrhea_2d any_diarrhea_2d                 ///
	     n_diarrhea_7d share_diarrhea_7d any_diarrhea_7d                 ///
	     hh_watersource stored_container stored_covered stored_clean     ///
	     storage_time_cat stored_chlorine                                ///
	     treat_chlorine_any treat_chlorine treat_boil                    ///
	     water_safety water_satisfaction

	order key village_id                                                 ///
	      resp_age resp_sex hh_size hh_children                          ///
	      n_diarrhea_2d share_diarrhea_2d any_diarrhea_2d                ///
	      n_diarrhea_7d share_diarrhea_7d any_diarrhea_7d                ///
	      hh_watersource stored_container stored_covered stored_clean    ///
	      storage_time_cat stored_chlorine                               ///
	      treat_chlorine_any treat_chlorine treat_boil                   ///
	      water_safety water_satisfaction

**------------------------------------------------------------------------------
**# 5 Check and save
**------------------------------------------------------------------------------

	isid key
	assert _N == 1254

	ds, not(varlabel)
	if "`r(varlist)'" != "" {
		di as error "Variables without a label: `r(varlist)'"
		exit 459
	}

	label data "Household analysis data: 1 row = 1 consenting submission. ID: key"

	local file "13-construct/139-household-analysis"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
		report(path("${data_git}/`file'.md") replace) ///
		replace
