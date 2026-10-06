/*  ANSWER KEY · 01-deidentify.do  (facilitators only)  */

	use "${data_box}/10-raw/100-raw-identified/1000-household-raw-pii.dta", clear

	* YOUR TURN 1: crosswalk first
	preserve
		keep key hh_id child_name_* devicephonenum gps*
		save "${data_box}/10-raw/100-raw-identified/1001-household-crosswalk-pii.dta", replace
	restore

	* YOUR TURN 2: then drop
	drop child_name_* devicephonenum gps*

	label data "Household Water Questionnaire V1 - de-identified"
	
	local file "/10-raw/101-raw-deidentified/1010-household-raw"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
        report(path("${data_git}/`file'.md") replace) ///
		replace
		