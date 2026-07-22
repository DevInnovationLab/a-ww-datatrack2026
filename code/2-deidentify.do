/*******************************************************************************
  2-deidentify.do  ·  Strip direct identifiers
--------------------------------------------------------------------------------
  Author(s):  DIL Data Team
              David Torres Leon (dtorresleon@uchicago.edu)
              Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:    July 2026

  Inputs:     data/raw/household_water_questionnaire.dta

  Outputs:    data/raw/household_water_questionnaire-crosswalk-PII.dta
                - key + PII columns only (would live in encrypted storage)
              data/raw/household_water_questionnaire-deid.dta   (id: key)
              data/raw/household_water_questionnaire-deid.md    (iesave report)

  Summary:    devicephonenum, gps, and child_name_1-3 are direct identifiers.
              They must not travel with the analysis data. 

              The rule: crosswalk first, then drop -- and the crosswalk lives 
              somewhere else, encrypted.
*******************************************************************************/

	use "${data_raw}/household_water_questionnaire.dta", clear

**------------------------------------------------------------------------------
**# 1 Identify columns with PII
**------------------------------------------------------------------------------

	local pii_vars devicephonenum gps child_name_*

**------------------------------------------------------------------------------
**# 2 Save crosswalk
**------------------------------------------------------------------------------

	preserve

		keep key `pii_vars'

		iesave "${data_raw}/household_water_questionnaire-crosswalk-PII.dta", ///
			idvars(key) ///
			version(14) ///
			replace

	restore

**------------------------------------------------------------------------------
**# 3 De-identify working data
**------------------------------------------------------------------------------

	drop `pii_vars'

	iesave "${data_raw}/household_water_questionnaire-deid.dta", ///
		idvars(key) ///
		version(14) ///
		replace userinfo ///
		report(path("${data_raw}/household_water_questionnaire-deid.md") replace)

********************************************************************************
