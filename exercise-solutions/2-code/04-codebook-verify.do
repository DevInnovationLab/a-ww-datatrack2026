/*******************************************************************************
  04-codebook-verify.do  ·  Tidying exercise                [COMPLETE - run it]
--------------------------------------------------------------------------------
  Summary:  The archivist's job, automated: a codebook in excel, one sheet
            per table, one row per variable. Then the HFC-READINESS CHECK.
            If every check passes, your tables are the input for
            tomorrow's High-Frequency Checks (Data Session 3).
*******************************************************************************/

	local old_varabbrev = c(varabbrev)
	set varabbrev off

* --- Codebook: name, type, labels and share missing, one row per variable ---

	cap program drop codebook_sheet
	program define codebook_sheet
		args sheet mode
		local N = _N
		tempname h
		tempfile miss
		postfile `h' str32 variable double pct_missing using `miss'
		foreach v of varlist _all {
			quietly count if missing(`v')
			post `h' ("`v'") (round(100 * r(N) / `N', 0.1))
		}
		postclose `h'
		describe, replace clear
		keep position name type vallab varlab
		rename (name type vallab varlab) ///
		       (variable storage_type value_label variable_label)
		merge 1:1 variable using `miss', nogenerate
		sort position
		drop position
		export excel using "${codebook_excel}", sheet("`sheet'") ///
			firstrow(variables) `mode'
	end

	use "${data_clean}/households.dta", clear
	codebook_sheet households replace
	use "${data_clean}/children.dta", clear
	codebook_sheet children sheetreplace

* --- HFC-READINESS CHECK ---

	local pass = 1

	use "${data_clean}/households.dta", clear

	* 1) Every submission is still there (yes, the duplicates too)
	quietly count
	if r(N) != 1293 {
		di as error "FAIL: expected 1,293 household rows, found `r(N)'"
		local pass = 0
	}

	* 2) One row per submission
	capture isid key
	if _rc {
		di as error "FAIL: key no longer identifies rows"
		local pass = 0
	}

	* 3) No PII left behind
	foreach v in child_name_1 child_name_2 child_name_3 devicephonenum ///
	             gps gps_latitude gps_longitude {
		capture confirm variable `v'
		if !_rc {
			di as error "FAIL: `v' is still in the household file"
			local pass = 0
		}
	}

	* 4) Dates are dates
	capture confirm numeric variable starttime
	if _rc {
		di as error "FAIL: starttime is not a date-time"
		local pass = 0
	}

	* 5) No -999 / -888 codes left in numeric variables
	quietly ds, has(type numeric)
	foreach v of varlist `r(varlist)' {
		quietly count if inlist(`v', -999, -888)
		if r(N) > 0 {
			di as error "FAIL: `v' still has -999 or -888 codes"
			local pass = 0
		}
	}

	* 6) Value labels attached
	foreach v in consent resp_sex resp_hh_head resp_educ hh_watersource ///
	             stored_yn stored_container storage_time water_safety water_satisfaction {
		local lab : value label `v'
		if "`lab'" == "" {
			di as error "FAIL: `v' has no value label"
			local pass = 0
		}
	}

	* 7) Variable labels for Sections D, E and F
	foreach v in stored_yn stored_container stored_covered stored_clean ///
	             storage_time stored_chlorine treat_chlorine treat_boil ///
	             treat_notablets water_safety water_satisfaction {
		local lab : variable label `v'
		if "`lab'" == "" | strpos("`lab'", "___") {
			di as error "FAIL: `v' has no variable label"
			local pass = 0
		}
	}

	* 8) The children table exists, has one row per child, and is labeled
	capture use "${data_clean}/children.dta", clear
	if _rc {
		di as error "FAIL: children.dta not found -- did 02 run?"
		local pass = 0
	}
	else {
		capture isid key child_no
		if _rc {
			di as error "FAIL: children.dta is not unique on key + child_no"
			local pass = 0
		}
		quietly count
		if r(N) != 1587 {
			di as error "FAIL: expected 1,587 child rows, found `r(N)'"
			local pass = 0
		}
	}

	set varabbrev `old_varabbrev'

* Verdict

	if `pass' {
		di as result _n "  =============================================="
		di as result    "   ALL CHECKS PASSED -- READY FOR TOMORROW'S HFCs"
		di as result    "   (yes, the duplicates and outliers are still in"
		di as result    "    there. That's the point. See you tomorrow.)    "
		di as result    "  =============================================="
	}
	else {
		di as error _n "  Some checks failed -- fix the do-file that owns them and re-run MASTER."
	}
