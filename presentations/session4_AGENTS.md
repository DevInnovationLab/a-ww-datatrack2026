# AGENTS.md — data construction and exploratory analysis

<!--
DRAFT for Data Session 4 (slide 14, "Automating best practices").
Participants copy this file to the root of their project as AGENTS.md
(or CLAUDE.md), then fill in the "About this project" section.
Rules are written for both Stata and R.
-->

## About this project

<!-- Fill in before using. The agent can't guess any of this. -->

- **Research question and main outcomes:** ...
- **Unit of observation of each dataset** and its ID variables (e.g.
  household: `hh_id`; household member: `hh_id` + `member_id`; panel:
  `hh_id` + `round`): ...
- **Expected number of observations** at each unit (from the sampling frame
  or the field reports): ...
- **Survey non-response codes** and what they mean (e.g. -999 "don't know",
  -888 "refused", -666 "other"): ...
- **Units** of key variables (litres, rupees, days, ...): ...
- **Survey rounds and data sources**, and any known differences between
  them (units, codes, question wording): ...
- **Where the data dictionary lives:** ...
- **Where decisions are documented** (pre-analysis plan, decision log): ...
- **Language and main packages:** ...

## How to work

- **Plan before code.** Before writing construction or analysis code, write
  a short plan: the steps, the merge keys and their relationship (1:1, m:1,
  1:m), the units, and the number of observations expected after each step.
  Wait for the plan to be approved before writing the code.
- **Stop and ask** when a task needs a choice these rules and the
  instructions don't cover. Don't guess, and don't pick a "reasonable
  default" silently.
- **Make every change visible.** After each task, report what you changed,
  which checks you added, how many observations were kept or lost at each
  step, and any open questions.
- **Code that runs is not code that's right.** Silent bugs (code that runs
  and returns a plausible wrong number) are the main risk. The rules below
  exist to turn silent bugs into errors.

## Data handling

- Raw data is read-only. Never edit, overwrite or save over files in the raw
  data folder. Write outputs to a separate folder.
- Never print, display or copy individual records (names, IDs, phone
  numbers, GPS coordinates, free-text answers) into the conversation, into
  code comments or into reports. Use `describe`/`codebook`/`str()`, counts
  and summary statistics instead. Don't report counts of fewer than 5
  observations for a subgroup defined by personal characteristics.
- Never save over the analysis dataset from an analysis script.

## Build checks into the code

- Write checks as assertions that stop the code when they fail (Stata:
  `assert`, `isid`, `confirm`; R: `stopifnot()`, `assertthat::assert_that()`),
  not as output someone has to read.
- Assert the expected number of observations after every merge, append,
  collapse, reshape and `keep`/`drop`/`filter()`. Use the numbers from the
  plan, not the number the code happens to produce.
- Assert that the ID variables uniquely identify observations at the
  expected unit (Stata: `isid hh_id`; R:
  `stopifnot(!anyDuplicated(df[c("hh_id", "round")]))`).
- Assert a plausible range for every constructed numeric variable, in its
  units, ignoring missing values (Stata:
  `assert inrange(water_lpd, 0, 500) if !missing(water_lpd)`).
- If a check fails, never loosen it, comment it out or delete it to make
  the code run. Report the failure, what caused it, and how many
  observations are affected.

## Data construction

### Never change observed data

- Never overwrite or `replace` a variable that came from the survey or
  another source. Create a new variable and keep the original next to it.
- Construction is the only step where values change. Cleaning code changes
  format only, and analysis code never creates or changes variables.
- Never drop observations unless explicitly instructed. If a step drops
  observations (`keep if`, `drop if`, an inner join, `filter()`,
  `drop_na()`), say so, and report how many are lost and why.

### Missing values and non-response codes

- Before any calculation, recode the survey's non-response codes to missing.
  In Stata, use extended missing values (`.d`, `.r`, ...) so the reason is
  kept (`mvdecode` or `recode`); in R, use `NA` (`na_if()`), and keep a
  separate variable with the reason if it matters. Then assert that no
  non-response codes are left in the variables used.
