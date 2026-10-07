**------------------------------------------------------------------------------
**# 1 Household indicators
**------------------------------------------------------------------------------

**## 1.1 Load data

	use "${data_box}/household-clean.dta", clear

**## 1.2 Hours since the stored water was collected, in 12-hour groups

	gen 	storage_time_cat = .
	replace storage_time_cat = 1 if inrange(storage_time,  0, 12)
	replace storage_time_cat = 2 if storage_time > 12 & storage_time <= 24
	replace storage_time_cat = 3 if storage_time > 24 & storage_time <= 36
	replace storage_time_cat = 4 if storage_time > 36 & storage_time <= 48
	replace storage_time_cat = 5 if storage_time > 48 & storage_time <= 72
	replace storage_time_cat = 6 if storage_time > 72

	lab def storage_cat 1 "0-12 hours"  ///
						2 "12-24 hours" ///
						3 "24-36 hours" ///
	                    4 "36-48 hours" ///
						5 "48-72 hours" ///
	                    6 "More than 72 hours" ///
	                    .d "Don't know" ///
						.r "Declined to answer"
	lab val storage_time_cat storage_cat

**## 1.3 Chlorine and boiling in the past 7 days

	gen 	treat_chlorine_any 	= treat_chlorine > 0
	gen 	treat_boil_any 		= treat_boil 	 > 0

	lab val *_any 	 yesno

**## 1.4 Labels

	lab var storage_time_cat 	"Time since water was collected"
	lab var treat_chlorine_any 	"Treated water with chlorine on at least 1 of the past 7 days"
	lab var treat_boil_any 		"Boiled drinking water on at least 1 of the past 7 days"

**------------------------------------------------------------------------------
**# 2 Merge child indicators onto households
**------------------------------------------------------------------------------

	merge m:m hh_id using "${data_box}/child-clean.dta"
	drop _merge

**-----------------------------------------------------------------------------*/
**# 3 Child indicators
**------------------------------------------------------------------------------

**## 3.2  Aggregate to the household

	collapse (max)   diarrhea_2d_any   = diarrhea_2d  ///
	                 diarrhea_7d_any   = diarrhea_7d  ///
			 (sum)   diarrhea_2d_total = diarrhea_2d  ///
	                 diarrhea_7d_total = diarrhea_7d  ///
			 (mean)  diarrhea_2d_share = diarrhea_2d  ///
	                 diarrhea_7d_share = diarrhea_7d, ///
	         by(hh_id)

**## 3.3 Labels: Section G, Children

	lab def yesno 1 "Yes" 0 "No", replace
	lab val *any yesno

	lab var diarrhea_2d_total "Number of children under 5 with diarrhea in the past 2 days"
	lab var diarrhea_7d_total "Number of children under 5 with diarrhea in the past 7 days"
	lab var diarrhea_2d_share "Share of children under 5 with diarrhea in the past 2 days"
	lab var diarrhea_7d_share "Share of children under 5 with diarrhea in the past 7 days"
	lab var diarrhea_2d_any   "At least one child under 5 with diarrhea in the past 2 days"
	lab var diarrhea_7d_any   "At least one child under 5 with diarrhea in the past 7 days"

	order key *2d* *7d*
	
**------------------------------------------------------------------------------
**# 4 Save constructed data
**------------------------------------------------------------------------------

	label data "Household-level constructed data: 1 row = 1 consenting submission. ID: key"

	save "constructed.dta", replace


**------------------------------------------------------------------------------
**# 5 Save analysis data
**------------------------------------------------------------------------------

	keep key village_id                                                  ///
	     resp_age resp_sex hh_size hh_children                           ///
	     diarrhea_*                                                      ///
	     hh_watersource stored_container stored_covered stored_clean     ///
	     storage_time_cat stored_chlorine                                ///
	     treat_chlorine_any treat_chlorine treat_boil                    ///
	     water_safety water_satisfaction

	label data "Household-level analysis data: 1 row = 1 consenting submission. ID: key"

	save "${data_box}/final.dta", replace


***************************************************************** End of do-file
