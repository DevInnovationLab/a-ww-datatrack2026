/*******************************************************************************
         Publication: Reports & Replicability - DIL Welcome Week Session 5
             EXERCISE · Results that update themselves in Overleaf
                                  main.do
********************************************************************************

  Author(s): DIL Data Team
             Nandita Gupta (nanditag@uchicago.edu)

  Updated:   October 2026
  Version:   Stata 15

  Summary:   Stata version of the Session 5 Overleaf exercise (the R version
             is R/main.R). Reads the clean data in data/ and writes every
             result the PI update in overleaf/ quotes -- a table (.tex), a figure (.png) and the numbers in the
             text (numbers.tex) -- into your Overleaf project's local GitHub
             clone. Push, pull in Overleaf, recompile: nobody retypes a
             number. Instructions are in README.txt in the exercise folder.

             Set the two paths in section 2 and run. The user-written
             command it needs (ieboilstart) is in stata/ado/.

  Outline:   1. Select parts of the code to run
             2. Set file paths
             3. Initial settings
             4. Run code
                4.1 2-export-outputs.do  Write table, figure, numbers
*******************************************************************************/

**------------------------------------------------------------------------------
**# 1 Select parts of the code to run
**------------------------------------------------------------------------------

	local export    1

	* THE SWITCH. 0 = all fieldwork days; 1 = the last 7 days of fieldwork.
	* Run once with 0, then change it to 1 (step 5 of README.txt).
	global last_week_only 0

**------------------------------------------------------------------------------
**# 2 Set file paths
**------------------------------------------------------------------------------

* Your two paths ----------------------------------------------------------------

	* Type 'di c(username)' to see the name of your machine.
	*   ex           : this exercise folder (overleaf_exercise/), wherever you saved it
	*   report_clone : your local clone of the GitHub repository synced with
	*                  your Overleaf project. Leave it empty to write to the
	*                  overleaf/ folder in the exercise folder.

	global report_clone ""

	// Nandita
	if "`c(username)'" == "admin" {
		global ex           "/Users/admin/Desktop/DIL/a-ww-datatrack2026/exercises/overleaf_exercise"
		global report_clone "/Users/admin/Desktop/DIL/ww-datatrack-gitoverleaf"
	}

	// YOU
	else if "`c(username)'" == "" {
		global ex           ""
		global report_clone ""
	}

* Subfolders -------------------------------------------------------------------

	global ex_code     "${ex}/stata/code"
	global ex_data     "${ex}/data"

* The Overleaf report -----------------------------------------------------------

	* Where the exported files land: your Overleaf clone if you set one
	* above, otherwise the overleaf/ folder in the exercise folder
	global report      "${ex}/overleaf"
	if "${report_clone}" != "" global report "${report_clone}"

	confirm file "${report}/main.tex"

**------------------------------------------------------------------------------
**# 3 Initial settings
**------------------------------------------------------------------------------

	* Find the user-written command (ieboilstart) shipped in stata/ado/
	sysdir set  PLUS "${ex}/stata/ado"
	adopath ++  PLUS
	adopath ++  BASE

	* Set initial configurations as much as allowed by Stata version
	ieboilstart, v(15.0)
	`r(version)'

	* Folders the code writes to
	cap mkdir "${report}/tables"
	cap mkdir "${report}/figures"

**------------------------------------------------------------------------------
**# 4 Run code
**------------------------------------------------------------------------------

**## 4.1 Export outputs
/*------------------------------------------------------------------------------
    Writes every result the PI update quotes, for the sample chosen by
    $last_week_only.

  Inputs:   data/households_clean.csv
            data/children_clean.csv
  Outputs:  ${report}/tables/numbers.tex
            ${report}/tables/tab1-water-practices.tex
            ${report}/figures/fig1-chlorination-village.png
------------------------------------------------------------------------------*/

	if `export' do "${ex_code}/2-export-outputs.do"

********************************************************************************
