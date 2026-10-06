/*  ANSWER KEY · 02-tidy-reshape.do  (facilitators only)  */

	use "${data_box}/10-raw/101-raw-deidentified/1010-household-raw.dta", clear
	
	preserve

		egen n_rostered = rownonmiss(child_age_*)
		tab n_rostered
		quietly summarize n_rostered
		local expected = r(sum)
		di as result "Expecting `expected' child rows after the reshape"     // 1,587

		* YOUR TURN 1
		keep key hh_id village_id enumerator child_age_* diarrhea_2d_* diarrhea_7d_*
		reshape long child_age_ diarrhea_2d_ diarrhea_7d_, i(key) j(child_no)
		rename (child_age_ diarrhea_2d_ diarrhea_7d_) (child_age diarrhea_2d diarrhea_7d)
		* (i(hh_id) fails: "variable id does not uniquely identify the observations")

		* YOUR TURN 2
		drop if missing(child_age) & missing(diarrhea_2d) & missing(diarrhea_7d)
		//isid key child_no
		count
		assert r(N) == `expected'

		* YOUR TURN 3
		label data "Children under 5 (Section G): 1 row = 1 child. ID: key + child_no"

		local file "11-tidy/112-tidy-child"

		iesave "${data_box}/`file'.dta", ///
			idvars(key child_no) version(15) ///
			report(path("${data_box}/`file'.md") replace) ///
			replace
	

	restore 
	
	drop child_age_* diarrhea_2d_* diarrhea_7d_*
	
	label data "Households: 1 row = 1 submission. ID: key"
	
	local file "11-tidy/111-tidy-household"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
        report(path("${data_box}/`file'.md") replace) ///
		replace
	
	