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

**## Users ---------------------------------------------------------------------

	if "`c(username)'" == "luizaandrade" {
		global github 	"/Users/luizaandrade/Documents/GitHub/a-ww-datatrack2026/exercise-solutions"
		global box		"/Users/luizaandrade/Library/CloudStorage/Box-Box/a-ww-datatrack2026"
	}

**## Subfolders -------------------------------------------------------------

	global code 			"${github}/2-code"
	global data_box			"${box}/1-data"
	global data_git			"${github}/1-data"
	global output 			"${github}/3-output/32-overleaf/321-exhibits"
	
**## Sections to run -----------------------------------------------------------

	local import 		1
	local deidentify	1
	local tidy			1
	local clean			1
	local construct		0
	
********************************************************************************	
**#  II. Run do-files
********************************************************************************

**## Stata session ----------------------------------------------------------

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

***************************************************************** End of do-file
àÞ
