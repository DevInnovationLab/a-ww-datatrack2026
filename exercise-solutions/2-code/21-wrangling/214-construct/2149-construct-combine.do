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

*   1:1 on key.
*   Expected: 938 households with a roster, 316 without, and no roster
*   without a household.

	merge 1:1 key using "${data_box}/13-construct/132-child-indicators.dta", ///
		assert(1 3)
		
	* Should be fixed during HFCs
	// assert hh_children == 0 if _merge == 1
	// drop 					   _merge
		
	// assert n_children_roster == hh_children
	// drop   n_children_roster
	
**------------------------------------------------------------------------------
**# 2 Save constructed data
**------------------------------------------------------------------------------
	
	ds, not(varlabel)
	if "`r(varlist)'" != "" {
		di as error "Variables without a label: `r(varlist)'"
		exit 459
	}

	label data "Household-level constructed data: 1 row = 1 consenting submission. ID: key"

	local file "13-construct/133-household-constructed"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
		report(path("${data_git}/`file'.md") replace) ///
		replace

**------------------------------------------------------------------------------
**# 3 Save analysis data
**------------------------------------------------------------------------------

	keep key village_id                                                  ///
	     resp_age resp_sex hh_size hh_children                           ///
	     diarrhea_*									                	 ///
	     hh_watersource stored_container stored_covered stored_clean     ///
	     storage_time_cat stored_chlorine                                ///
	     treat_chlorine_any treat_chlorine treat_boil                    ///
	     water_safety water_satisfaction

	label data "Household-level analysis data: 1 row = 1 consenting submission. ID: key"

	local file "13-construct/139-household-analysis"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
		report(path("${data_git}/`file'.md") replace) ///
		replace

***************************************************************** End of do-file
