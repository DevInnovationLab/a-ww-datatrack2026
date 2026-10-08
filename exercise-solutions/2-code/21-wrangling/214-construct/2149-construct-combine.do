/*******************************************************************************
  2149-construct-combine.do
--------------------------------------------------------------------------------
  Authors:  DIL Data Team
            David Torres Leon (dtorresleon@uchicago.edu)
            Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:  8 October 2026

  Inputs:   ${data_box}/13-construct/131-household-indicators.dta
            ${data_box}/13-construct/132-child-indicators.dta
            ${data_box}/10-raw/102-treatment/1020-village-treatment.dta
  Outputs:  ${data_box}/13-construct/133-household-constructed.dta
            ${data_git}/13-construct/133-household-constructed.md  (iesave report)
            ${data_box}/13-construct/139-household-analysis.dta
            ${data_git}/13-construct/139-household-analysis.md  (iesave report)

            ${github}/4-documentation/41-data/412-data-dictionaries/139-household-analysis.txt
              (iecodebook plaintext codebook)

  Summary:  Merges the child indicators onto the household indicators and
            saves two datasets, one row per consenting submission (ID: key):
            the constructed data with every variable, and the analysis data
            with the analysis variables, the village treatment assignment and
            the main analysis sample flag. Checks every variable the analysis
            uses, so analysis scripts don't have to. Writes a plaintext codebook of
            the analysis data next to its data dictionary,
            4-documentation/41-data/412-data-dictionaries/139-household-analysis.md.

  Notes:    - Households with no roster have missing child variables.
            - Setting their counts to 0 when C6 = 0 (Section G was skipped
              because there were no children) and checking the roster count
              against C6 are commented out until the HFC corrections are
              applied: the raw data has roster/C6 mismatches.
            - Number of children under 5 = C6 (hh_children). The roster count
              is only used to check it.
            - main_sample flags the main analysis sample (households with
              children under 5 and no missing take-up, diarrhea or controls).
              It uses ${controls} from main.do: rerun this script when the
              controls change. Analysis scripts keep if main_sample at the top.
            - The treatment assignment is NOT from a real RCT: it was made up
              for teaching by exercises/facilitator/make-treatment-assignment.do
              (the 6 villages with the highest chlorine take-up are treated).
*******************************************************************************/

**------------------------------------------------------------------------------
**# 1 Merge child indicators onto households
**------------------------------------------------------------------------------

	use "${data_box}/13-construct/131-household-indicators.dta", clear

*   1:1 on key. Expected: every household in the child file matches one
*   household here, and no household is added -- meaning only _merge codes 1 and 3.

	merge 1:1 key using "${data_box}/13-construct/132-child-indicators.dta", ///
		assert(1 3)
		
	* To be included after the HFC corrections
	// assert hh_children == 0 if _merge == 1
	// drop 					  _merge
		
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

**## 3.1 Treatment assignment

*   Village-level assignment, merged m:1 on village_id. Every household's
*   village must be in the assignment file, and every village in it must have
*   households: only _merge == 3.

	merge m:1 village_id using "${data_box}/10-raw/102-treatment/1020-village-treatment.dta", ///
		assert(match) nogen

	* 12 villages, each entirely in treatment or entirely in control
	assert inlist(treatment, 0, 1)
	bys village_id (treatment): assert treatment[1] == treatment[_N]
	qui tab village_id
	assert r(r) == 12

**## 3.2 Check the variables the analysis uses

	* Take-up and diarrhea are 0/1. Diarrhea is missing when there are no
	* children under 5 (Section G skipped), and for 2 households that report
	* children but have no child records (kept for the HFC session)
	assert inlist(treat_chlorine_any, 0, 1) if !missing(treat_chlorine_any)
	assert inlist(diarrhea_week_any,  0, 1) if !missing(diarrhea_week_any)
	assert missing(diarrhea_week_any) if hh_children == 0

	* Household size and age are positive counts; sex is 1 Male, 2 Female
	assert hh_size  > 0 if !missing(hh_size)
	assert resp_age > 0 if !missing(resp_age)
	assert inlist(resp_sex, 1, 2) if !missing(resp_sex)

**## 3.3 Main analysis sample

*   Households with at least one child under 5 (the only ones asked Section G),
*   with non-missing take-up, diarrhea and controls. The controls come from
*   ${controls} in main.do, so rerun this script when they change.

	local controls_vars : subinstr global controls "i." "", all
	local controls_csv  : subinstr local  controls_vars " " ", ", all

	gen byte main_sample = hh_children > 0 & ///
		!missing(treat_chlorine_any, diarrhea_week_any, `controls_csv')

	lab val main_sample yesno
	lab var main_sample "In main analysis sample: children under 5, no missing outcomes/controls"

**## 3.4 Keep analysis variables and save

	keep key village_id treatment main_sample                            ///
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

**------------------------------------------------------------------------------
**# 4 Codebook of the analysis data
**------------------------------------------------------------------------------

*   Written next to the data dictionary, so it changes whenever the data do.
*   The .xlsx path is only used to name the file: noexcel writes the .txt only.

	iecodebook export using "${github}/4-documentation/41-data/412-data-dictionaries/139-household-analysis.xlsx", ///
		plaintext(detailed) noexcel replace

***************************************************************** End of do-file
