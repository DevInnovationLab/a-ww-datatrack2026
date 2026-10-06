
## Analysis code

- Analysis scripts never create or change variables. If a variable is
  missing, add it to the construction script.
- **Check the data dictionary before using a variable.** Don't assume what a
  variable measures from its name or label.
- **State what you expect from every variable you use**, before using it,
  and check it in the code:
  - unit of measurement (litres per day, rupees, share from 0 to 1)
  - unit of observation (household, person, village) and the ID that
    identifies it
  - which rounds or sources it comes from, and whether it was harmonised
  - missing values: how many you expect, why they're missing (not asked,
    non-response, unmatched), and how they're coded
  - reasonable range (and whether it can be negative or zero)
  Write these as assertions at the top of the analysis script (N, missing
  count, range, `isid`), and report any variable that doesn't match what
  the dictionary says.
- **One source of truth.** Define samples, outcomes and control lists once,
  in one settings file that every script loads (a globals `.do` file or a
  sourced `.R` file). Never retype a control list or a sample condition in a
  second script.
- **Define the estimation sample once**, at the top of the script, as a
  flag variable. Never `keep`/`drop`/`filter()` halfway through a script;
  use `if` conditions or `preserve`/`restore`.
- Observations with a missing regressor are dropped silently, so N can
  change when a control is added. Assert N in every model, or use the same
  sample flag in every column and report N.
- **Categories are not numbers.** Use factor notation for categorical
  variables (Stata: `i.district`; R: `factor(district)`, including
  `haven`-labelled variables), and set the base category on purpose
  (`ib3.district`, `fct_relevel()`). Don't build dummies by hand.
- **Interactions:** keep the main effects. Stata: `i.treat##c.age` (write
  `c.` for continuous variables; `#` alone drops the main effects). R:
  `treat * age`, not `treat:age`.
- **Dropped variables:** read the log after every regression. Collinear
  regressors and absorbed treatment variables are dropped with only a note.
  Assert that the coefficient of interest exists.
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
