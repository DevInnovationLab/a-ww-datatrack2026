/*******************************************************************************
  2132-clean-child.do
--------------------------------------------------------------------------------
  Authors:  DIL Data Team
            David Torres Leon (dtorresleon@uchicago.edu)
            Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:  6 October 2026

  Inputs:   ${data_box}/11-tidy/112-tidy-child.dta
  Outputs:  ${data_box}/12-clean/122-child-clean.dta
            ${data_git}/12-clean/122-child-clean.md  (iesave report)

  Summary:  Brings the child table (Section G, one row per child) to
            analysis-ready format without changing any values: turns the
            special missing codes into extended missing values, attaches the
            Yes/No value label, adds variable labels from the questionnaire,
            and checks that no special missing codes or unlabeled variables
            are left before saving.

  Notes:    - -999 (Don't know) -> .d and -888 (Declined) -> .r, same as the
              household table.
            - hh_id, village_id and enumerator are carried over from the
              household table by 212-tidy.do, so they are labeled here too
              (same labels as 2131-clean-household.do).
            - Variable labels and question codes come from
              4-documentation/Household_Water_Questionnaire.docx.
            - G4 is only asked if G3 = No, so diarrhea_7d is blank by design
              for children with diarrhea in the past 48 hours. Skip-pattern
              violations are left as they are, for the HFC session.
*******************************************************************************/

	use "${data_box}/11-tidy/112-tidy-child.dta", clear

* (a) Special codes -> extended missing values, in every numeric variable:

	ds, has(type numeric)
	foreach var of varlist `r(varlist)' {
		quietly recode `var' (-999 = .d) (-888 = .r)
	}

* (b) Value labels. The form's choice list, plus the extended missing codes:

	lab def yesno       	1    "Yes" ///
							0    "No", replace

	label dir
	foreach lbl in `r(names)' {
		lab def `lbl' .d "Don't know" .r "Declined to answer", add
	}

	lab val diarrhea_2d diarrhea_7d yesno

* (c) Variable labels: the question number + a short version of the wording.
*     Metadata variables that are not survey questions get no code:

	lab var key              	"SurveyCTO submission ID (unique row ID)"
	lab var child_index         "Child number in the roster (G)"
	lab var hh_id            	"A2. Household ID"
	lab var village_id       	"A3. Village"
	lab var enumerator       	"Enumerator ID"
	lab var child_age        	"G2. Child's age (months)"
	lab var diarrhea_2d      	"G3. Diarrhoea in the past 48 hours"
	lab var diarrhea_7d      	"G4. Diarrhoea in the past 7 days"

* (d) Check: no pre-listed missing codes left in the data.

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

	local file "12-clean/122-child-clean"
	iesave "${data_box}/`file'.dta", ///
		idvars(key child_index) version(15) ///
		report(path("${data_git}/`file'.md") replace) ///
		replace
