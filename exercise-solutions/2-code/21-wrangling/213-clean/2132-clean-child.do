/*******************************************************************************
  2132-clean-child.do
--------------------------------------------------------------------------------
  Authors:  DIL Data Team
            David Torres Leon (dtorresleon@uchicago.edu)
            Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:  8 October 2026

  Inputs:   ${data_box}/11-tidy/112-tidy-child.dta
            ${data_box}/12-clean/121-household-clean.dta  (run 2131 first)
  Outputs:  ${data_box}/12-clean/122-child-clean.dta
            ${data_git}/12-clean/122-child-clean.md  (iesave report)

  Summary:  Keeps children of consenting submissions only, then brings the
            child table (Section G, one row per child) to analysis-ready
            format without changing any values: turns the
            special missing codes into extended missing values, attaches the
            Yes/No value label, adds variable labels from the questionnaire,
            and checks that no special missing codes or unlabeled variables
            are left before saving.

  Notes:    - -999 (Don't know) -> .d and -888 (Declined) -> .r, same as the
              household table.
            - The child table keeps key and hh_id from the household. hh_id
              is not unique (some households have two submissions), so merge
              on key; other household variables (village_id, ...) come from
              the household table that way.
            - Variable labels and question codes come from
              4-documentation/Household_Water_Questionnaire.md.
            - Children are kept only if their submission is in the clean
              household data, which has consenting submissions only. 2
              children belong to non-consenting submissions (a skip-pattern
              violation) and are dropped. Decision: L. Andrade, 7 October 2026.
            - G4 is only asked if G3 = No, so diarrhea_7d is blank by design
              for children with diarrhea in the past 48 hours. Skip-pattern
              violations are left as they are, for the HFC session.
*******************************************************************************/

	use "${data_box}/11-tidy/112-tidy-child.dta", clear

* (a) Keep children of consenting submissions only. The clean household data
*     has consenting submissions only, so match on its key:

	assert _N == 1587

	preserve
		use key using "${data_box}/12-clean/121-household-clean.dta", clear
		tempfile consented
		save `consented'
	restore

	merge m:1 key using `consented', keep(master match)
	count if _merge == 1
	assert r(N) == 2
	keep if _merge == 3
	drop _merge
	assert _N == 1585

* (b) Special codes -> extended missing values, in every numeric variable:

	ds, has(type numeric)
	foreach var of varlist `r(varlist)' {
		quietly recode `var' (-999 = .d) (-888 = .r)
	}

* (c) Value labels. The form's choice list, plus the extended missing codes:

	lab def yesno       	1    "Yes" ///
							0    "No", replace

	label dir
	foreach lbl in `r(names)' {
		lab def `lbl' .d "Don't know" .r "Declined to answer", add
	}

	lab val diarrhea_2d diarrhea_7d yesno

* (d) Variable labels: the question number + a short version of the wording.
*     Metadata variables that are not survey questions get no code:

	lab var key              	"SurveyCTO submission ID (unique row ID)"
	lab var hh_id              	"A2. Household ID"
	lab var child_index         "Child number in the roster (G)"
	lab var child_age        	"G2. Child's age (months)"
	lab var diarrhea_2d      	"G3. Diarrhoea in the past 48 hours"
	lab var diarrhea_7d      	"G4. Diarrhoea in the past 7 days"

* (e) Check: no pre-listed missing codes left in the data.

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

	order key child_index hh_id

	local file "12-clean/122-child-clean"
	iesave "${data_box}/`file'.dta", ///
		idvars(key child_index) version(15) ///
		report(path("${data_git}/`file'.md") replace) ///
		replace
