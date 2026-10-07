# Data Session 4 — Data analysis: construction & exploration

**Slide content, 75-minute session** (slides add up to 74 minutes) · follows `session4_session5_split_plan.md`

- **Header on every slide:** DATA ANALYSIS: CONSTRUCTION & EXPLORATION
- **Footer:** Development Innovation Lab / University of Chicago · Data analysis: Construction & Exploration
- **Convention:** slide text is kept short; detail, examples and code live in the notes.

## To-dos

- [ ] **Luiza: review and test the Exercise 1 packet** (`exercises/session4/exercise1/`, built by Nandita from your slide 12–13 notes). Please check: (1) the five bugs in `01_construct.do` / `01_construct.R` are the ones you intended and read as plausible AI-written code; (2) run the Stata versions (the buggy script and `exercises/facilitator/session4_exercise1_solution.do`): only the R versions were run (15.9% → 35.8%); (3) `data/households.csv` and `data/children.csv` are exported from your clean data (`121-household-clean.dta`, `122-clean-child.dta`) with the columns the exercise needs: add any you want participants to see; (4) `codebook.txt` and `README.txt` wording, and whether the README gives too much or too little away; (5) two children belong to households coded as not consenting: keep for the HFC session or fix in the clean data?
- [ ] **Review the exercises and harmonize them with other sessions.** Use the same dataset, variable names and file structure as the rest of the course. Check that Exercise 2's report is what Session 5 expects as its starting point, and that the Quarto steps don't repeat Session 5's reporting exercise.
- [ ] **Add an example of exploratory analysis results previously shared with MK.** A real, anonymized update would fit the "Before you share it" slide or the Slack examples in section 04.
- [ ] Write the silent-bug story for "Why this session" (placeholder)
- [ ] **Check presenter notes that don't match the expected time.** At about 130 spoken words a minute, these notes are too long for their slide: 14 Best practices (278 words, 1 min), 11 Creating lags (318, 2 min), 10 Aggregating values (361, 2.5 min), 21–22 Common errors (about 330 each, 2.5 min), 15 Automating best practices (132, 1 min), 9 Changing units of observation (277, 2.5 min), 17 Some opinionated advice (225, 2 min). Trim the notes or give the slides more time.
- [x] **Review the draft agents file** ([`session4_AGENTS.md`](session4_AGENTS.md)) for "Automating best practices" (slide 15). Decide whether to pre-fill "About this project" for the course data, and put a copy in the exercise folders.
- [x] **Review the "Imputation and outlier treatment" rules** in [`session4_AGENTS.md`](session4_AGENTS.md). Check that the documentation and distribution-comparison steps are what we want RAs to hand the PIs, and decide whether this point also belongs on a slide (e.g. "Best practices" or the aggregating slide, where trimming comes up).
- [x] **Review the new "Combining rounds and datasets" and "state what you expect from every variable" rules** in [`session4_AGENTS.md`](session4_AGENTS.md), and the matching speaker notes on slides 10 and 21. Decide whether either point should go on the slides themselves (e.g. a row in the slide 10 table, or a line on "Best practices").
- [x] Upload `session4_AGENTS.md` to the skills repo
- [x] Fix the stray text box on "Best practices"

---

## Slide 1 — Title · 1 min

# Data analysis: construction & exploration

Luiza Andrade – Data Lead
Nandita Gupta – Predoctoral Fellow
David Torres Leon – Data Manager 

> **Notes:** Laptops open. The exercise folders (`exercise1/`, `exercise2/`) should already be on everyone's machine.

---

## Slide 2 — Why we're here · 2 min 

**Where did the missing values go?**

> **Notes:**
> - **Nandita:** the team knew from comments in the field that there were many students missing some fields, so they decided to do some exploration of these observations. When they tried to do that, though, the missing values were gone.

---

## Slide 3 — Why we're here · 2 min 

**These days, writing code is the easy part of our jobs. With AI, it's easier than ever.**

So your value is everything the code can't do:
- Knowing what the data *should* look like
- Deciding what to show
- Showing your work so your PI can give feedback
- Judging whether you believe a number
- Explaining it to your PI

> **Notes:**
> - **The motivation:** when it comes to coding, analysis is the easy part, and AI now writes that code in seconds. That doesn't make the RA's job smaller. It moves the value to the parts that need human judgement, and we have to get better at them. Every principle today is one of those parts:
>   - **Knowing what the data should look like** → the danger zone and the construction checks (section 01)
>   - **Deciding what to show** → exploratory reports, where content matters more than form (section 02)
>   - **Showing your work so your PI can give feedback** → an exploratory report that is easy to update and puts exhibits, text and code in one place, so the PI can comment on the results and check the code if needed (section 02)
>   - **Catching what runs but is wrong** → silent bugs in analysis code (section 03)
>   - **Judging and explaining results** → from result to PI (section 04)

---

## Slide 4 — By the end of this session, you'll be able to… · 1 min

- Spot where construction goes wrong: joins, unit changes, aggregation, lags
- Write code that stops loudly when the data isn't what you expect
- Build an exploratory report that's easy to update: exhibits, text and code in one place, so your PI can see what you did, give feedback on the results, and check the code if needed
- Avoid silent errors in analysis code
- Judge results before you share them, and keep your PIs informed

---

## Slide 5 — Section divider

**01 · Constructing indicators**
~27 minutes, including Exercise 1

---

## Slide 6 — Data construction · 2 min

