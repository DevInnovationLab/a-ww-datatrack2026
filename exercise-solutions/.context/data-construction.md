# AGENTS.md — data construction and exploratory analysis


## About this project

<!-- Fill in before using. The agent can't guess any of this. -->

- **Research question and main outcomes:** ...
- **Unit of observation of each dataset** and its ID variables (e.g.
  household: `hh_id`; household member: `hh_id` + `member_id`; panel:
  `hh_id` + `round`): ...
- **Where the data dictionaries live:** ...
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
- Only interact with the data locally, through the statistical software.
  Never read the data yourself.

## Build checks into the code

- Write checks as assertions that stop the code when they fail (Stata:
  `assert`, `isid`, `confirm`; R: `stopifnot()`, `assertthat::assert_that()`),
  not as output someone has to read.
- Assert the expected number of observations after every merge, append,
  collapse, reshape and `keep`/`drop`/`filter()`. Use the numbers from the
  plan, not the number the code happens to produce.
- Assert that the ID variables uniquely identify observations at the
  expected unit (Stata: `isid hh_id`; R:
  `pointblank::rows_distinct` and `pointblank::rows_complete`).
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

- Never impute missing values, fill them with zeros, or drop observations
  with missing information, unless you have been given both an explicit
  instruction to do so and the method to use. If missing values affect a
  result, report how many there are and ask how to handle them.
- Missing is not zero. A question that wasn't asked, an unmatched
  observation or an empty group must stay missing unless the instructions
  say it means zero.
- Handle missing values explicitly in every condition. Stata treats missing 
  as larger than any number, so `keep if x > 6` keeps missing values, and 
  `gen d = (x == 1)` sets missing to 0. Write `if x > 6 & !missing(x)` and 
  `gen d = (x == 1) if !missing(x)`.

### Merges and joins

- Before merging, check that the key uniquely identifies observations in
  every dataset where it should be unique (`isid`, `distinct()`/`count()`),
  and declare the relationship (1:1, m:1 or 1:m). In R, use
  `relationship = "one-to-one"` / `"many-to-one"` / `"one-to-many"`.
- **Never use Stata's `merge m:m`.** It pairs rows arbitrarily. If every
  pairing is really needed, use `joinby` and say so; otherwise fix the key.
- Before merging, count how many units are in each dataset, and how many
  you expect to match. If the counts or the relationship are not what you
  expected (e.g. a key that should be unique isn't, or some units have no
  match), stop and flag it to the user. Don't fix it on your own.
- If the user confirms that some mismatches are correct (e.g. households
  that moved away have no endline record), add assertions that check that
  observations are unmatched only in those expected cases (e.g.
  `assert moved_away == 1 if _merge == 1`), so any new mismatch stops the
  code.
- Flag cases of variables that exist in both datasets (other than the key)
  before merging to the user, and ask how to address it so values aren't 
  silently overwritten or duplicated (`.x`/`.y` in R).
- After merging, report how many observations matched and how many didn't
  on each side, and assert the expected result (e.g. `assert _merge == 3`, or
  the expected count for each `_merge` value; in R, count with
  `anti_join()`). Never drop unmatched observations without checking with
  the user first.

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
- Document the treatment in the variable label (e.g. "winsorized at p99")
  and in the data dictionary: the method, the parameters, the date, who
  approved it, how the decision was made, and how many observations were changed.
- Compare the distribution of every new variable with the original, and put
  the comparison in the report for the PIs to review:
  - the number and share of observations changed, overall and by treatment
    arm (a treatment that changes one arm more than the other can bias the
    estimate)
  - summary statistics (N, mean, SD, min, p1, p50, p99, max) for the
    original and the new variable, side by side
  - a figure overlaying both distributions (histogram or density)
- Keep the untreated variable available so results can be checked with and
  without the treatment.

### Collapses/summarizes and reshapes

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
