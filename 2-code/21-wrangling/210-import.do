/*******************************************************************************
  00-import.do  ·  Tidying exercise                         [COMPLETE - read it]
--------------------------------------------------------------------------------
  Summary:  The raw SurveyCTO export of household_water_v1, exactly as
            downloaded. This file turns it into a working .dta: every column
            imported as text first, then each type declared on purpose.
            Read what each block fixes -- this is the unglamorous 80%.

  Reads:    02_data/01_raw/household_water_questionnaire__v1.csv
  Writes:   02_data/00_pii/00_imported_with_pii.dta
            (it still has names, phone and GPS, so it goes to the restricted
             folder, never to 02_clean)
*******************************************************************************/

**# 0. Import everything as TEXT -----------------------------------------------

*   Never let Stata guess types on a raw export:
*   long numbers lose digits, and a phone number like +25672458591 becomes
*   2.57e+10. Declare the encoding too, so accents survive.

	import delimited "${data_box}/10-raw/100-raw-identified/household_water_questionnaire__v1.csv", clear varnames(1) ///
		stringcols(_all) bindquote(strict) encoding("utf-8")

	describe, short
	rename *, lower
	
**# 1. Check ID

*	You might expect hh_id to identify rows -- try it:

	capture isid hh_id
	if _rc {
		di as error "hh_id is NOT unique -- look:"
		duplicates report hh_id
	}

*    Some households were submitted twice. That is a CONTENT question, and
*    tomorrow's HFC session will investigate which visit is real.
*    Today we drop nothing. We just need a row ID, and SurveyCTO already
*    gives us one: key, the unique ID of every submission.

	//isid  key
	label variable key "SurveyCTO submission ID (unique row ID)"
	label variable submissiondate "Date-time the form reached the server"


**# 2. Declare the numeric variables -------------------------------------------
 
*	These are the form's integer and
*   select_one fields: SurveyCTO exports the CODES (1, 0, -666, -888, -999),
*   not the answer text. Labels come in 03.
*   Text fields (key, enumerator, deviceid, devicephonenum, the "other,
*   specify" answers, child names, comments) stay as strings.

	destring duration_min hh_id village_id consent                          ///
		resp_age resp_sex resp_hh_head resp_educ hh_size hh_children         ///
		hh_watersource stored_yn stored_container stored_covered stored_clean ///
		storage_time stored_chlorine treat_chlorine treat_boil treat_notablets ///
		water_safety water_satisfaction                                      ///
		child_age_* diarrhea_2d_* diarrhea_7d_*, replace

**# 3. Dates and times ---------------------------------------------------------

* 	SurveyCTO writes them as text: "Jul 12, 2026 4:04:50 AM".
*   clock() with the mask "MDYhms" reads them; %tc displays them.

	foreach v in submissiondate starttime endtime {
		gen		`v'_tc = clock(`v', "MDYhms")
		assert !missing(`v'_tc) if !missing(`v')
		format 	`v'_tc %tcCCYY-NN-DD_HH:MM:SS
		drop 	`v'
		rename 	`v'_tc `v'
	}

	gen 	survey_date = dofc(starttime)
	format 	survey_date %tdCCYY-NN-DD
	lab var	survey_date "Date of interview (from starttime)"

**# 4. GPS ---------------------------------------------------------------------
* 	A geopoint arrives as ONE text column with four numbers:
*   "latitude longitude altitude accuracy". Split it into four numeric
*   columns. (They are identifiers: 01 moves them to the crosswalk.)

	split gps, parse(" ") generate(gps_) destring
	rename (gps_1 gps_2 gps_3 gps_4) ///
	       (gps_latitude gps_longitude gps_altitude gps_accuracy)
	drop gps

**# 5. Add metadata to the file itself -----------------------------------------

	order key hh_id village_id survey_date enumerator
	
	label data "Household Water Questionnaire V1 - imported, WITH PII"
	notes: Source: SurveyCTO export of form household_water_v1
	notes: Imported on ${today}. One row = one submission. ID: key.

**# 6. Save data and metadata --------------------------------------------------

	local file "10-raw/100-raw-identified/1000-household-raw-pii"
	
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
        report(path("${data_box}/`file'.md") replace) ///
		replace
	
***************************************************************** End of do-file
