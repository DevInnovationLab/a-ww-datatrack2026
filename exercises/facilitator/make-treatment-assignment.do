/*******************************************************************************
  make-treatment-assignment.do  ·  Village-level treatment assignment

  FACILITATOR ONLY. Builds the (fictional) RCT assignment that
  exercises/2-code/construct.do and analysis.do merge onto the household data.
--------------------------------------------------------------------------------
  Author(s):  DIL Data Team
              Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:    October 2026

  Inputs:     exercises/1-data/household-analysis.dta
                (id: key; 139-household-analysis.dta without main_sample)

  Outputs:    exercises/1-data/village-treatment.dta
                (id: village_id)

  Summary:    The survey was not an RCT, so this script makes one up for
              teaching: it ranks the 12 villages by the share of households
              that treated their water with chlorine (treat_chlorine_any) and
              assigns the 6 villages with the highest take-up to treatment
              (chlorine access). Take-up is therefore higher in treatment
              villages by construction.

  Notes:      The assignment is NOT random, and the "effect" on diarrhea is
              whatever the observational data shows. Don't present it as
              a real estimate. Ties in take-up are broken by village_id, so
              the assignment is the same on every run.
*******************************************************************************/

**------------------------------------------------------------------------------
**# 1 Settings
**------------------------------------------------------------------------------

	version 15
	clear all

	* Set this to your clone of the repository
	global repo "/Users/luizaandrade/Documents/GitHub/a-ww-datatrack2026"
	global data "${repo}/exercises/1-data"

	adopath ++ "${repo}/exercise-solutions/2-code/20-programs/ado"

**------------------------------------------------------------------------------
**# 2 Assign treatment
**------------------------------------------------------------------------------

**## 2.1 Village take-up

	use "${data}/household-analysis.dta", clear

	collapse (mean) takeup = treat_chlorine_any, by(village_id)
	isid village_id

**## 2.2 Top half of villages by take-up are treated

	gsort -takeup village_id
	gen treatment = (_n <= _N / 2)

	lab def treatment 0 "Control" 1 "Treatment"
	lab val treatment treatment
	lab var treatment "Village assigned to chlorine access"

	keep  village_id treatment
	sort  village_id

**------------------------------------------------------------------------------
**# 3 Save
**------------------------------------------------------------------------------

	iesave "${data}/village-treatment.dta", idvars(village_id) version(15) replace

***************************************************************** End of do-file
