/*******************************************************************************
  
*******************************************************************************/

**# 0. Import everything as TEXT -----------------------------------------------

*   Import as text so Stata doesn't guess types on a raw export
*   Declare the encoding too, in case there are special characters

	import delimited "${data_box}/10-raw/100-raw-identified/household_water_questionnaire__v1.csv", clear ///
		varnames(1) stringcols(_all) bindquote(strict) encoding("utf-8")

* 	Standardize variable names

	rename *, lower
	
**# 1. Check ID ----------------------------------------------------------------

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

	isid	key
	lab var	key 			"SurveyCTO submission ID (unique row ID)"
	lab var submissiondate 	"Date-time the form reached the server"


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


**# 4. Add metadata to the file itself -----------------------------------------

	order key hh_id village_id survey_date enumerator
	
	label data "Household Water Questionnaire V1 - imported, WITH PII"
	notes: Source: SurveyCTO export of form household_water_v1
	notes: Imported on ${today}. One row = one submission. ID: key.

**# 5. Save data and metadata --------------------------------------------------

	missings dropvars, force
	
	local file "10-raw/100-raw-identified/1000-household-raw-pii"
	
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
        report(path("${data_git}/`file'.md") replace) ///
		replace
	
***************************************************************** End of do-file