- Never impute missing values, fill them with zeros, or drop observations
  with missing information, unless you have been given both an explicit
  instruction to do so and the method to use. If missing values affect a
  result, report how many there are and ask how to handle them.
- Missing is not zero. A question that wasn't asked, an unmatched
  observation or an empty group must stay missing unless the instructions
  say it means zero.
- Handle missing values explicitly in every condition:
  - Stata treats missing as larger than any number, so `keep if x > 6`
    keeps missing values, and `gen d = (x == 1)` sets missing to 0. Write
    `if x > 6 & !missing(x)` and `gen d = (x == 1) if !missing(x)`.
  - R's `filter(x > 6)` drops missing values silently, and base R's
    `df[df$x > 6, ]` adds all-`NA` rows. Decide on missing values explicitly
    (`filter(x > 6 | is.na(x))`, or count them first).

### Merges and joins

- Before merging, check that the key uniquely identifies observations in
  every dataset where it should be unique (`isid`, `distinct()`/`count()`),
  and declare the relationship (1:1, m:1 or 1:m). In R, use
  `relationship = "one-to-one"` / `"many-to-one"` / `"one-to-many"`.
- **Never use Stata's `merge m:m`.** It pairs rows arbitrarily. If every
  pairing is really needed, use `joinby` and say so; otherwise fix the key.
- Standardise key formats before merging (same type, no leading zeros lost,
  no trailing spaces, same capitalisation).
- Rename or drop variables that exist in both datasets (other than the key)
  before merging, so values aren't silently overwritten or duplicated
  (`.x`/`.y` in R). Keep only the variables you need.
- After merging, report how many observations matched and how many didn't
  on each side, and assert the expected result (e.g. `assert _merge == 3`, or
  the expected count for each `_merge` value; in R, count with
  `anti_join()`). Never drop unmatched observations without reporting them.

### Sums, means and other aggregates

- Before summing or averaging, check that all inputs are in the same unit.
  Convert to one unit first, never after, and assert a plausible range on
  both the inputs and the result.
- Check how questionnaire items nest before adding them, so a total isn't
  summed together with its own sub-items.
- Make the handling of missing values explicit, and record it in the
  variable label or the data dictionary:
  - Stata's `egen rowtotal()` and `collapse (sum)` treat missing values as
    zero, so an all-missing total becomes 0. Use `rowtotal(..., missing)`
    if an all-missing total should be missing.
  - Stata's `egen rowmean()` and `collapse (mean)`, and R's
    `mean(x, na.rm = TRUE)`, average only the non-missing values.
  - R's `sum()` and `mean()` return `NA` if any value is missing, unless
    `na.rm = TRUE`, which treats missing parts of a sum as zero.
  - Don't add `na.rm = TRUE` or `rowtotal()` by default. Ask what rule to
    use: require all components, require a minimum number, or impute.
- For every sum or mean, create or report the number of non-missing values
  it is based on (Stata: `egen n_water = rownonmiss(water_*)`,
  `collapse (count)`; R: `rowSums(!is.na(across(...)))`, `sum(!is.na(x))`).
- Don't trim, winsorize or top-code without a rule you've been given. See
  "Imputation and outlier treatment" below.

### Imputation and outlier treatment

The method for imputing values and for treating outliers is a research
decision. The PIs make the final call and review the result. Your job is to
make the decision easy to review, not to make it.

- Only impute or treat outliers when you've been given an explicit
  instruction and a method. If you think either is needed, propose options
  and ask.
- Make every decision explicit, in the code and in the documentation. That
  includes which variables are treated, how an outlier is defined (e.g.
  above the 99th percentile, more than 3 SD from the mean, outside a
  plausible range), whether cut-offs are computed on the full sample or
  within groups (e.g. by district or treatment arm), which values are
  imputed (missing, non-response codes, outliers), the imputation method
  and the variables it uses, and the random seed if the method is random.