**Inputs**
- A clean, tidy dataset
- Documentation of issues found in data validation

**Objective**
- Unit of observation → unit of analysis
- Observed measurements → meaningful economic indicators

**Outputs**
- **Constructed data:** original data plus every indicator, with definitions
- **Analysis data:** only what the analysis uses, one dataset per unit of analysis

> **Notes:**
> - The objective is a dataset useful for both analytics and research design.
> - **Constructed data** can be one or more data tables. It keeps all of the original data alongside the constructed variables, and comes with documentation of how each indicator is defined.
> - **Analysis data** is minimal: only information actually used in the final analysis. In practice, keep a construction script open alongside your analysis script and add new variables as needed.
> - Most of the time, final datasets will not be fully "tidy": you need exactly one final dataset for each distinct unit of analysis, and these may still contain merged information from other units of observation.
> - The analysis data is the replication standard: the exact dataset most journals require, and what you share with PIs so they can replicate your results directly.

---

## Slide 7 — This is the danger zone · 2 min

> **The worst bug is the silent one.**

**Map out dangerous steps**
- Joining data tables
- Changing units of observation
- Aggregating values
- Creating lags

**Anticipate what can go wrong**
- Are values in the same unit?
- How are missing values treated?
- How do tables link?
- How many observations should you have?

**Explain what you are doing**
- Define the indicator
- Write the plan before the code
- **Look** at your data
- Sense-check the results

> **Notes:**
> - Open with the principle at the top: it's the thread for the whole session. Code that crashes tells you something is wrong. Code that runs and returns a plausible wrong number tells you nothing, so it ends up in the report. Every step on this slide fails silently, and every check today (assertions, expected N, plausible ranges) turns a silent bug into a loud one.
> - **Write the plan before the code:** the steps, the merge keys and their structure (1:1, m:1), the units, and the N you expect after each step. Give the plan to your AI assistant, or ask it for a plan and review that before any code is written. The expected Ns become the assertions.
> - "Sense-check" includes exploring summary statistics of every constructed variable.
> - The next four slides take one dangerous step each. Exercise 1 comes right after them and plants at least one bug for each, so tell the room to pay attention.

---

## Slide 8 — Joining data tables: what can go wrong · 2 min

- Dropping rows unintentionally
- Adding rows unintentionally
- Combining non-harmonized surveys
- Mismatched rows
- Overwritten values

**Always have a unique ID. Write down the expected relationship and the expected number of observations after joining N. Check mismatched observations -- if they are correct, take that into account when predicting your result. Check column names before joining.**

NEVER USE `merge m:m`

> **Notes:**
> - A wrong join doesn't throw an error. It gives you a different dataset.
> - **Stata users: never use `merge m:m`.** It doesn't check the keys. It pairs rows within each key in whatever order they happen to be sorted, so matches are arbitrary and can change between runs. Stata's own manual says it is almost never what you want. If you need every pairing, use `joinby`. Otherwise, fix the key so the merge is 1:1, m:1 or 1:m.
> - **AI makes these mistakes too, and confidently:** assistants routinely write joins with no declared relationship and no check on N. When AI writes a join, ask it for the uniqueness check and the expected N, or add them yourself.
> - Links back to "Write the plan before the code" on slide 7, and to the join bug in Exercise 1.

---

## Slide 9 — Changing units of observation: what can go wrong · 2.5 min

- Missings and zeroes get confused
- Implicit weighing
- Creating missings columns or extra rows

**Write down the expected number of units. Then assert it. Use all of a command's options**

> **Notes:**
> - Collapsing, aggregating and reshaping change what one row means. Nothing warns you when that goes wrong.
> - **Units disappear:** groups with no observations simply don't appear after a collapse, so a village where no one was surveyed vanishes instead of showing up as empty. Compare the count against a known total, like the sampling frame. Start from the full list of units and join the aggregates onto it, so empty units stay visible.
> - **Missing and zero get confused:** a sum over all-missing values returns 0 in both Stata (`collapse (sum)`) and R (`sum(x, na.rm = TRUE)`), and a mean over no observations returns missing. So a true zero can become missing, and a missing can become zero. Count the non-missing observations alongside every aggregate, and code the empty-group case yourself.
> - **The average changes meaning:** a mean of household means is not the mean across individuals, and a village average weights every village equally regardless of size. Decide whose average the indicator represents (households, people, villages), and weight explicitly.
> - **Reshapes misalign:** duplicated ID × time pairs make a reshape fail or pick arbitrary rows, and unbalanced panels produce new missing cells when going wide. Check that the ID × time pairs are unique first, and count the new missing values afterwards.
> - Also write down what an empty group should mean (missing or zero) before collapsing. This is where Exercise 1's "false zeros" bug lives.
> - **AI makes these mistakes too:** AI-written collapses almost never keep empty units or count non-missing observations, and they pick weights by default. Check both before you accept the code.

---

## Slide 10 — Aggregating values: what can go wrong · 2.5 min

- Aggregating different units
- Including legacy survey codes
- Double counting of nested observations
- Treatment of missing values

| Consequence | How to tell | The fix |
|---|---|---|
| **Units get mixed** | A cluster far above the rest | Convert to one unit first |
| **Codes count as values** | Negative or impossible values | Recode missing codes first |
| **Missing parts are ignored** | Totals too low for some | Count components answered |
| **Outliers drive the total** | A few units dominate | Trimming rule in construction |
| **Items are counted twice** | Implausibly high totals | Check how items nest |

