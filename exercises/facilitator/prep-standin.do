/*******************************************************************************
  prep-standin.do  ·  Build a minimal analysis dataset           [STAND-IN]

  FACILITATOR REFERENCE ONLY, NOT RUN. The clean CSVs shipped with the
  exercises are built by make_exercise_data.R (with prep-standin.R, the same
  logic). This Stata version is kept for reference; it was written for the
  old exercise folder layout, so its paths would need updating to run.
--------------------------------------------------------------------------------
  Author(s):  DIL Data Team
              Nandita Gupta (nanditag@uchicago.edu)
  Updated:    October 2026

  Inputs:     data/raw/household_water_questionnaire__v1.csv
                - SurveyCTO export of household_water_v1 (Session 2 version)

  Outputs:    data/analysis/household-analysis.dta
                (id: key)
              data/analysis/child-analysis.dta
                (id: key child_index)

  Summary:    The course does not have its clean, constructed dataset yet,
              so this script builds just enough of one for the Overleaf
              exercise: it imports the raw export, removes direct
              identifiers, recodes the survey's missing codes, and constructs
              the household and child indicators the PI update reports. It
              never overwrites an observed variable: every indicator is new.
              Participants do not need to edit this file.

  Notes:      TEMPORARY. Once the constructed data exists, delete this file
              and point 2-export-outputs.do at it (see the facilitator notes,
              "Data"). The indicator names below are the contract between
              the two scripts.

              This is NOT the cleaning pipeline in the course repository's code/. Content problems
              in the raw data (duplicate hh_ids, outliers, skip-pattern
              violations) are left in, except where a constructed indicator
              must exclude impossible values; each such decision is marked
              STAND-IN DECISION so it can be revisited.

              Missing codes follow the questionnaire: -999 = Don't know (.d),
              -888 = Declined (.r). -666 = Other is a real answer and stays.

              Dates: the Session 2 export writes "Jul 12, 2026 4:04:50 AM";
              the older export in data/raw writes "7/12/26 4:40". Both are
              parsed, so either file works.

              Variable labels put the source question's code first, from the
              SurveyCTO form in documentation/Household Water Questionnaire -
              V1.xlsx (survey sheet).
*******************************************************************************/

**------------------------------------------------------------------------------
**# 1 Import
**------------------------------------------------------------------------------

	* Everything as text first: never let Stata guess types on a raw export
	import delimited "${ex_raw}/household_water_questionnaire__v1.csv", ///
		clear varnames(1) stringcols(_all) bindquote(strict) encoding("utf-8")

	rename *, lower
	isid key

**------------------------------------------------------------------------------
**# 2 Formats
**------------------------------------------------------------------------------

**## 2.1 Numeric variables
**------------------------------------------------------------------------------

	destring duration_min hh_id village_id consent                          ///
		resp_age resp_sex resp_hh_head resp_educ hh_size hh_children         ///
		hh_watersource stored_yn stored_container stored_covered stored_clean ///
		storage_time stored_chlorine treat_chlorine treat_boil treat_notablets ///
		water_safety water_satisfaction                                      ///
		child_age_* diarrhea_2d_* diarrhea_7d_*, replace

**## 2.2 Interview date
**------------------------------------------------------------------------------

	gen double start_tc = clock(starttime, "MDYhms")
	replace    start_tc = clock(starttime, "MD20Y hm") if missing(start_tc)
	assert !missing(start_tc)

	gen survey_date = dofc(start_tc)
	format survey_date %td
	drop start_tc

**------------------------------------------------------------------------------
**# 3 De-identify
**------------------------------------------------------------------------------

	* Direct identifiers never travel with analysis data
	drop devicephonenum gps child_name_*

**------------------------------------------------------------------------------
**# 4 Missing codes
**------------------------------------------------------------------------------

	ds, has(type numeric)
	foreach var of varlist `r(varlist)' {
		quietly replace `var' = .d if `var' == -999
		quietly replace `var' = .r if `var' == -888
	}

**------------------------------------------------------------------------------
**# 5 Construct household indicators
**------------------------------------------------------------------------------

**## 5.1 Sample flags
**------------------------------------------------------------------------------

	gen consented = (consent == 1) if !missing(consent)

	* Last 7 days of fieldwork, defined from the data, not typed
	summarize survey_date
	gen last_week = (survey_date > r(max) - 7)

**## 5.2 Water treatment (Section E)
**------------------------------------------------------------------------------

	* STAND-IN DECISION: the form allows 0-7 days. Values above 7 are
	* impossible, so they are missing in the indicators (the raw variables
	* keep them for the HFC session).
	gen chlorine_days = treat_chlorine if inrange(treat_chlorine, 0, 7)
	gen chlorine_any  = (chlorine_days > 0) if !missing(chlorine_days)

	gen boil_days     = treat_boil if inrange(treat_boil, 0, 7)
	gen boil_any      = (boil_days > 0) if !missing(boil_days)

	gen ran_out       = treat_notablets

**## 5.3 Water storage (Section D)
**------------------------------------------------------------------------------

	gen stored_now    = stored_yn

	* D7 is only asked if D1 = Yes
	gen stored_chlor  = stored_chlorine if stored_yn == 1

