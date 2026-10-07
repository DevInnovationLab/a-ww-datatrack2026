/*******************************************************************************
  session4_exercise1_solution.do  ·  Construction bug hunt: SOLUTION
--------------------------------------------------------------------------------
  FACILITATORS ONLY. Not part of the participant folder.
  Run with Stata in exercises/session4/exercise1/ (cd there first).

  The five bugs in 01_construct.do / 01_construct.R (slide 13), each with
  the assertion that stops the original script and the fix:
   1. Joined on hh_id, which isn't unique (6 hh_ids have two submissions)
   2. Skipped question read as missing: G4 is only asked if G3 = No
   3. Households without children become 0 instead of missing
   4. Chlorine + boiling days added up: can exceed 7 (and non-consenting
      households become 0 days with rowtotal)
   5. "More than 72 hours" (code 99) averaged as 99 hours

  Expected: households with a child with diarrhoea, past 7 days
            original script 15.9% (all 1,293 submissions in the denominator)
            corrected      35.8% of the 938 consenting households with children
*******************************************************************************/

	clear all
	version 15
	set more off
	confirm file "data/households.csv"

**# Children ------------------------------------------------------------------
	import delimited "data/children.csv", clear varnames(1)
	isid key child_no
	local n_children = _N                                // 1,587

	* Bug 2: G4 was skipped when G3 = Yes; construct the 7-day answer
	gen diarrhea_7d_all = diarrhea_7d
	replace diarrhea_7d_all = 1 if diarrhea_2d == 1
	assert !missing(diarrhea_7d_all)                     // 165 were missing before

	* Bug 3: one row per household, with the number of children
	gen one = 1
	collapse (sum) n_children = one n_diarrhea = diarrhea_7d_all, by(key)
	tempfile child_hh
	save `child_hh'

**# Households ----------------------------------------------------------------
	import delimited "data/households.csv", clear varnames(1)

	* Bug 1: the original joined on hh_id. The check that stops it:
	*   isid hh_id          -> fails: 6 hh_ids have two submissions
	isid key

	merge 1:1 key using `child_hh'
	assert _merge != 2                                   // every child's household is here
	drop _merge
	quietly summarize n_children
	assert r(sum) == `n_children'                        // no child lost or duplicated

	* The analysis sample. Note: 2 children belong to households coded as not
	* consenting (a data question for the HFC session); they drop out here.
	keep if consent == 1

	* Bug 3: no children = missing, not "no diarrhoea"
	gen hh_diarrhea = n_diarrhea > 0 if n_children > 0 & !missing(n_children)
	assert missing(hh_diarrhea) if missing(n_children)

	* Bug 4: E1 + E2 can't be added. The check that stops the original:
	*   assert inrange(treat_chlorine + treat_boil, 0, 7) if !missing(treat_chlorine, treat_boil)
	* -> fails for 383 households. The overlap can't be recovered, so the fix
	*    is a different indicator (a research decision):
	gen treated_any = treat_chlorine > 0 | treat_boil > 0 if !missing(treat_chlorine, treat_boil)

	* Bug 5: 99 = "more than 72 hours" is a code. The check that stops the original:
	*   assert storage_time <= 72 if !missing(storage_time)
	* -> fails for the 70 households coded 99 (plus 250 and 400, outside the
	*    questionnaire's range: for the HFC session). New indicator instead:
	gen stored_over_24h = storage_time > 24 if !missing(storage_time)

	summarize hh_diarrhea
	display _n "All villages: " %4.1f 100 * r(mean) "% of the " r(N) ///
		" households with children had a child with diarrhoea in the past 7 days"

**# Villages ------------------------------------------------------------------
	gen hh = 1
	collapse (sum) n_households = hh (count) n_hh_with_children = hh_diarrhea ///
		(mean) pct_hh_diarrhea = hh_diarrhea pct_treated_any = treated_any ///
		pct_stored_over_24h = stored_over_24h, by(village_id)
	foreach v of varlist pct_* {
		replace `v' = 100 * `v'
	}
	format pct_* %5.1f
	list, noobs clean