**Check every input's unit and range. Then check the result is plausible.**

> **Notes:**
> - A sum or a mean always returns a number. That doesn't make it the right one.
> - **Units get mixed:** values recorded in different units (liters vs gallons, rupees vs thousands of rupees, days vs weeks) are summed as if they were the same thing. There's no error and no missing value, just a silently wrong number. A group of observations sitting a fixed multiple above the rest is the tell. Convert every observation to one unit before aggregating, never after, and assert a plausible range.
> - **Units change between rounds:** a common version of the same bug. Different rounds or data sources record the same variable in different units, codes or names (e.g. baseline in litres, endline in gallons). Harmonise in construction, before appending; keep the data dictionary up to date with each round's original unit and the conversion; and check the dictionary when you run the analysis. Compare each variable's distribution by round after combining: a round sitting a fixed multiple above the others is the tell.
> - **Codes count as values:** survey codes for "don't know" or "refused" (-99, -88, 999) enter sums and means as real numbers. Recode them to missing during construction, before any calculation.
> - **Missing parts are ignored:** summing components while skipping missing values (`rowtotal()` in Stata, `na.rm = TRUE` in R) treats an unanswered item as zero, so units with more missing items get lower totals. Count the non-missing components next to every total, and decide on a rule: require all components, set a minimum, or impute.
> - **Outliers drive the total:** one mis-keyed value, or a few extreme ones, can dominate a sum or mean. Decide on a trimming or winsorizing rule in construction, apply it once, and record it in the variable label and the data dictionary.
> - **Items are counted twice:** the questionnaire asks for a total and its sub-items, or overlapping categories, and all of them get summed. Check how the questions nest before choosing what to add.
> - Document the unit of every constructed indicator.
> - Exercise 1's "mixed units" and "missing codes" bugs live here.
---

## Slide 11 — Creating lags: what can go wrong · 2 min

| Consequence | How to tell | The fix |
|---|---|---|
| **Values cross units** | First period has a lag | Lag within each unit |
| **Wrong period** | Time gaps ≠ 1 | Lag on time, not rows |
| **Duplicate periods** | Repeated ID × time | Unique ID × time first |
| **The sample shrinks** | N drops with the lag | Decide how to handle it |

**Check that ID × time is unique. Then check every unit's first period.**

> **Notes:**
> - A lag takes the previous row. That is only the previous period if you made sure it is: the data must be sorted, with no gaps.
> - **Values cross units:** without grouping, the first observation of one unit gets the last value of the previous unit. Stata: `x[_n-1]` without `bysort id (time):`. R: `lag()` without `group_by()`. Always lag within the unit, and assert that the lag is missing in each unit's first period.
> - **Wrong period:** with a missing round, or an unsorted file, the lag comes from the wrong period, with no warning. Use lag operators that respect time: Stata `xtset id time` then `L.x`, which returns missing across gaps. In R, `arrange()` and check that the time difference is 1, or use `complete()` to make gaps explicit.
> - **Duplicate periods:** two rows with the same ID and time make the lag arbitrary, and the result can change with sort order. Stata's `xtset` refuses them ("repeated time values"). R doesn't warn. Check with `isid id time` / `distinct()` first.
> - **Time defined inconsistently:** dates stored as text, survey rounds mixed with calendar months, or the interview date used instead of the round. Build one numeric time variable during construction and document it.
> - **The sample shrinks:** the first period never has a lag, and units that joined later have no baseline, so a regression that controls for the lagged or baseline outcome silently drops them. Decide explicitly: a missing-baseline indicator, imputation, or a restricted sample, and report N.
> - **Timing relative to treatment:** make sure a "lagged" control was measured before treatment started. Otherwise it's a post-treatment variable.
> - **AI makes these mistakes too:** a lag without grouping or sorting is one of the most common errors in AI-written panel code. Check every lag the AI writes for `group_by()` / `bysort` and for gaps in time.

---

## Slide 12 — EXERCISE 1 · Construction bug hunt · 12 min (brief 1 · work 8 · reveal 3)

*In pairs · `exercise1/`*

Your AI assistant wrote this script. It runs without errors. **It is wrong in five places.**

1. Run it. Does anything look wrong? (It may not.)
2. Find at least **two** bugs
3. Add **one assertion** per bug that would have stopped the script

**Success = writing the checks, not finding all five.**

> **Notes:**
> - **The packet** (`exercises/session4/exercise1/`, also `exercise1.zip`): the course's clean data (`data/households.csv`, one row per submission; `data/children.csv`, one row per child under 5), `codebook.txt` (questions, codes and skip patterns: every bug is discoverable from it), a `README.txt`, and the construction script in both flavors, `01_construct.do` and `01_construct.R`. No solutions in the packet: they're in `exercises/facilitator/session4_exercise1_solution.do` / `.R`. The script produces three village-level indicators: the share of households with a child with diarrhoea in the past 7 days, days per week water is treated, and hours water has been stored.
> - The bugs aren't planted: they come from problems the clean data really has. They sit in three of the four dangerous steps (joining, changing units, aggregating). There's no panel, so no lag bug; slide 11 covers lags. Assertions: `assert` in Stata, `assertthat::assert_that()` in R.
> - Framing: reviewing code an AI wrote is now the realistic version of this task. The script looks clean and well commented, which is the point: plausible code with silent bugs.
> - *Stretch 1:* ask your AI assistant to review the script, then compare what it found with what you found. Which bugs did it miss? Did it flag anything that wasn't a bug?
> - *Stretch 2:* write the data-dictionary entry for the corrected indicator (name, definition, unit, decisions made).

