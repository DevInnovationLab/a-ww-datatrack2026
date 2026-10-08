/*******************************************************************************
  2492-itt.do  ·  Table 2 and Figure 1: ITT effect on diarrhea
--------------------------------------------------------------------------------
  Author(s):  DIL Data Team
              Luiza Andrade (luizaandrade@uchicago.edu)
  Updated:    October 2026

  Inputs:     ${data_box}/13-construct/139-household-analysis.dta
                (id: key)

  Outputs:    ${output}/3211-tables/table2-itt.tex
              ${output}/3212-figures/figure1-itt.png
              ${output}/3213-numbers/numbers-itt.tex

  Summary:    Intention-to-treat: regresses whether any child under 5 in the
              household had diarrhea in the past 7 days on village assignment
              to chlorine access, without and with controls, on the main
              analysis sample. The table and the figure are both built from
              the same two stored models, so they cannot disagree. Exports the
              numbers the text cites as LaTeX macros.

  Notes:      Controls, clustering and exhibit formatting (table notes,
              esttab and graph options) are set in main.do (${controls},
              ${cluster}). The sample is main_sample, built in
              2149-construct-combine.do, the same as Table 1's.

              No village fixed effects: treatment is assigned by village, so
              they would absorb it.

              Two households report children under 5 (C6) but have no child
              records, so their diarrhea outcome is missing and they are not
              in main_sample. The contradiction is kept in the data for the
              HFC session.

              The treatment assignment is NOT from a real RCT (see
              2149-construct-combine.do). Results are illustrative only.
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

	sum diarrhea_week_any if treatment == 0
	local cmean = r(mean)

**## 2.1 No controls

	eststo itt1: reg diarrhea_week_any treatment, cluster(${cluster})
	estadd scalar cmean = `cmean'
	estadd local  controls "No"

**## 2.2 With controls

	eststo itt2: reg diarrhea_week_any treatment ${controls}, cluster(${cluster})
	estadd scalar cmean = `cmean'
	estadd local  controls "Yes"

	* Numbers for the text: main specification (with controls)
	local effect = _b[treatment]
	local se     = _se[treatment]

**------------------------------------------------------------------------------
**# 3 Export
**------------------------------------------------------------------------------

**## 3.1 Table

	local outcome_label : var label diarrhea_week_any

	esttab itt1 itt2 using "${output}/3211-tables/table2-itt.tex", ///
		${esttab_style} mgroups("`outcome_label'", ${mgroups_style}) replace

**## 3.2 Figure: the same two models as the table

	coefplot (itt1, label("No controls")) (itt2, label("With controls")), ///
		keep(treatment) xline(0) levels(95)                              ///
		coeflabels(treatment = "Chlorine access")                        ///
		xtitle("Effect on share of households with a child with diarrhea," "past 7 days (95% CI)") ///
		note("${note_sample}" "Standard errors clustered by village (12 clusters).", size(vsmall))

	graph export "${output}/3212-figures/figure1-itt.png", ${graph_export_opts}

**## 3.3 Numbers cited in the text

	local diarrhea_control = strofreal(`cmean'  * 100, "%9.1f")
	local itt_effect       = strofreal(`effect' * 100, "%9.1f")
	local itt_se           = strofreal(`se'     * 100, "%9.1f")

	file open  nums using "${output}/3213-numbers/numbers-itt.tex", write replace
	file write nums "\newcommand{\diarrheaControl}{`diarrhea_control'}" _n
	file write nums "\newcommand{\ittEffect}{`itt_effect'}" _n
	file write nums "\newcommand{\ittSE}{`itt_se'}" _n
	file close nums

***************************************************************** End of do-file
