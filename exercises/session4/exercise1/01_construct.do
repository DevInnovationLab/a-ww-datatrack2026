/*******************************************************************************
  01_construct.do  ·  Village-level indicators for the PI's fieldwork update
--------------------------------------------------------------------------------
  Written by:  an AI assistant, from this prompt:
               "Using households.csv and children.csv, construct three
                village-level indicators for the PI: the share of households
                with a child who had diarrhoea in the past 7 days, the
                average number of days households treated their drinking
                water in the past 7 days, and the average number of hours
                stored water had been kept. Save one row per village."

  Input:       data/households.csv  one row per submission
               data/children.csv    one row per child under 5
  Output:      output/village_indicators.csv  one row per village

  How to run:  Stata must be in the exercise1 folder. Double-click this file
               (Stata then starts in its folder), or type in Stata:
                 cd "/path/to/exercise1"
               then run the whole file (Do).
*******************************************************************************/

	clear all
	version 15
	set more off

	capture confirm file "data/households.csv"
	if _rc {
		display as error `"Stata is not in the exercise1 folder. Type: cd "/path/to/exercise1", then run this file again."'
		exit 601
	}
	capture mkdir "output"

**------------------------------------------------------------------------------
**# 1 Load the data
**------------------------------------------------------------------------------

	import delimited "data/children.csv", clear varnames(1)
	keep hh_id child_no child_age diarrhea_2d diarrhea_7d
	tempfile children
	save `children'

	import delimited "data/households.csv", clear varnames(1)

**------------------------------------------------------------------------------
**# 2 Attach each household's children
**------------------------------------------------------------------------------

	* Every household is kept; households without children get one row with
	* missing child variables.
	joinby hh_id using `children', unmatched(master)
	drop _merge

**------------------------------------------------------------------------------
**# 3 Household-level indicators
**------------------------------------------------------------------------------

	* Days the household treated its water in the past 7 days (E1 + E2)
	egen treat_days = rowtotal(treat_chlorine treat_boil)

	* Children with diarrhoea in the past 7 days (G4); one row per household
	collapse (sum) n_diarrhea = diarrhea_7d ///
		(first) village_id treat_days storage_time, by(key)

	gen hh_diarrhea = n_diarrhea > 0

	summarize hh_diarrhea
	display _n "All villages: " %4.1f 100 * r(mean) ///
		"% of households had a child with diarrhoea in the past 7 days"

**------------------------------------------------------------------------------
**# 4 Village-level indicators
**------------------------------------------------------------------------------

	gen one = 1
	collapse (sum) n_households = one ///
		(mean) pct_hh_diarrhea = hh_diarrhea mean_treat_days = treat_days ///
		mean_storage_hr = storage_time, by(village_id)
	replace pct_hh_diarrhea = 100 * pct_hh_diarrhea
	format pct_hh_diarrhea mean_treat_days mean_storage_hr %5.1f

	list, noobs clean
	export delimited "output/village_indicators.csv", replace