---

## Slide 13 — Five bugs, revealed · *(part of the 12 min)*

| Bug | Step | Check |
|---|---|---|
| **Joined on `hh_id`**, which isn't unique | Joining | `isid`, then `assert _N` |
| **Skipped question** read as missing | Missing values | Construct it from the skip pattern |
| **Households without children** become 0 | Changing units | Count non-missing obs |
| **Chlorine + boiling days** add up past 7 | Aggregating | Assert a plausible range |
| **"More than 72 hours" = 99** in the mean | Aggregating | Assert the range; recode the code |

> **Notes:**
> - Most of these aren't data errors: they're correct answers read the wrong way. Fixing them moves the diarrhoea indicator from about 16% to about 36% of households with children.
> - **Joined on `hh_id`:** six `hh_id` values have two submissions each, so `joinby hh_id` (R: `relationship = "many-to-many"`, added to silence dplyr's warning) attaches each pair's children to both. Check: `isid hh_id` fails. Fix: join on `key`, the submission ID, with `merge m:1 key`, and `assert _N == 1587` children. Which of the two submissions counts is for the HFC session.
> - **Skipped question:** G4 (diarrhoea, 7 days) was only asked when G3 (48 hours) was no, so 165 children who had diarrhoea in the past 48 hours have no G4 answer, and the sum skips them. Fix: a new variable that is 1 when G3 = yes, then `assert !missing(diarrhea_7d_all)`. This is the "missing is not zero" rule: a question that wasn't asked has an answer you can construct.
> - **Households without children:** 314 consenting households have no child under 5. After the join, `collapse (sum)` (R: `sum(na.rm = TRUE)`) gives them 0 children with diarrhoea, so they count as "no" and dilute the share. Fix: count children per household and leave the indicator missing when there are none; `assert missing(hh_diarrhea) if missing(n_children)`.
> - **Chlorine + boiling days:** E1 and E2 are separate questions, so a day with both is counted twice: 383 households add up to more than 7 days. `rowtotal()` also turns the 39 non-consenting households into 0 days. Check: `assert inrange(treat_chlorine + treat_boil, 0, 7)`. The overlap can't be recovered, so the fix is a different indicator (treated at least once in the past 7 days): a research decision.
> - **99 = "more than 72 hours":** D6 is in hours except for this code, so 70 households enter the mean as 99 hours. Check: `assert storage_time <= 72 if !missing(storage_time)`. A mean can't use a "more than" answer, so the fix is again a new indicator (water stored more than 24 hours).
> - The data also has values outside the questionnaire's range (12 days of chlorine, 400 hours of storage). Keep them and assert that they're the only ones: fixing values is for the HFC session.
> - This closes the dangerous-steps block; the best-practices slides that follow generalise the checks they just wrote.
---

## Slide 14 — Best practices · 1 min

**Values change in construction only**
- Research decisions go into the data here, and nowhere else

**Datasets people can read**
- New variables, never overwritten ones
- Descriptive names, sensible order
- Labels with units and transformations

**Documentation**
- Keep a shareable data dictionary: AI can draft it from the code
- Why, when and by whom each decision was made: only you can write that
- Keep it up to date: it's what your AI checks before using a variable

> **Notes:**
> - Data construction should be the only point in your workflow where values change (not format). *Exception:* corrections based on field feedback.
> - Create new variables instead of replacing the ones originally observed, so you can easily compare them. Names should be intuitive, descriptive and functional. Order variables so information is easy to find. Labels should say the units and any trimming, winsorizing or normalization.
> - Internal documentation should tell your future reader or reviewer **why** a definition was chosen, **when** the decision was made, and **by whom**.
> - **With AI:** an assistant can draft the data dictionary (names, labels, units, how each variable is computed) straight from the construction code. Review it. What it can't write is the reasoning: why a definition was chosen, when the decision was made, and by whom. That lives in the team's memory, so it's the part of the documentation that is yours.
> - **Keep the documentation up to date, so the AI can use it:** an assistant can only check what's written down. If the data dictionary is current, the AI can look up each variable's unit, each dataset's unit of observation, and variable names and definitions before using them, instead of guessing from a name or label. An out-of-date dictionary is worse than none: the AI will trust it. Update it in the same change as the construction code.
> - The data dictionary should be in a format you can easily export into a Supplemental Information page or an appendix, include references for the methods you followed, and explain decisions that were hard to make or could be questioned by a reviewer.

---

## Slide 15 — Automating best practices · 1 min **(draft content — review)**

*Put your construction rules in your agents file (`AGENTS.md`, `CLAUDE.md`).*

```markdown
## Data construction rules
- Never overwrite an observed value
- Check units before aggregating values
- Check data dictionaries before combining data sets
- Build checks into the code
  - Merges: check keys, declare expectation relationship, assert N
  - Sums and means: one unit, plausible range, report the N used
  - Collapses and reshapes: assert N, define "empty"
- Never impute or drop missings without an instruction and a method
- Label units and transformations; update the dictionary
- Don't make research decisions: list them as questions
```

**Full rules:** [`data-construction.md`](https://github.com/DevInnovationLab/a-ai-skills/blob/main/data-construction.md)

> **Notes:**
> - 30 seconds on the slide, then point at where the full file lives: [`data-construction.md`](https://github.com/DevInnovationLab/a-ai-skills/blob/main/data-construction.md) in the DIL AI skills repo. The AI follows these rules; it doesn't replace your judgement about the definitions.
> - The slide version is a reminder for people. An agent needs more: what to check, how, what to do when a check fails, and when to stop and ask. The full version is [`data-construction.md`](https://github.com/DevInnovationLab/a-ai-skills/blob/main/data-construction.md): participants copy it into their own agents file. It covers construction (checks, missing values, merges, aggregates, collapses, lags, labels), analysis code (the errors on slides 21–22), exploratory reports (no typed numbers), and the research decisions the agent must not make. Participants copy it to their project root as `AGENTS.md` or `CLAUDE.md` and fill in the "About this project" section.

---

## Slide 16 — Section divider

**02 · Exploratory analysis with literate programming**
~16 minutes, including Exercise 2

---

## Slide 17 — Some opinionated advice · 2 min

1. **Automate your workflow:** Quarto, RMarkdown
2. **Compile in one command:** tables, graphs and inline results
3. **Document as you go:** narrative next to code
4. **AI writes the code, never the output**

**Rules for your agents file:** [`analysis-rules.md`](https://github.com/DevInnovationLab/a-ai-skills/blob/main/analysis-rules.md)

> **Notes:**
> - **Agents file:** [`analysis-rules.md`](https://github.com/DevInnovationLab/a-ai-skills/blob/main/analysis-rules.md), in the DIL AI skills repo, has the analysis rules written for an agent, alongside [`data-construction.md`](https://github.com/DevInnovationLab/a-ai-skills/blob/main/data-construction.md) from section 01. Participants copy both into their own agents file.
> - These tools are powerful assets throughout your data processing and analysis workflow. They compile code directly into professional-grade documents, with graphs, formatted tables and inline results produced automatically. Writing code alongside a descriptive narrative, instead of relying on occasional code comments, makes the whole data lineage clear and reproducible.
> - **AI writes the code, never the output:** ask your AI assistant for the chunks, the figures and the inline references. Every number in the document is computed when it renders. A number typed by you or by a model is a bug.
> - Why they work well together: a literate document puts the code right next to the result it produces, so you can check what the AI wrote line by line, and re-render the moment the data changes.
> - Say the principle out loud. It comes back in Session 5 ("AI writes the pipeline, never the output"). It's fine to have AI draft the narrative around a result, but the numbers in that narrative must be inline code. Read the rendered output against the code the first time, because you are the fact-checker of record.

---

## Slide 18 — Start simple, iterate fast · 3 min

**Content: where your time goes**
- Descriptives before regressions
- Linear before fancy
- Build the pipeline on simulated data

**Form: cheap now, and cheaper with AI**
- Exploratory means dynamic: make it easy to update
- Minimal formatting while the analysis moves
- Decide *what* to show; AI makes it pretty later

> **Notes:**
> - **Linear before fancy:** plain OLS, a few covariates at a time, a subsample if the data is big. Complexity is something you earn.
> - **Simulated data:** build and test the whole pipeline before the real data arrives.
> - **Exploratory means markdown:** Quarto and RMarkdown compile results for the team in one command, code visible, zero gold-plating.
> - **Minimal formatting:** don't spend time formatting a table or graph while the analysis is still moving. It will change.
> - **Decide what to show:** deciding the exhibit is the hard part. Making it pretty is not: AI can do it in minutes once the story is stable. Polish comes in Session 5.
> - The split is the message: your judgement goes into the content (the specification, the sample, the pipeline), while formatting is increasingly something you delegate. That's why spending hours on it during exploration is wasted time.

---


## Slide 19 — EXERCISE 2 · Descriptives in a literate report · 10 min (brief 1 · build 7 · re-render 2)

*In pairs · `exercise2/report.Rmd` · the code is written: you fill in the variables*

1. **Render** the template as is
2. **Describe:** fill the `___` in the `descriptives` chunk (by water source), set `eval = TRUE`
3. **Look:** same in the `figure` chunk
4. **Say it:** fill the `___` in the inline code of the summary sentence

**Your job is to find the right variables:** they are listed, with what each means, at the top of `report.Rmd`.

> **Notes:**
> - **The folder** (`exercises/session4/exercise2/`, four files, no subfolders): `report.Rmd` (instructions at the top, a list of variables with their meaning, and code with `___` where the variable names go), `household_water_clean.csv` (the clean data, one row per consenting household, read from the same folder so there are no paths to set), `setup.Rmd` (pre-work check) and a `README.txt` with the same steps.
> - The report uses the `rmdformats::robobook` format with `code_folding: hide`: a clean page with the code folded away (a "Code" button shows it). Participants need the `rmdformats` package.
> - **Why blanks instead of an empty chunk:** not everyone knows R. The skill this exercise practises is mapping a question ("what share chlorinated their water?") to the right variable, and seeing every number computed in the document, not writing dplyr from scratch. The next slide explains what each line of code does.
> - The template renders as is: the chunks with blanks are `eval = FALSE`, and the sentence shows "NA%" until its blank is filled. If it doesn't render, fix that first.
> - **Same data as Session 5:** `household_water_clean.csv` is built by `exercises/facilitator/make_exercise_data.R` together with the Session 5 Overleaf exercise's clean data, from the same construction, so these numbers are the ones that end up in the PI's Overleaf report.
> - **By water source, not treatment arm:** the course survey has no treatment variable. Piped vs other sources is the comparison the Overleaf report uses too.
> - At minute 5, render one pair's file on the projector. Keep the file: it's the starting point for Session 5.

---

## Slide 19a — Syntax for Exercise 2 in R · *(part of the 10 min)*

| In `report.Rmd` | What it does |
|---|---|
| `hh %>% group_by(___) %>% summarise(...)` | Means by group. `%>%` = "and then" |
| `100 * mean(___, na.rm = TRUE)` | A share in %. `na.rm = TRUE` skips missing values |
| `ggplot(aes(factor(___), pct)) + geom_col()` | A bar chart, one bar per group |
| `` `r nrow(hh)` `` | A number computed inside the text |
| `eval = FALSE` → `eval = TRUE` | Turns a chunk on |

**Not sure of the syntax? Ask your AI assistant to explain or write the code, as you would at work. Then read it, and check the output. AI writes the code, never the numbers.**

> **Notes:**
> - Leave this up while pairs work. Pair anyone new to R with someone who uses it: the exercise only needs the variable names, but reading the code is the point.
> - **Using AI is fine, and realistic:** "what does `na.rm = TRUE` do?" or "which variable in this list is the share that chlorinated?" are good questions. Two checks before moving on: read the code (does it group and handle missing values the way you meant?) and look at the rendered numbers (are they plausible?). The sentence still uses inline code: never the number itself.
> - `mean()` returns `NA` if any value is missing unless you add `na.rm = TRUE`. That is why the template already has it.

---

## Slide 19b — Exercise 2, solved · *(part of the 10 min)*

**Steps 2–3 · the variables**

```r
hh %>%
  group_by(piped) %>%
  summarise(N               = n(),
            chlorinated_pct = 100 * mean(chlorine_any, na.rm = TRUE),
            chlorine_days   = mean(chlorine_days, na.rm = TRUE),
            boiled_pct      = 100 * mean(boil_any, na.rm = TRUE),
            stored_pct      = 100 * mean(stored_now, na.rm = TRUE),
            very_safe_pct   = 100 * mean(safe_very, na.rm = TRUE))

hh %>% group_by(village_id) %>%
  summarise(chlorinated_pct = 100 * mean(chlorine_any, na.rm = TRUE)) %>%
  ggplot(aes(factor(village_id), chlorinated_pct)) + geom_col()
```

**Step 4 · say it:** `` `r round(100 * mean(hh[["chlorine_any"]], na.rm = TRUE), 1)` ``

**Check:** 1,254 households · 69.3% chlorinated in the past 7 days

> **Notes:**
> - Show this after taking one pair's file on the projector. The full solution is `exercises/facilitator/session4_exercise2_solution.Rmd` .
> - **The point:** every number in the report is computed when it renders. If the data changes, the report changes and nobody retypes anything; a typed "1,254" would silently go stale. The next slide shows where this goes next: the same outputs feeding an Overleaf report, which they'll try in Session 5.
> - Common slips: grouping by `hh_watersource` (five codes, incl. -666 "Other") instead of `piped`; `chlorine_days` where the share (`chlorine_any`) was asked for; filling the blanks but leaving `eval = FALSE`.

---

## Slide 19c — Outputs that update themselves: GitHub → Overleaf · 1 min **(new)**

**Code → files → GitHub → Overleaf: the document only points at your outputs**

What you can keep up to date this way:
- **Tables** (`.tex`) and **graphs** (`.png`, `.pdf`), exported by your scripts
- **Numbers in the text**, written by the code as LaTeX commands
- **Memos** and short updates to the PI
- **Slides** (Beamer) for team meetings and presentations

**Especially useful when writing the paper:** keep a **table and figure index** file that `\input`s every exhibit with its caption and the script that makes it. PIs browse it and pull exhibits into the draft as they write, and every one updates when the code reruns.

**We'll try this integration as a short exercise in Data Session 5.**

> **Notes:**
> - **No demo today:** just name the idea. Code writes the files, GitHub carries them, and the Overleaf document only points at them, so every table, graph and number updates when the code reruns. Participants set it up themselves in Session 5 (Exercise 1b).
> - **The index file** (e.g. `exhibits.tex` in the paper's Overleaf project): one section per table and figure, each with the `\input`/`\includegraphics` line, a caption, notes, and the script and line that produces it. It doubles as a menu for the PIs while they write and as a checklist for the replication package: every exhibit in the paper should appear there, and every entry should trace back to code.
> - **Slides and memos:** the same files work in a Beamer deck or a 2-page memo, so a team meeting deck and the paper never show different numbers.
> - Bridge: "In Session 5 you'll fork a repository, connect it to your own Overleaf project and run this yourselves, in Stata or R."

---

## Slide 20 — Section divider

**03 · Silent bugs in analysis code**
Code that runs is not code that's right
~12 minutes, including the spot-the-bug race

---

## Slide 21 — Common errors in analysis code (1/2) · 2.5 min

*More silent bugs.*

| Error | The fix |
|---|---|
| **Categories treated as numbers** | `i.` / `factor()`, with a chosen base |
| **Hand-rolled dummies** | Let `i.` / factors build them |
| **Missing values in conditions** | Handle missing explicitly |
| **The sample shifts across models** | Define the sample once; assert N |

> **Notes:**
> - These mistakes don't produce an error message. They give you the wrong number.
> - **Opinionated advice: know your variables before you use them.** For every variable in an analysis, write down what you expect: unit of measurement, unit of observation, how many missing values and why, and a reasonable range. Check it against the data dictionary, then turn it into assertions at the top of the script. Most of the bugs on these two slides show up as a variable that doesn't look the way you expected.
> - **Check the AI's code for these:** AI-written analysis code often has them, especially hand-rolled dummies, number-coded categories treated as continuous, and control lists retyped in each script. Read every regression line the AI writes against this list.
> - **Categories treated as numbers** (Stata and R): a labeled variable is not automatically categorical. `reg y treat district` treats the district code as a number. Use `i.district` / `factor(district)`, and set the base category on purpose (`ib3.district`, `fct_relevel()`). This includes `haven`-imported labelled variables in R.
> - **Hand-rolled dummies** (both, with a Stata-only detail): homemade indicators invite gaps, overlaps and confusion about which category is omitted. In Stata, `gen d1 = (district == 1)` also sets missing values to 0; R's `x == 1` returns `NA`. If you must build them: `gen d1 = (district == 1) if !missing(district)`.
> - **Missing values in conditions** (both, in opposite directions): in Stata, missing counts as larger than any number, so `keep if hh_size > 6` keeps missing values. In R, `filter(hh_size > 6)` silently drops them, and base R's `df[df$x > 6, ]` adds all-`NA` rows. Write `if hh_size > 6 & !missing(hh_size)` and decide on missing values explicitly.
> - **The sample shifts across columns** (both): observations with a missing regressor are dropped silently (`regress`, `lm()`, `feols()`), so adding one control can change N. Define the estimation sample once (a sample flag, or `e(sample)`) and assert N.

---

## Slide 22 — Common errors in analysis code (2/2) · 2.5 min

| Error | The fix |
|---|---|
| **Silently dropped variables** | Read the log; set the base; assert the coefficient exists |
| **Interaction syntax** | `treat##c.age` · `treat * age` |
| **Changing data mid-script** | Define the sample once, at the top |
| **No single source of truth** | Define everything once |

> **Notes:**
> - **Silently dropped variables** (both): collinear regressors, or fixed effects that absorb the treatment, are dropped with only a note in the log (`NA` coefficients in `lm()`, a message in `fixest`). Which category becomes the base can change with the sample or the data order (Stata picks the lowest value, R the first factor level), so coefficients move between runs. Set the base explicitly (`ib#.`, `fct_relevel()`).
> - **Interaction syntax** (differs by language): Stata treats variables in an interaction as categorical unless you write `c.`, so `treat##age` creates one dummy per age, and `#` alone drops the main effects. In R, `:` gives only the product term; `*` includes the main effects. The general rule, keep the main effects, applies to both.
> - **Stale stored results** (Stata-only): `summarize y` → `count if missing(y)` → `local cm = r(mean)` leaves the local empty, because `count` overwrote `r()`. A second regression overwrites `e()`. Run `eststo clear` before building a table. The closest R version is a stale object left over from an earlier run.
> - **Changing data mid-script** (both): a `keep if` or `drop` in the middle of the script changes the sample for every model below it. In R, the same happens with `df <- df %>% filter(...)` halfway through. Use `preserve`/`restore` or `if` conditions, and never save over the analysis data.
> - **No single source of truth** (both): the sample, an outcome or a control list is defined again in each script, and the definitions drift apart: one table trims at the 99th percentile and another doesn't, or one script's control list has a variable the other lacks. Each table looks fine; together they disagree. Define variables once, in construction. Define samples, outcomes and control lists once, in one settings file that every script loads (a globals `.do` file, or a sourced `.R` file). This is the seed of Session 5's "inputs in one place" and DRY slides; say that it comes back this afternoon.

---

## Slide 23 — SPOT THE SILENT BUG · 7 min (show 1 · race 4 · reveal 2)

*Whole room. Your AI assistant wrote this. It runs without errors. Find three problems.*

```stata
use "data/constructed/hh_constructed.dta", clear
keep if hh_size > 6
summarize chlorine_mgl if treat == 0
count if missing(chlorine_mgl)
local control_mean = r(mean)
reg chlorine_mgl treat district
```

> **Notes:**
> - Run it as a race from the front, like the Session 5 snippet: call on people, take answers, keep moving. Ask them to name the type of error (from the last two slides), not just the line.
> - **R version** (show instead if the room is mostly R):
>   ```r
>   hh <- read_dta(here("data", "constructed", "hh_constructed.dta"))
>   large <- hh[hh$hh_size > 6, ]
>   fit <- lm(chlorine_mgl ~ treat:female + district, data = large)
>   ```
>   Errors: base-R subsetting on a condition with `NA` adds all-`NA` rows; `treat:female` leaves out both main effects; `district` enters as a number.

---

## Slide 24 — Three silent bugs, revealed · *(part of the 7 min)*

| Line | Bug | Fix |
|---|---|---|
| `keep if hh_size > 6` | Keeps missing `hh_size` | `& !missing(hh_size)` |
| `local control_mean = r(mean)` | `count` overwrote `r()` | Save right after `summarize` |
| `reg … district` | District entered as a number | `i.district` |

> **Notes:**
> - The `keep if` line also changes the data mid-script, so every model below it runs on the restricted sample. Better: define the sample once at the top, or use `if` in each command.
> - Bonus question: what else would you check before trusting this regression? (N against expectations, the control mean against the descriptives from Exercise 2.)

---

## Slide 25 — Section divider

**04 · From result to PI**
Judge the number, check the exhibit, then communicate
~11 minutes, including the peer check

---

## Slide 26 — Interpret first, then share · 3 min

*Construction has rules you can assert. Results don't. The check is whether you believe the number.*

1. **Is this the estimate you meant to run?**
2. **How big is it?**
3. **How precise is it?**
4. **Is it plausible?**

**Interpret results. Write the answers in three sentences. Send them with the table.**

> **Notes:**
> - Contrast with the first half of the session: in construction you know what the data should look like (unique keys, the number of villages, plausible ranges), so you can write assertions. In analysis there's no hard rule for what an estimate should be, so you can't assert your way to a correct result. The check is your judgement: think hard about whether you believe the numbers you're seeing.
> - Before a result leaves your laptop, try to convince yourself that it's right, or find out why it isn't. Then anticipate the questions it will raise. These four questions are a starting point.
> - **The estimate you meant:** sample, outcome and specification match the plan (the PAP, or what the PI asked for). N is what you expect in every column, and you can explain any change.
> - **How big:** relative to the control mean, in the outcome's own units (percentage points, litres, rupees). Compared to what the study was powered to detect, or to similar studies.
> - **How precise:** read the confidence interval, not just the stars. An insignificant estimate is not a zero effect: say what effect sizes the interval rules out.
> - **Plausible:** sign and size make sense for this intervention and this population. If not, check for a bug first. Only then look for an explanation.
> - Automation doesn't replace this step: a report that re-renders in one command repeats whatever wasn't checked.

---

## Slide 27 — Before you share it · 2 min + 2 min peer check

- **Clear & labeled:** units, estimation, sample
- **Numbers make sense:** N and magnitudes as expected
- **Self-standing:** readable without you in the room

**PEER CHECK · 2 min:** swap Exercise 2 reports with the next pair. Would you send theirs to a PI?

> **Notes:**
> - **Clear & labeled:** you can tell the units, how results were estimated, and the sample.
> - **Numbers make sense:** sample sizes are as expected, and magnitudes are consistent with the units and with each other.
> - **Self-standing:** someone who wasn't in the room can read it: title, labels, notes on the sample and specification.
> - Interpreting the result and anticipating the PI's questions were on the previous slide; this one is about the exhibit itself. Together they make one check before anything is sent.
> - The right column of the original slide ("Presentation & polish") moves to Session 5.

---

## Slide 28 — Managing your time and your PIs · 2 min

**1. Manage expectations**
- Reply within 24 hours
- Align on priorities and timelines

**2. Plan & explore first**
- Explore, then share a rough plan
- Say what exists, what's needed, what's unclear

**3. Stay visible**
- Flag roadblocks early
- Let the PI course-correct
- Share before it's perfect

> **Notes:**
> - **24h response baseline:** always respond to requests from LRs within 24h, even if only to confirm receipt and say when you'll have time to address them.
> - **Priority alignment:** when new tasks come in, list your existing priorities and give a realistic timeline before starting.
> - **Don't just dive in:** do an initial exploration of the analytical task and share a rough plan with the PI first. Key elements to share: variables available vs. those needing creation; proposed controls and draft outputs (graphs/tables); methodological questions or requests for paper/code references.
> - **Keep PIs in the loop:** flag issues and roadblocks as they arise (e.g., missing values, long run times) and how you plan to address them. Visibility lets the PI steer your effort, so you don't waste weeks on the wrong methods or low-priority variables.
> - **Curb your perfectionism:** you'll probably need a fully developed analysis before you share something with Michael, but your managing PI is there to help you get there.

---

## Slides 29–30 — Managing your time and your PIs: real examples · 2 min total

*One Slack screenshot per slide, with a one-line caption:*

- **(1/2)** Ask with your understanding attached
- **(2/2)** Share results with notes and a plan

> **Notes:**
> - **(1/2):** an RA asks for a reference on double machine learning and writes out how they currently understand the method, so the reply can correct their understanding, not just send a link.
> - **(2/2):** an RA shares results with notes on what needs manual overrides, pushes the code, and proposes double-coding with a colleague, then asks "Do you think this is a good idea?"

---

## Slide 31 — Wrap-up · 2 min

**Questions? Go construct something you can defend.**

- Name the dangerous steps and the check for each
- Spot the analysis errors that don't raise an error
- Render a report with no typed numbers
- Interpret before you share, and share early

*The worst bug is the silent one: compute every number, assert every assumption. AI can execute, you have to think*

> **Notes:** Remind everyone to keep their Exercise 2 report: it's the starting point for Session 5 this afternoon.

---

## Appendix — Pre-work email (send 2–3 days before)

1. Install R and RStudio, then run `install.packages(c("dplyr", "ggplot2", "rmarkdown", "rmdformats", "haven", "here", "fixest", "assertthat"))`
2. Download and unzip `exercise2/`, open `setup.Rmd` in RStudio and click **Knit**
3. Sign in to the AI assistant you'll use during the exercises (e.g., Claude Desktop), and check that it can open files in the exercise folder.
4. Reply with a screenshot of your rendered test file, or tell us what broke.

**Fallback on the day:** a hosted environment (e.g., Posit Cloud) with `exercise2/` pre-loaded, and a pre-rendered HTML version of the template.
