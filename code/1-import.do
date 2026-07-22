/*******************************************************************************
  1-import.do  ·  Import raw survey export
--------------------------------------------------------------------------------
  Author(s):  DIL Data Team
              David Torres Leon (dtorresleon@uchicago.edu)
              Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:    July 2026

  Inputs:     data/raw/household_water_questionnaire__v1.csv
                - raw SCTO export

  Outputs:    data/raw/household_water_questionnaire.dta   (id: key)
              data/raw/household_water_questionnaire.md    (iesave report)

  Summary:    Imports the raw data from CSV into Stata

*******************************************************************************/

**------------------------------------------------------------------------------
**# 1 Load raw data
**------------------------------------------------------------------------------
* Import everything as text first -- never let Stata guess types on a messy
* file, as that may have unintended consequences.

	import delimited "${data_raw}/household_water_questionnaire__v1.csv", ///
		clear ///
		varnames(1) ///
		stringcols(_all) ///
		bindquote(strict)

	describe, short

**------------------------------------------------------------------------------
**# 2 Adjust variable formats
**------------------------------------------------------------------------------

	destring duration_min consent resp_age resp_sex resp_hh_head resp_educ ///
		hh_size hh_children hh_watersource stored_yn stored_container ///
		stored_covered stored_clean storage_time stored_chlorine ///
		treat_chlorine treat_boil treat_notablets water_safety ///
		water_satisfaction child_age_* diarrhea_2d_* diarrhea_7d_*, replace

**------------------------------------------------------------------------------
**# 3 Save to Stata format
**------------------------------------------------------------------------------

	iesave "${data_raw}/household_water_questionnaire.dta", ///
		idvars(key) ///
		version(14) ///
		replace userinfo ///
		report(path("${data_raw}/household_water_questionnaire.md") replace)

********************************************************************************
