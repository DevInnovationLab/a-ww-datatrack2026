* analysis.do
* main results for midline report -- FINAL

	cd "/Users/luizaandrade/Documents/GitHub/a-ww-datatrack2026/exercises/1-data"
	use "household-analysis.dta", clear

	merge m:1 village_id using "village-treatment.dta"
	drop _merge

	*keep if village_id < 1300   // district A only -- uncomment for the district report

**** descriptives

	sum treat_chlorine treat_boil hh_size resp_age
	tab treat_chlorine_any treatment, col
	* take-up: 72.3% treatment vs 66.7% control

**** winsorize (winsor2 wasn't working on my laptop so did it by hand)

	foreach v in treat_chlorine treat_boil hh_size resp_age {
		sum `v', detail
		replace `v' = r(p99) if `v' > r(p99)
	}

**** first stage: treatment -> take-up

	eststo: reg treat_chlorine_any treatment, cluster(village_id)
	eststo: reg treat_chlorine_any treatment hh_size treat_boil resp_sex, cluster(village_id)

	esttab using "table1.tex", replace

	* only households with kids under 5
	keep if hh_children > 0

**** ITT: treatment -> diarrhea

	* control mean
	sum diarrhea_week_any if treatment == 0
	tab hh_watersource
	local cmean = r(mean)

	eststo: reg diarrhea_week_any treatment, cluster(village_id)
	eststo: reg diarrhea_week_any treatment hh_size resp_age, cluster(village_id)
	eststo: reghdfe diarrhea_week_any treatment hh_size resp_age hh_watersource treat_boil, absorb(village_id) cluster(village_id)
	eststo: reghdfe diarrhea_week_any treatment hh_size hh_watersource treat_boil stored_covered, absorb(village_id) cluster(village_id)

	esttab using "table2.tex", replace

**** bootstrap CI for chlorine take-up in treatment villages

	bootstrap r(mean), reps(500): sum treat_chlorine_any if treatment == 1

**** figures

	reg diarrhea_week_any treatment treat_boil
	coefplot, drop(_cons) xline(0)

	graph bar diarrhea_week_any, over(treatment)

**** numbers for the report (copied from the log)

	file open nums using "numbers.tex", write replace
	file write nums "\newcommand{\Nhh}{1254}" _n
	file write nums "\newcommand{\takeup}{72.8}" _n
	file write nums "\newcommand{\effect}{-0.03}" _n
	file write nums "\newcommand{\cmean}{`cmean'}" _n
	file close nums

* table2.tex: deleted the constant row by hand in Overleaf