- Store each choice once, as a named parameter in the settings file (e.g.
  `global winsor_pct 99`), not as a number typed in the code.
- Never overwrite the original variable. Create a new one (e.g.
  `water_lpd_w99`, `income_imp`), and create a flag for every observation
  whose value was changed (e.g. `water_lpd_w99_flag`, `income_imp_flag`).
- Document the treatment in the variable label (e.g. "winsorized at p99")
  and in the data dictionary: the method, the parameters, the date, who
  approved it, and how many observations were changed.
- Compare the distribution of every new variable with the original, and put
  the comparison in the report for the PIs to review:
  - the number and share of observations changed, overall and by treatment
    arm (a treatment that changes one arm more than the other can bias the
    estimate)
  - summary statistics (N, mean, SD, min, p1, p50, p99, max) for the
    original and the new variable, side by side
  - a figure overlaying both distributions (histogram or density)
- Assert that only the flagged observations changed (Stata:
  `assert water_lpd_w99 == water_lpd if !water_lpd_w99_flag`).
- Keep the untreated variable available so results can be checked with and
  without the treatment.

### Collapses and reshapes

- Before collapsing, check which variables should be constant within each
  group, and assert it (Stata: `bysort village_id: assert x == x[1]`; R:
  `n_distinct(x) == 1` within `group_by()`).
- Groups with no observations disappear after a collapse. Start from the
  full list of units (e.g. the sampling frame) and join the aggregates onto
  it, so empty units stay visible (R: `complete()`).
- Decide explicitly whether an empty group means missing or zero. If the
  instructions don't say, ask.
- Say whose average an indicator represents (households, people, villages)
  and weight on purpose. A mean of household means is not a mean across
  people. Don't choose weights on your own.
- Before reshaping, assert that ID × time (or ID × item) is unique. After
  reshaping, assert the expected number of observations and count the new
  missing cells.

### Combining rounds and datasets

Different rounds or data sources often record the same variable
differently: in different units (litres vs gallons, rupees vs thousands of
rupees), with different codes or category lists, or under different names.
Appending or merging them without harmonising gives a silently wrong
variable.

- Before appending or merging rounds, compare each variable across them:
  name, type, unit, value labels and codes, and the range of values. Check
  the questionnaires and the data dictionary for changes between rounds.
  Report every difference you find.
- Harmonise in construction, before combining: convert to one unit, map
  codes and categories to one list, and use one name per variable. Never
  harmonise in analysis code.
- Keep a variable that records the round or source of every observation.
- After combining, compare the distribution of each harmonised variable by
  round (N, mean, min, max). A round sitting a fixed multiple above the
  others is a unit problem.
- Record every harmonisation in the data dictionary: the original unit or
  coding in each round, and the conversion applied.
- If you can't tell which unit or coding a round uses, ask. Don't infer it
  from the values.

### Lags and panel variables

- Build one numeric time variable (e.g. survey round) in construction. Don't
  lag on text dates, and don't mix rounds with calendar dates.
- Assert that ID × time is unique before creating a lag.
- Lag within each unit and on time, not on row order. Stata: `xtset hh_id
  round`, then `L.x` (never `x[_n-1]` without `bysort hh_id (round):`). R:
  `group_by(hh_id) %>% arrange(round) %>% mutate(x_lag = lag(x))`, and check
  that the gap in time is 1.
- Assert that the lag is missing in each unit's first period.
- Report how many observations have a missing lag. Don't impute them, add
  missing-baseline indicators or restrict the sample without an instruction.
- Check that "lagged" or baseline controls were measured before treatment
  started.

### Labels and documentation

- Use descriptive variable names, and keep related variables together.
- Label every constructed variable with its unit and any transformation
  (trimming, winsorizing, normalisation, how missing values were handled).
- Add every new variable to the data dictionary: name, definition, unit,
  source variables, and how missing values are handled.
- Write code comments that explain *why*, not *what*. Leave the decisions
  (why a definition was chosen, when, by whom) as questions or placeholders
  for the team to fill in. Don't invent a rationale.

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
