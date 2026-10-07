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

	global code 		"${github}/2-code"
	global data_box		"${box}/1-data"
	global data_git		"${github}/1-data"
	global output 		"${github}/3-output/32-overleaf/321-exhibits"

***************************************************************** End of do-file
