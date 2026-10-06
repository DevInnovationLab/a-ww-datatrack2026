/*******************************************************************************
  2131-clean-household.do
--------------------------------------------------------------------------------
  Authors:  DIL Data Team
            David Torres Leon (dtorresleon@uchicago.edu)
            Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:  6 October 2026

  Inputs:   ${data_box}/11-tidy/111-tidy-household.dta
  Outputs:  ${data_box}/12-clean/121-household-clean.dta
            ${data_git}/12-clean/121-household-clean.md  (iesave report)

  Summary:  Keeps consenting submissions only, then brings the household
            table to analysis-ready format without changing any values:
            turns the special missing codes into
            extended missing values, attaches value labels from the form's
            choice lists, adds variable labels from the questionnaire, and
            checks that no special missing codes or unlabeled variables are
            left before saving.

  Notes:    - -999 (Don't know) -> .d and -888 (Declined) -> .r. -666 (Other)
              is a real answer, so it stays as a labeled value.
            - storage_time is hours (0-72), but 99 is a code for "more than
              72 hours" (D6), so it gets a value label.
            - Variable labels and question codes come from
              4-documentation/Household_Water_Questionnaire.md.
            - Non-consenting submissions (39) are dropped: the interview
              ended at B1, so there is nothing to analyse. 3 of them have
              answers after B1 (a skip-pattern violation) and are dropped
              too. Decision: L. Andrade, 7 October 2026.
            - Duplicates, outliers and skip-pattern violations are left as
              they are, for the HFC session.
*******************************************************************************/

	use "${data_box}/11-tidy/111-tidy-household.dta", clear

* (a) Keep consenting submissions only:

	assert _N == 1293
	keep if consent == 1
	assert _N == 1254

* (b) Special codes -> extended missing values, in every numeric variable:

	ds, has(type numeric)
	foreach var of varlist `r(varlist)' {
		quietly recode `var' (-999 = .d) (-888 = .r)
	}

* (c) Value labels. The form's choice lists, defined once:

	lab def yesno       	1    "Yes" ///
							0    "No"
	lab def sex         	1    "Male" ///
							2    "Female"
	lab def educ        	0    "None" ///
							1    "Primary" ///
							2    "Secondary" ///
							3    "Tertiary" 
	lab def watersource  	1    "Piped" ///
							2    "Protected well" ///
							3    "River or stream" ///
	                        4    "Trucked" ///
							-666 "Other" 
	lab def container    	1    "Bucket" ///
							2    "Clay pot" ///
							3    "Jerry can" ///
							-666 "Other"
	lab def safety       	1    "Very safe" ///
							2    "Somewhat safe" ///
							3    "Not safe"   
	lab def satisfaction 	1    "Very satisfied" ///
							2    "Somewhat satisfied" ///
	                        3    "Not satisfied" 
*   storage_time is hours (0-72), but 99 is a CODE: "more than 72 hours"
*   (hint on D6). Labeling it means nobody averages it as 99 hours
	lab def storage      	99 	 "More than 72 hours"

*   Every choice list also needs the two extended missing codes. Rather than
*   typing them into each definition, loop over all labels in memory:

	label dir
	foreach lbl in `r(names)' {
		lab def `lbl' .d "Don't know" .r "Declined to answer", add
	}

	local 	  binary_vars 	consent resp_hh_head stored_yn stored_covered stored_clean ///
							stored_chlorine treat_notablets
	lab val  `binary_vars'	yesno
	
	lab val resp_sex 		   sex
	lab val resp_educ          educ
	lab val hh_watersource     watersource
	lab val stored_container   container
	lab val storage_time       storage
	lab val water_safety       safety
	lab val water_satisfaction satisfaction

* (d) Variable labels: the question number + a short version of the wording.
*     Metadata variables that are not survey questions get no code:

	lab var hh_id            	"A2. Household ID"
	lab var village_id       	"A3. Village"
	lab var starttime        	"Interview start date-time"
	lab var endtime          	"Interview end date-time"
	lab var enumerator       	"Enumerator ID"
	lab var deviceid         	"SurveyCTO device ID"
	lab var submissiondate   	"Date-time the form reached the server"
	lab var consent          	"B1. Consent to interview"
	lab var resp_age         	"C1. Respondent's age (years)"
	lab var resp_sex         	"C2. Respondent's sex"
	lab var resp_hh_head     	"C3. Respondent is household head"
	lab var resp_educ        	"C4. Respondent's education"
	lab var hh_size          	"C5. People living in household"
	lab var hh_children      	"C6. Children under 5 in household"
	lab var hh_watersource   	"C7. Main drinking water source"
	lab var hh_watersource_o 	"C8. Other water source (specify)"
	lab var duration_min     	"Interview duration (minutes)"
	lab var stored_yn          	"D1. Drinking water stored now"
	lab var stored_container   	"D2. Storage container type"
	lab var stored_container_o 	"D3. Other container type (specify)"
	lab var stored_covered     	"D4. Storage container covered"
	lab var stored_clean       	"D5. Container washed with soap, past 7 days"
	lab var storage_time       	"D6. Hours since water was collected"
	lab var stored_chlorine    	"D7. Chlorine added before storing"
	lab var treat_chlorine     	"E1. Days chlorine added, past 7 days"
	lab var treat_boil         	"E2. Days water boiled, past 7 days"
	lab var treat_notablets    	"E3. Ran out of chlorine tablets, past 30 days"
	lab var water_safety       	"F1. Perceived safety of drinking water"
	lab var water_satisfaction 	"F2. Satisfaction with water quality"

* (e) Check: no pre-listed missing codes left in the data. -666 "Other" is a
*     real answer and stays, so only -999 and -888 are checked.

	ds, has(type numeric)
	foreach var of varlist `r(varlist)' {
		assert !inlist(`var', -999, -888)
	}

*     And every variable has a variable label:

	ds, not(varlabel)
	if "`r(varlist)'" != "" {
		di as error "Variables without a label: `r(varlist)'"
		exit 459
	}

	local file "12-clean/121-household-clean"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
        report(path("${data_git}/`file'.md") replace) ///
		replace
		