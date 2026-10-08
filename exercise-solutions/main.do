/*******************************************************************************
						DIL Welcome Week India 2026
                           Data track main script
********************************************************************************

  Authors:   DIL Data Team
             David Torres Leon (dtorresleon@uchicago.edu)
			 Luiza Andrade (luizaandrade@uchicago.edu)

  Updated:   October 2026
  Version:   Stata 15

*******************************************************************************/
**#  I. User inputs
********************************************************************************

**------------------------------------------------------------------------------
**## File paths
**------------------------------------------------------------------------------

	if "`c(username)'" == "luizaandrade" {
		global github 	"/Users/luizaandrade/Documents/GitHub/a-ww-datatrack2026/exercise-solutions"
		global box		"/Users/luizaandrade/Library/CloudStorage/Box-Box/a-ww-datatrack2026"
	}

	global code 			"${github}/2-code"
	global data_box			"${box}/1-data"
	global data_git			"${github}/1-data"
	global output 			"${github}/3-output/32-overleaf/321-exhibits"

	* Exhibit folders (figures are not tracked in git, so theirs may not exist)
	foreach folder in 3211-tables 3212-figures 3213-numbers {
		cap mkdir "${output}/`folder'"
	}

**------------------------------------------------------------------------------
**## Research decisions 
**------------------------------------------------------------------------------

	global controls 		hh_size resp_age i.resp_sex
	global cluster 			village_id
	
**------------------------------------------------------------------------------
**## Sections to run 
**------------------------------------------------------------------------------

	local import 		1
	local deidentify	1
	local tidy			1
	local clean			1
	local construct		1
	local analysis		1
	

**------------------------------------------------------------------------------
**## Style
**------------------------------------------------------------------------------

**### Tables

	global note_sample  "Sample includes households with at least one child under 5."
	global note_design  "Treatment assigned at the village level."
	global note_se      "Standard errors clustered by village in parentheses; with 12 clusters they may understate uncertainty."
	global note_ctrl    "Models control for household size, respondent age and respondent sex."
	global note_stars   "* p<0.10, ** p<0.05, *** p<0.01."

	global esttab_style ///
		keep(treatment) label booktabs nomtitles collabels(none) ///
		b(%9.3f) se(%9.3f) star(* 0.10 ** 0.05 *** 0.01) nonotes ///
		stats(controls cmean N N_clust, ///
			labels("Controls" "Control mean" "Observations" "Villages") ///
			fmt(%s %9.3f %9.0fc %9.0f)) ///
		addnotes("${note_sample}" "${note_design}" "${note_se}" "${note_ctrl}" "${note_stars}")

	* Outcome label as one header across all columns: esttab ..., mgroups("label", ${mgroups_style})
	global mgroups_style ///
		pattern(1 0) span prefix(\multicolumn{@span}{c}{) suffix(}) erepeat(\cmidrule(lr){@span})

**### Graphs

	set scheme s1mono
	global graph_export_opts "width(1600) replace"

	
********************************************************************************	
**#  II. Run do-files
********************************************************************************

	 ieboilstart , versionnumber(15.1) adopath("${code}/20-programs/ado", strict) noclear
    `r(version)'
	
	if `import' 	do "${code}/21-wrangling/210-import.do"
	if `deidentify' do "${code}/21-wrangling/211-deidentify.do"
	if `tidy' 		do "${code}/21-wrangling/212-tidy.do"
	if `clean' 		do "${code}/21-wrangling/213-clean/2131-clean-household.do"
	if `clean' 		do "${code}/21-wrangling/213-clean/2132-clean-child.do"
	if `construct' 	do "${code}/21-wrangling/214-construct/2141-construct-household.do"
	if `construct' 	do "${code}/21-wrangling/214-construct/2142-construct-child.do"
	if `construct' 	do "${code}/21-wrangling/214-construct/2149-construct-combine.do"

	* 2491-first-stage.do: Table 1, effect of treatment on chlorine take-up
	*   Inputs:  139-household-analysis.dta
	*   Outputs: table1-first-stage.tex, numbers-first-stage.tex
	if `analysis' 	do "${code}/24-analysis/249-main/2491-first-stage.do"

	* 2492-itt.do: Table 2 and Figure 1, ITT effect of treatment on child diarrhea
	*   Inputs:  139-household-analysis.dta
	*   Outputs: table2-itt.tex, figure1-itt.png, numbers-itt.tex
	if `analysis' 	do "${code}/24-analysis/249-main/2492-itt.do"

***************************************************************** End of do-file
