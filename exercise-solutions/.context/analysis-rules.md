
## Analysis code

- Analysis scripts never create or change variables. If a variable is
  missing, add it to the construction script.
- **Check the data dictionary before using a variable.** Don't assume what a
  variable measures from its name or label.
- **Know what you expect from every variable you use**, before using it:
  - unit of measurement (litres per day, rupees, share from 0 to 1)
  - unit of observation (household, person, village) and the ID that
    identifies it
  - which rounds or sources it comes from, and whether it was harmonised
  - missing values: why they're missing (not asked, non-response,
    unmatched) and how they're coded
  - reasonable range (and whether it can be negative or zero)
  If a variable doesn't match what the dictionary says, report it.
- **Assertions belong in wrangling code, not analysis.** Data checks (`isid`,
  values, ranges, missing patterns, merge results, numbers of observations)
  are written as assertions in the wrangling scripts that build the data
  (see `data-construction.md`), so the analysis data is already checked when
  it is saved. Analysis scripts contain no `assert`, `isid`, `confirm` or
  `stopifnot()`. If an analysis needs a check that isn't there, add it to the
  construction script.
- **Research decisions go in the main script.** Control lists and the
  clustering level are defined once, as globals in `main.do` (or objects in
  `main.R`), next to the other user inputs, e.g.
  `global controls hh_size resp_age i.resp_sex` and
  `global cluster village_id`. Every analysis script uses them; never retype
  a control list in an analysis script, and don't move them to a separate
  settings file.
- **Samples are flag variables built in construction**, in the script that
  builds the analysis dataset (e.g. `main_sample` in
  `2149-construct-combine.do`), never in the analysis script. Use them in one
  of two ways:
  - if every exhibit in a script uses the same sample, `keep if main_sample`
    at the top of the script;
  - if different exhibits in a script use different samples, add
    `if <flag>` to each regression, table and graph.
  Never `keep`/`drop`/`filter()` halfway through a script.
- **Exhibit formatting goes in the main script too**: table notes, esttab
  options, graph scheme and export size are globals in `main.do`, used by
  every analysis script. No separate style or settings file.
- Observations with a missing regressor are dropped silently, so N can
  change when a control is added. Build the sample flag so it excludes
  missing outcomes and controls, use it in every column, and report N in
  every table.
- **Categories are not numbers.** Use factor notation for categorical
  variables (Stata: `i.district`; R: `factor(district)`, including
  `haven`-labelled variables), and set the base category on purpose
  (`ib3.district`, `fct_relevel()`). Don't build dummies by hand.
- **Interactions:** keep the main effects. Stata: `i.treat##c.age` (write
  `c.` for continuous variables; `#` alone drops the main effects). R:
  `treat * age`, not `treat:age`.
- **Dropped variables:** read the log after every regression. Collinear
  regressors and absorbed treatment variables are dropped with only a note.
  Check that the coefficient of interest is in every column of the table.
- **Stored results (Stata):** use `r()` and `e()` immediately after the
  command that creates them. Any later command can overwrite them. Run
  `eststo clear` before building a table. In R, don't reuse objects from an
  earlier run.
- Start simple: plain OLS and a few covariates before anything fancier.

## Exploratory reports

- Exploratory results go in a literate document (Quarto or RMarkdown) that
  renders in one command, with the code visible.
- **Never type a result.** Every number in the text must be inline code
  (`` `r nrow(hh)` ``) or a macro written by the code (`\Nhh` in LaTeX).
  Every table and figure must be produced by the code when the document
  renders or the script runs. A number typed by hand, by you or by me, is a
  bug.
- For LaTeX/Overleaf reports: export tables as `.tex`, figures as `.png`,
  and key numbers as LaTeX macros, and include them with `\input{}` and
  `\includegraphics{}`. Never paste results into the `.tex` file.
- Use parameters (e.g. `params: last_week_only`) for sample switches rather
  than editing the code.
- Keep formatting minimal while the analysis is still changing.
- Write the narrative around results if asked, but mark interpretations as
  drafts for the team to review. Don't claim an effect is meaningful, or
  explain a surprising result, without flagging it as a question.

## Research decisions are not yours to make

Don't choose any of the following on your own. List them as open questions,
with the options you see and what each would change:

- definitions of indicators and outcomes
- cut-offs, trimming, winsorizing or top-coding rules, and how outliers are
  defined (the PIs make the final call; see "Imputation and outlier
  treatment")
- how to handle missing values: imputation methods, minimum number of
  components, missing-baseline indicators
- sample restrictions and which observations to drop
- weights and the level an average is taken at
- specifications, controls and fixed effects beyond what was asked
