/*******************************************************************************
  4-clean.do  ·  SUPERSEDED DRAFT -- not used by main.do
--------------------------------------------------------------------------------
  Author(s):  DIL Data Team
              David Torres Leon (dtorresleon@uchicago.edu)
              Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:    July 2026

  Inputs:     data/tidy/household-tidy.dta   (sections 1-6 only; unreachable
              code below section 7 targets data/clean/households.dta and
              data/clean/containers.dta, which are not produced anywhere in
              this pipeline)

  Outputs:    None reachable -- section 7 is followed by an `exit` and the
              rest of the file never runs.

  Summary:    Earlier draft of household cleaning/labeling, from before this
              exercise was adapted to the household_water_questionnaire data.
              Sections 1-6 are an exact copy of 4-clean-household.do. Section 7
              onward is unreachable teaching-exercise scratch code left over
              from a prior "chlorine testing" version of this dataset
              (households.dta / containers.dta / chlorine_mgl / submission_id).

  Notes:      Kept for reference only. 4-clean-household.do and 5-clean-
              child.do are the current, working versions -- see readme.md >
              Known inconsistencies. Consider deleting this file once that's
              confirmed.
*******************************************************************************/

**------------------------------------------------------------------------------
**# 1 Household-level data
**------------------------------------------------------------------------------

	use "${data_tidy}/household-tidy.dta", clear

**## 1.1 Fix variable formats

	* IDs stay as strings

**## 1.2 Categorical variables are turned into labelled values

	local cat_vars enumerator deviceid

	foreach var of local cat_vars {
		tempvar str
		rename `var' `str'
		encode `str', gen(`var')
		drop `str'
	}

**## 1.3 Dates

	local date_vars submissiondate starttime endtime

	foreach var of local date_vars {
		tempvar date
		rename `var' `date'
		gen `var' = clock(strtrim(itrim(`date')), "MD20Y hm")
		format `var' %tc
		drop `date'
	}

**## 1.4 GPS (requires identified data)
/*
	split  gps, parse(" ") destring
	rename gps1 gps_lat
	rename gps2 gps_lon
	rename gps3 gps_alt
	rename gps4 gps_acc
	drop   gps
*/

**------------------------------------------------------------------------------
**# 2 Explore variable distribution
**------------------------------------------------------------------------------

	codebook

**------------------------------------------------------------------------------
**# 3 Replace missing codes
**------------------------------------------------------------------------------

	ds, has(type numeric)
	local num_vars `r(varlist)'

	recode `num_vars' (-666 = .o) ///
		(-888 = .r) ///
		(-999 = .k)

**------------------------------------------------------------------------------
**# 4 Label categories (extracted from survey form)
**------------------------------------------------------------------------------

	local dummy_vars consent resp_hh_head stored_yn stored_clean ///
		stored_chlorine treat_notablets stored_covered

	lab def yesno 1 "Yes" ///
		0 "No"
	lab val `dummy_vars' yesno

	lab def sex 1 "Male" ///
		2 "Female"
	lab val resp_sex sex

	lab def educ 0 "None" ///
		1 "Primary" ///
		2 "Secondary" ///
		3 "Tertiary"
	lab val resp_educ educ

	lab def source 1 "Piped" ///
		2 "Protected well" ///
		3 "River or stream" ///
		4 "Trucked"
	lab val hh_watersource source

	lab def container 1 "Bucket" ///
		2 "Clay pot" ///
		3 "Jerry can"
	lab val stored_container container

	lab def safe 3 "Very safe" ///
		2 "Somewhat safe" ///
		1 "Not safe"
	lab val water_safety safe

	lab def satisfied 3 "Very satisfied" ///
		2 "Somewhat satisfied" ///
		1 "Not satisfied"
	lab val water_satisfaction satisfied

**------------------------------------------------------------------------------
**# 5 Recategorize other values
**------------------------------------------------------------------------------

	tab stored_container_o
	replace stored_container = 4 if stored_container_o == "Plastic drum"
	lab def container 4 "Plastic drum", add
	drop stored_container_o

	tab hh_watersource_o
	replace hh_watersource = 3 if regex(lower(hh_watersource_o), "river")
	replace hh_watersource = 4 if regex(lower(hh_watersource_o), "truck")
	replace hh_watersource = 5 if regex(lower(hh_watersource_o), "rain")
	lab def source 5 "Rainwater", add

	label dir
	local labels `r(names)'

	foreach lbl of local labels {
		label define `lbl' .d "Don't know" ///
			.r "Refused" ///
			.o "Other", ///
			add
	}

**------------------------------------------------------------------------------
**# 6 [UNREACHABLE FROM HERE] Legacy teaching-exercise scratch code
**------------------------------------------------------------------------------
* Everything below this point targets a pre-migration dataset (households.dta,
* containers.dta, chlorine_mgl, submission_id) that this pipeline does not
* produce, and is never reached because of the `exit` immediately below.
* `save` (not `iesave`) is used throughout because this was written before
* the pipeline adopted iesave; left as-is since the code never runs.

	exit

* (a) Harmonize yes/no spellings. One variable is done for you:

	tab consent
	replace consent = "Yes" if inlist(lower(consent), "yes", "y")
	replace consent = "No"  if inlist(lower(consent), "no", "n")
	tab consent

	* --- YOUR TURN 1: do the same for the other messy yes/no variables ---
	* (treats_water, tested_this_morning, storage_covered, storage_washed_7d,
	*  water_safe_yn)  Tip: a foreach loop does all of them in 4 lines.
	*
	* Hint structure (replace ___ ):
	*   foreach v in ___ ___ ___ ___ ___ {
	*       replace `v' = "Yes" if inlist(lower(`v'), "yes", "y")
	*       replace `v' = "___" if inlist(lower(`v'), "___", "___")
	*   }

	* --- YOUR TURN 2: harmonize resp_sex (Female/female/F, Male/male/M) ---

* (b) Missing codes -> real missings. wait_minutes is done for you:

	summarize wait_minutes
	replace wait_minutes = . if wait_minutes == -999
	summarize wait_minutes

	* --- YOUR TURN 3: chlorine_mgl is still a STRING because the export
	* used "N/A" for missing. Fix the code, then destring.
	*
	* Hint structure (replace ___ ):
	*   replace chlorine_mgl = "" if chlorine_mgl == "___"
	*   destring chlorine_mgl, replace

* (c) Labels. Two are done for you -- extend the list:

	label variable hh_id        "Household ID (A2)"
	label variable chlorine_mgl "Free chlorine reading, mg/L (G5)"

	* --- YOUR TURN 4: label at least five more variables you consider key.
	* Use the questionnaire in 01_documentation for wording + question numbers.

* Save

	save "${data_clean}/households.dta", replace

	* And don't forget the container table needs its yes/no harmonized too:

	use "${data_clean}/containers.dta", clear
	replace container_covered = "Yes" if inlist(lower(container_covered), "yes", "y")
	replace container_covered = "No"  if inlist(lower(container_covered), "no", "n")
	label variable container_covered "Container is covered"
	save "${data_clean}/containers.dta", replace

********************************************************************************
