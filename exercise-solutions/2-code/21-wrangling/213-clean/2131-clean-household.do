/*******************************************************************************
  ANSWER KEY · 03-clean-label.do  (facilitators only)
--------------------------------------------------------------------------------
  Summary:  Right shape is not right format. Three jobs here:
              (a) special codes become labeled missing values
                  -999 Don't know  ->  .d        -888 Declined  ->  .r
                  (-666 Other is a real answer: it STAYS, with a label)
              (b) value labels, from the form's choices sheet
              (c) variable labels, from the questionnaire (01_documentation)
            Remember the one rule: representation changes, values don't.

  Reads/writes:  02_data/02_clean/households.dta  and  children.dta
*******************************************************************************/

	use "${data_box}/11-tidy/111-tidy-household.dta", clear

* (a) Special codes -> extended missing values. One variable done for you:

	tab resp_educ, missing
	replace resp_educ = .d if resp_educ == -999
	replace resp_educ = .r if resp_educ == -888
	tab resp_educ, missing

	* YOUR TURN 1 (answer)
	ds, has(type numeric)
	foreach v of varlist `r(varlist)' {
		quietly replace `v' = .d if `v' == -999
		quietly replace `v' = .r if `v' == -888
	}
	* --- (original stub kept below for reference) ---
	* -999 and -888 can appear in any question, so loop over all of them.
	* ds stores the list of numeric variables in r(varlist).
	*
	* Replace the ___ and remove the * at the start of each line:
	*
	*   ds, has(type numeric)
	*   foreach v of varlist `r(varlist)' {
	*       quietly replace `v' = .d if `v' == ___
	*       quietly replace `v' = .r if `v' == ___
	*   }
	*
	* Look at resp_educ and water_safety afterwards: the export has -999 in
	* both, but the form only lists -888 for them. A code with no label is
	* a cleaning finding -- note it, don't hide it.

* (b) Value labels. The form's choice lists, defined once:

	label define yesno        1 "Yes" 0 "No"                                  ///
	                          .d "Don't know" .r "Declined to answer"
	label define sex          1 "Male" 2 "Female"                             ///
	                          .d "Don't know" .r "Declined to answer"
	label define educ         0 "None" 1 "Primary" 2 "Secondary" 3 "Tertiary" ///
	                          .d "Don't know" .r "Declined to answer"
	label define watersource  1 "Piped" 2 "Protected well" 3 "River or stream" ///
	                          4 "Trucked" -666 "Other"                         ///
	                          .d "Don't know" .r "Declined to answer"
	label define container    1 "Bucket" 2 "Clay pot" 3 "Jerry can" -666 "Other"
	label define safety       1 "Very safe" 2 "Somewhat safe" 3 "Not safe"    ///
	                          .d "Don't know" .r "Declined to answer"
	label define satisfaction 1 "Very satisfied" 2 "Somewhat satisfied"       ///
	                          3 "Not satisfied"                                ///
	                          .d "Don't know" .r "Declined to answer"
	label define storage      99 "More than 72 hours"

*   storage_time is hours (0-72), but 99 is a CODE: "more than 72 hours"
*   (hint on D6). Labeling it means nobody averages it as 99 hours.

	label values consent  yesno
	label values resp_sex sex

	* YOUR TURN 2 (answer)
	label values resp_hh_head stored_yn stored_covered stored_clean ///
	             stored_chlorine treat_notablets yesno
	label values resp_educ          educ
	label values hh_watersource     watersource
	label values stored_container   container
	label values storage_time       storage
	label values water_safety       safety
	label values water_satisfaction satisfaction
	* --- (original stub kept below for reference) ---
	* label values accepts several variables at once.
	*
	*   label values resp_hh_head stored_yn stored_covered stored_clean ///
	*                stored_chlorine treat_notablets  ___
	*   label values resp_educ          ___
	*   label values hh_watersource     ___
	*   label values stored_container   ___
	*   label values storage_time       ___
	*   label values water_safety       ___
	*   label values water_satisfaction ___

* (c) Variable labels: the question number + a short version of the wording.
*     Sections A to C done for you:

	label variable hh_id            "A2. Household ID"
	label variable village_id       "A3. Village"
	label variable enumerator       "Enumerator ID"
	label variable consent          "B1. Consent to interview"
	label variable resp_age         "C1. Respondent's age (years)"
	label variable resp_sex         "C2. Respondent's sex"
	label variable resp_hh_head     "C3. Respondent is household head"
	label variable resp_educ        "C4. Respondent's education"
	label variable hh_size          "C5. People living in household"
	label variable hh_children      "C6. Children under 5 in household"
	label variable hh_watersource   "C7. Main drinking water source"
	label variable hh_watersource_o "C8. Other water source (specify)"
	label variable duration_min     "Interview duration (minutes)"

	* YOUR TURN 3 (answer; any faithful short wording is fine)
	label variable stored_yn          "D1. Drinking water stored now"
	label variable stored_container   "D2. Storage container type"
	label variable stored_container_o "D3. Other container type (specify)"
	label variable stored_covered     "D4. Storage container covered"
	label variable stored_clean       "D5. Container washed with soap, past 7 days"
	label variable storage_time       "D6. Hours since water was collected"
	label variable stored_chlorine    "D7. Chlorine added before storing"
	label variable treat_chlorine     "E1. Days chlorine added, past 7 days"
	label variable treat_boil         "E2. Days water boiled, past 7 days"
	label variable treat_notablets    "E3. Ran out of chlorine tablets, past 30 days"
	label variable water_safety       "F1. Perceived safety of drinking water"
	label variable water_satisfaction "F2. Satisfaction with water quality"
	* --- (original stub kept below for reference) ---
	* Open the questionnaire in 01_documentation and write a label for each:
	*
	*   label variable stored_yn          "D1. ___"
	*   label variable stored_container   "D2. ___"
	*   label variable stored_container_o "D3. ___"
	*   label variable stored_covered     "D4. ___"
	*   label variable stored_clean       "D5. ___"
	*   label variable storage_time       "D6. ___"
	*   label variable stored_chlorine    "D7. ___"
	*   label variable treat_chlorine     "E1. ___"
	*   label variable treat_boil         "E2. ___"
	*   label variable treat_notablets    "E3. ___"
	*   label variable water_safety       "F1. ___"
	*   label variable water_satisfaction "F2. ___"

* (d) Efficient storage types. compress never changes a value.

	local file "12-clean/121-household-clean"
	iesave "${data_box}/`file'.dta", ///
		idvars(key) version(15) ///
        report(path("${data_box}/`file'.md") replace) ///
		replace
	

