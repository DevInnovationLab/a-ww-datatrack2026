/*******************************************************************************
  Table 1: effect of treatment on take-up
--------------------------------------------------------------------------------
  Author(s):  DIL Data Team
              Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:    October 2026

  Inputs:     ${data_box}/13-construct/139-household-analysis.dta
                (id: key)

  Outputs:    ${output}/3211-tables/table1-first-stage.tex
              ${output}/3213-numbers/numbers-first-stage.tex

  Summary:    First stage: regresses chlorine take-up (treated water with
              chlorine on at least 1 of the past 7 days) on village
              assignment to chlorine access, without and with controls, on
              the main analysis sample. Exports the table and the numbers the
              text cites as LaTeX macros.

  Notes:      Controls, clustering and exhibit formatting (table notes,
              esttab and graph options) are set in main.do (${controls},
              ${cluster}). The sample is main_sample, built in
              2149-construct-combine.do, the same as Table 2's, so the first
              stage and the ITT describe the same households.

*******************************************************************************/

**------------------------------------------------------------------------------
**# 1 Load the data
**------------------------------------------------------------------------------

*   One row per consenting household. Treatment, the main_sample flag and all
*   data checks come from 2149-construct-combine.do.

	use "${data_box}/13-construct/139-household-analysis.dta", clear
	keep if main_sample

**------------------------------------------------------------------------------
**# 2 Estimate
**------------------------------------------------------------------------------

	eststo clear

	sum treat_chlorine_any if treatment == 0
	local cmean = r(mean)

**## 2.1 No controls

	eststo fs1: reg treat_chlorine_any treatment, cluster(${cluster})
	estadd scalar cmean = `cmean'
	estadd local  controls "No"

**## 2.2 With controls

	eststo fs2: reg treat_chlorine_any treatment ${controls}, cluster(${cluster})
	estadd scalar cmean = `cmean'
	estadd local  controls "Yes"

	* Numbers for the text: main specification (with controls)
	local effect = _b[treatment]

**------------------------------------------------------------------------------
**# 3 Export
**------------------------------------------------------------------------------

**## 3.1 Table

	local outcome_label : var label treat_chlorine_any

	esttab fs1 fs2 using "${output}/3211-tables/table1-first-stage.tex", ///
		${esttab_style} mgroups("`outcome_label'", ${mgroups_style}) replace

**## 3.2 Numbers cited in the text

	local n_main         = strofreal(_N, "%9.0fc")
	local takeup_control = strofreal(`cmean'  * 100, "%9.1f")
	local takeup_effect  = strofreal(`effect' * 100, "%9.1f")

	file open  nums using "${output}/3213-numbers/numbers-first-stage.tex", write replace
	file write nums "\newcommand{\Nmain}{`n_main'}" _n
	file write nums "\newcommand{\takeupControl}{`takeup_control'}" _n
	file write nums "\newcommand{\takeupEffect}{`takeup_effect'}" _n
	file close nums

***************************************************************** End of do-file
