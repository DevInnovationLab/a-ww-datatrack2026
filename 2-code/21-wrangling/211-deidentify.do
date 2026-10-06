/*  ANSWER KEY · 01-deidentify.do  (facilitators only)  */

	use "${data_pii}/00_imported_with_pii.dta", clear

	* YOUR TURN 1: crosswalk first
	preserve
		keep key hh_id child_name_* devicephonenum gps_*
		save "${data_pii}/crosswalk_pii.dta", replace
	restore

	* YOUR TURN 2: then drop
	drop child_name_* devicephonenum gps_*

	label data "Household Water Questionnaire V1 - de-identified"
	save "${data_clean}/01_deidentified.dta", replace