**## 5.4 Water source and perceptions (Sections C and F)
**------------------------------------------------------------------------------

	* -666 (Other) is a real source, so it counts as "not piped"
	gen piped         = (hh_watersource == 1) if !missing(hh_watersource)
	gen safe_very     = (water_safety == 3)   if !missing(water_safety)

**------------------------------------------------------------------------------
**# 6 Label household variables
**------------------------------------------------------------------------------

	lab def yesno 1 "Yes" 0 "No"
	lab val consented last_week chlorine_any boil_any ran_out stored_now ///
		stored_chlor piped safe_very yesno

**## 6.1 Metadata

	lab var key         "Unique submission ID"
	lab var survey_date "Date of interview (from start time)"
	lab var last_week   "Interviewed in the last 7 days of fieldwork"

**## 6.2 Section A: Identification

	lab var hh_id      "(A1) Household ID"
	lab var village_id "(A2) Community/village name"

**## 6.3 Section B: Consent

	lab var consented "(B1) Respondent consented to the interview"

**## 6.4 Section C: Respondent & household roster

	lab var piped "(C7) Primary drinking water source is piped"

**## 6.5 Section D: Household water storage

	lab var stored_now   "(D1) Household has drinking water stored now"
	lab var stored_chlor "(D7) Stored water was chlorinated (if D1 = Yes)"

**## 6.6 Section E: Water treatment practices

	lab var chlorine_days "(E1) Days chlorine added, past 7 days (0-7 only)"
	lab var chlorine_any  "(E1) Chlorine added on 1+ of past 7 days"
	lab var boil_days     "(E2) Days water boiled, past 7 days (0-7 only)"
	lab var boil_any      "(E2) Water boiled on 1+ of past 7 days"
	lab var ran_out       "(E3) Ran out of chlorine tablets, past 30 days"

**## 6.7 Section F: Perceptions & satisfaction

	lab var safe_very "(F1) Rates drinking water as very safe"

**------------------------------------------------------------------------------
**# 7 Child table (Section G)
**------------------------------------------------------------------------------

**## 7.1 Count the children we expect
**------------------------------------------------------------------------------

	* A child slot is filled if any of its three answers is non-missing
	gen n_child_slots = 0
	forvalues i = 1/3 {
		egen filled_`i' = rownonmiss(child_age_`i' diarrhea_2d_`i' diarrhea_7d_`i')
		replace n_child_slots = n_child_slots + (filled_`i' > 0)
		drop filled_`i'
	}
	quietly summarize n_child_slots
	local n_children = r(sum)
	drop n_child_slots

**## 7.2 Reshape to one row per child
**------------------------------------------------------------------------------

	preserve

		keep key child_age_* diarrhea_2d_* diarrhea_7d_*
		reshape long child_age_ diarrhea_2d_ diarrhea_7d_, i(key) j(child_index)
		rename *_ *

		egen filled = rownonmiss(child_age diarrhea_2d diarrhea_7d)
		keep if filled > 0
		drop filled

		isid key child_index, sort
		assert _N == `n_children'

**## 7.3 Construct child indicators
**------------------------------------------------------------------------------

		* G4 (past 7 days) is only asked if G3 (past 48 hours) = No, so
		* "diarrhea in the past 7 days" needs both questions
		gen diarrhea_any7 = 1 if diarrhea_2d == 1 | diarrhea_7d == 1
		replace diarrhea_any7 = 0 if diarrhea_2d == 0 & diarrhea_7d == 0

		* STAND-IN DECISION: Section G covers children under 5 (0-60 months).
		* Ages outside that range are excluded from the indicator.
		replace diarrhea_any7 = . if !inrange(child_age, 0, 60)

		lab val diarrhea_any7 yesno

		lab var key           "Unique submission ID"
		lab var child_index   "Child index (within submission)"
		lab var child_age     "(G2) Child's age, in months"
		lab var diarrhea_any7 "(G3/G4) Child had diarrhea in the past 7 days"

		keep key child_index child_age diarrhea_any7

		tempfile children
		save `children'

	restore

**------------------------------------------------------------------------------
**# 8 Save household analysis data
**------------------------------------------------------------------------------

	keep key hh_id village_id survey_date consented last_week ///
		piped stored_now stored_chlor chlorine_days chlorine_any ///
		boil_days boil_any ran_out safe_very

	order key hh_id village_id survey_date consented last_week

	iesave "${ex_analysis}/household-analysis.dta", ///
		idvars(key) ///
		version(14) ///
		replace

**------------------------------------------------------------------------------
**# 9 Save child analysis data
**------------------------------------------------------------------------------

	* Bring in the household variables the report compares children by.
	* Many children to one household: every child must find its household.
	use `children', clear

	merge m:1 key using "${ex_analysis}/household-analysis.dta", ///
		keepusing(consented last_week chlorine_any) ///
		assert(match using) keep(match) nogen

	isid key child_index, sort
	assert _N == `n_children'

	iesave "${ex_analysis}/child-analysis.dta", ///
		idvars(key child_index) ///
		version(14) ///
		replace

********************************************************************************
