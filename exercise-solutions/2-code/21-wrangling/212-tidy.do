/*  ANSWER KEY · 02-tidy-reshape.do  (facilitators only)  */

	use "${data_box}/10-raw/101-raw-deidentified/1010-household-raw.dta", clear
	
	local child_vars child_age* diarrhea_*
	
	preserve

		egen n_rostered = rownonmiss(child_age_*)
		summarize n_rostered
		local expected = r(sum)

		* YOUR TURN 1
		keep 	key hh_id `child_vars'
		reshape long child_age_ diarrhea_2d_ diarrhea_7d_, i(key) j(child_index)
		rename 	*_ *

		* YOUR TURN 2
		missings dropobs `child_vars', force
		isid key child_index
		assert _N == `expected'

		* YOUR TURN 3
		label data "Children under 5 (Section G): 1 row = 1 child. ID: key + child_no"
		local file "11-tidy/112-tidy-child"

		iesave "${data_box}/`file'.dta", ///
			idvars(key child_index) version(15) ///
			report(path("${data_box}/`file'.md") replace) ///
			replace
	

	restore 
	
	drop `child_vars'
	
	label data "Households: 1 row = 1 submission. ID: key"
	local file "11-tidy/111-tidy-household"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
        report(path("${data_box}/`file'.md") replace) ///
		replace
	
	