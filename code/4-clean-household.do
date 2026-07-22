/*******************************************************************************
  4-clean-household.do  ·  Harmonize, encode, and label household data
--------------------------------------------------------------------------------
  Author(s):  DIL Data Team
              David Torres Leon (dtorresleon@uchicago.edu)
              Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:    July 2026

  Inputs:     data/tidy/household-tidy.dta

  Outputs:    data/clean/household-clean.dta    (id: key)
              data/raw/household.md             (iesave report)
              documentation/data-dictionaries/household-clean.xlsx
                                                 (iecodebook mini-codebook)

  Summary:    Right shape is not right format. 

              A few jobs here:
                - Save each column in the most efficient format
                - Translate survey code (e.g. don't know = missing)
                - Document (label) information
                - Harmozine categories
                - Export a data dictionary

              Remember the one rule: representation changes, values don't.

  Notes:      -666/-888/-999 are this survey's sentinel codes for "Don't
              know"/"Refused"/"Other"; they are recoded to Stata's extended
              missing values (.o/.r/.k) rather than dropped, so they stay
              analyzable as missing without being mistaken for real answers

              Section 6 variable labels use the question wording and section/
              question codes (e.g. C6) from the SurveyCTO form in
              documentation/Household Water Questionnaire - V1.xlsx.
*******************************************************************************/

**------------------------------------------------------------------------------
**# 1 Fix variable formats
**------------------------------------------------------------------------------

	use "${data_tidy}/household-tidy.dta", clear

**## 1.1 IDs
**------------------------------------------------------------------------------

	* IDs stay as strings. This will prevent Stata from rounding or changing the
	* format in ways that would decharacterize it -- e.g. by removing leading zeroes

**## 1.2 Categorical variables are turned into labelled values
**------------------------------------------------------------------------------

**## 1.3 Dates
**------------------------------------------------------------------------------

	local date_vars submissiondate starttime endtime

**## 1.4 GPS (requires identified data)
**------------------------------------------------------------------------------

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

	recode `num_vars' 	(-666 = .o) ///
						(-888 = .r) ///
						(-999 = .k)

**------------------------------------------------------------------------------
**# 4 Label categories (extracted from survey form)
**------------------------------------------------------------------------------

	local dummy_vars consent resp_hh_head stored_yn stored_clean ///
		stored_chlorine treat_notablets stored_covered

	lab def yesno 		1 "Yes" ///
						0 "No"
						
	lab def sex 		1 "Male" ///
						2 "Female"

	lab def educ 		0 "None" ///
						1 "Primary" ///
						2 "Secondary" ///
						3 "Tertiary"
						
	lab def source 		1 "Piped" ///
						2 "Protected well" ///
						3 "River or stream" ///
						4 "Trucked"

	lab def container 	1 "Bucket" ///
						2 "Clay pot" ///
						3 "Jerry can"

	lab def safe 		3 "Very safe" ///
						2 "Somewhat safe" ///
						1 "Not safe"

	lab def satisfied 	3 "Very satisfied" ///
						2 "Somewhat satisfied" ///
						1 "Not satisfied"

	label dir
	local labels `r(names)'

	foreach lbl of local labels {
		label define `lbl' 	.d "Don't know" ///
							.r "Refused" ///
							.o "Other", ///
			add
	}

**------------------------------------------------------------------------------
**# 5 Recategorize other values
**------------------------------------------------------------------------------

	* Water storage type
	tab 	stored_container_o
	replace stored_container = 	4 if stored_container_o == "Plastic drum"
	lab def container 			4 "Plastic drum", add
	drop 	stored_container_o

**------------------------------------------------------------------------------
**# 6 Label variables
**------------------------------------------------------------------------------

**## 6.1 Metadata

	lab var key            "Unique submission ID"
	lab var submissiondate "Date and time of submission"
	lab var enumerator     "Enumerator ID"
	lab var deviceid       "Data collection device ID"
	lab var starttime      "Interview start time"
	lab var endtime        "Interview end time"
	lab var duration_min   "Survey duration in minutes"

**## 6.2 Section A: Identification

	lab var hh_id      		"(A1) Household ID"
	lab var village_id 		"(A2) Community/village name"

**## 6.3 Section B: Consent

	lab var consent 		"(B1) Respondent consents to the interview"

**## 6.4 Section C: Respondent & household roster

	lab var resp_age       "(C1) Respondent's age, in years"
	lab var resp_sex       "(C2) Respondent's sex"
	lab var resp_hh_head   "(C3) Respondent is head of household"
	lab var resp_educ      "(C4) Respondent's highest level of education"
	lab var hh_size        "(C5) Number of people living in the household"
	lab var hh_children    "(C6) Number of children under 5 in the household"
	lab var hh_watersource "(C7) Primary source of drinking water"

**## 6.5 Section D: Household water storage

	lab var stored_yn        "(D1) Household has drinking water stored now"
	lab var stored_container "(D2) Type of container used to store water"
	lab var stored_covered   "(D3) Storage container was covered"
	lab var stored_clean     "(D4) Container washed with soap in past 7 days"
	lab var storage_time     "(D5) Hours since the stored water was collected"
	lab var stored_chlorine  "(D6) Chlorine added to water before storing"

**## 6.6 Section E: Water treatment practices

	lab var treat_chlorine  "(E1) Days in past 7 chlorine added to drinking water"
	lab var treat_boil      "(E2) Days in past 7 drinking water was boiled"
	lab var treat_notablets "(E3) Household ran out of chlorine tablets in past 30 days"

**## 6.7 Section F: Perceptions & satisfaction

	lab var water_safety       "(F1) Respondent's rating of drinking water safety"
	lab var water_satisfaction "(F2) Respondent's satisfaction with water quality"

**## 6.8 Section H: Enumerator observations

	lab var enum_comments "(H1) Enumerator comments about the interview"

**------------------------------------------------------------------------------
**# 7 Save and export codebook
**------------------------------------------------------------------------------

********************************************************************************
