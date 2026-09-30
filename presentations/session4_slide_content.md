# Data Session 4 — Data analysis: construction & exploration

**Slide content, 75 minutes** · follows `session4_session5_split_plan.md`

- **Header on every slide:** DATA ANALYSIS: CONSTRUCTION & EXPLORATION
- **Footer:** Development Innovation Lab / University of Chicago · Data analysis: Construction & Exploration
- **Convention:** slide text is kept short; detail, examples and code live in the notes.

## To-dos

- [ ] **Review the exercises and harmonize them with other sessions.** Use the same dataset, variable names and file structure as the rest of the course. Check that Exercise 2's report is what Session 5 expects as its starting point, and that the Quarto, GitHub and Overleaf steps don't repeat Session 5's reporting exercise.
- [ ] **Incorporate Nandita's feedback.**
- [ ] **Cut exercises or content to fit the time.** The slides currently add up to about 83 minutes for a 75-minute session.
- [ ] **Add an example of exploratory analysis results previously shared with MK.** A real, anonymized update would fit the "Before you share it" slide or the Slack examples in section 04.
- [ ] Write the silent-bug story for "Why this session" (placeholder)
- [ ] Review the draft agents-file rules on "Automating best practices"
- [ ] Pre-create each pair's GitHub repo and linked Overleaf project (the Overleaf licence covers GitHub sync)
- [ ] Fix the stray text box on "Best practices", and get permission for the Slack screenshots

---

## Slide 1 — Title · 1 min

**DATA SESSION 4 · WELCOME WEEK INDIA 2026 · THURSDAY, OCTOBER 8 · 11:30 AM – 12:45 PM**

# Data analysis: construction & exploration

*From clean data to a first result you can defend.*

David Torres Leon – Data Manager · Luiza Andrade – Data Lead · Nandita Gupta – Predoctoral Fellow
Development Innovation Lab · Welcome Week India 2026

> **Notes:** Replace the old speaker note (it describes Session 5: "90 min, David leads"). Laptops open. The exercise folders (`construction_exercise/`, `explore_exercise/`) should already be on everyone's machine.

---

## Slide 2 — Why this session · 2 min **(placeholder — story to add)**

**[PLACEHOLDER: a real silent bug that reached a PI — 1 minute]**

**Writing the code is the easy part. With AI, it's easier than ever.**

So your value is everything the code can't do:
- Knowing what the data *should* look like
- Deciding what to show
- Judging whether you believe a number
- Explaining it to your PI

> **Notes:**
> - **The story:** open with a real case, anonymised if needed: a result that looked fine, ran without errors, went to a PI, and turned out to be wrong because of a silent bug (a duplicated merge key, a missing code summed as a value, a lag taken from the wrong household). End on the cost: the time lost, the decision it nearly changed. This sets up "the worst bug is the silent one" before slide 6 names it.
> - **The motivation:** when it comes to coding, analysis is the easy part, and AI now writes that code in seconds. That doesn't make the RA's job smaller. It moves the value to the parts that need human judgement, and we have to get better at them. Every principle today is one of those parts:
>   - **Knowing what the data should look like** → the danger zone and the construction checks (section 01)
>   - **Deciding what to show** → exploratory reports, where content matters more than form (section 02)
>   - **Catching what runs but is wrong** → silent bugs in analysis code (section 03)
>   - **Judging and explaining results** → from result to PI (section 04)

---

## Slide 3 — By the end of this session, you'll be able to… · 1 min

- Spot where construction goes wrong: joins, unit changes, aggregation, lags
- Write code that stops loudly when the data isn't what you expect
- Build an exploratory report that re-renders in one command
- Avoid silent errors in analysis code
- Judge results before you share them, and keep your PIs informed

---

## Slide 4 — Section divider

**01 · Constructing indicators**
Turning field observations into economically meaningful data
~27 minutes, including Exercise 1

---

## Slide 5 — Data construction · 2 min

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

## Slide 6 — This is the danger zone · 2 min

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

## Slide 7 — Joining data tables: what can go wrong · 2 min

| Consequence | How to tell | The fix |
|---|---|---|
| **Rows multiply** | N too high | Unique key; declare the relationship |
| **Rows disappear** | N too low | Keep and count unmatched rows |
| **Keys don't match** | Low match rate | Standardise key formats |
| **Values get overwritten** | Duplicate or changed columns | Drop overlapping variables first |
| **Unmatched becomes zero** | Too many zeros | Never fill missing by default |

**Write down the expected relationship and N. Then assert both.**

> **Notes:**
> - A wrong join doesn't throw an error. It gives you a different dataset.
> - **Rows multiply:** a key you assumed was unique isn't, so each match is duplicated and every mean or regression overweights those units. Check uniqueness before joining (Stata `isid`, R `distinct()` / `count()`), and declare the relationship you expect (one-to-one, many-to-one) so the software stops if it's wrong.
> - **Rows disappear:** unmatched observations are dropped, often without comment. The sample may now exclude, say, households not found at endline. A suspiciously round match rate is another sign. Keep unmatched rows on purpose, count them, and decide what they mean before dropping any.
> - **Keys don't match:** the same ID is stored differently (text vs number, leading zeros like "007" vs 7, trailing spaces, capitals), so the match rate falls far below what the field team reports. Standardise key formats during construction, and tabulate the unmatched IDs from both sides.
> - **Values get overwritten:** both tables have a variable with the same name, so one silently wins or you end up with two copies (`.x` / `.y` in R). Rename or drop overlapping variables before joining, and keep only the columns you need.
> - **Unmatched becomes zero:** missing values from non-matches are later filled in or summed as zeros. Flag unmatched rows explicitly, and never fill in missing values by default.
> - **Stata users: never use `merge m:m`.** It doesn't check the keys. It pairs rows within each key in whatever order they happen to be sorted, so matches are arbitrary and can change between runs. Stata's own manual says it is almost never what you want. If you need every pairing, use `joinby`. Otherwise, fix the key so the merge is 1:1, m:1 or 1:m.
> - **In code:** Stata: `isid`, `merge 1:m`, `assert _merge == 3`. R: `left_join(..., relationship = "one-to-many", unmatched = "error")` (dplyr ≥ 1.1).
> - **AI makes these mistakes too, and confidently:** assistants routinely write joins with no declared relationship and no check on N. When AI writes a join, ask it for the uniqueness check and the expected N, or add them yourself.
> - Links back to "Write the plan before the code" on slide 6, and to the join bug in Exercise 1.

---

## Slide 8 — Changing units of observation: what can go wrong · 2.5 min

| Consequence | How to tell | The fix |
|---|---|---|
| **Units disappear** | Fewer units than the frame | Build onto the full list of units |
| **Missing and zero get confused** | Unexpected zeros or missings | Decide what "empty" means |
| **The average changes meaning** | Doesn't match the source | Choose weights on purpose |
| **Information is lost** | Varying values become constant | Check what's constant in groups |
| **Reshapes misalign** | Duplicate or missing cells | Unique ID × time first |

**Write down the expected number of units. Then assert it.**

> **Notes:**
> - Collapsing, aggregating and reshaping change what one row means. Nothing warns you when that goes wrong.
> - **Units disappear:** groups with no observations simply don't appear after a collapse, so a village where no one was surveyed vanishes instead of showing up as empty. Compare the count against a known total, like the sampling frame. Start from the full list of units and join the aggregates onto it, so empty units stay visible.
> - **Missing and zero get confused:** a sum over all-missing values returns 0 in both Stata (`collapse (sum)`) and R (`sum(x, na.rm = TRUE)`), and a mean over no observations returns missing. So a true zero can become missing, and a missing can become zero. Count the non-missing observations alongside every aggregate, and code the empty-group case yourself.
> - **The average changes meaning:** a mean of household means is not the mean across individuals, and a village average weights every village equally regardless of size. Decide whose average the indicator represents (households, people, villages), and weight explicitly.
> - **Information is lost:** variables left out of the collapse are dropped, and a variable that isn't constant within a group ends up with one arbitrary value (e.g., the first). Before collapsing, check which variables should be constant within the group, and assert it (Stata: `bysort village_id: assert x == x[1]`; R: `n_distinct(x) == 1` within `group_by()`).
> - **Reshapes misalign:** duplicated ID × time pairs make a reshape fail or pick arbitrary rows, and unbalanced panels produce new missing cells when going wide. Check that the ID × time pairs are unique first, and count the new missing values afterwards.
> - **In code:** Stata: `collapse`, `reshape`, `isid id time`, `assert _N == <expected>`. R: `summarise()`, `pivot_wider()` / `pivot_longer()`, `complete()` to keep empty units, `assert_that(nrow(df) == expected)`.
> - Also write down what an empty group should mean (missing or zero) before collapsing. This is where Exercise 1's "false zeros" bug lives.
> - **AI makes these mistakes too:** AI-written collapses almost never keep empty units or count non-missing observations, and they pick weights by default. Check both before you accept the code.

---

## Slide 9 — Aggregating values: what can go wrong · 2.5 min

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
> - **Codes count as values:** survey codes for "don't know" or "refused" (-99, -88, 999) enter sums and means as real numbers. Recode them to missing during construction, before any calculation.
> - **Missing parts are ignored:** summing components while skipping missing values (`rowtotal()` in Stata, `na.rm = TRUE` in R) treats an unanswered item as zero, so units with more missing items get lower totals. Count the non-missing components next to every total, and decide on a rule: require all components, set a minimum, or impute.
> - **Outliers drive the total:** one mis-keyed value, or a few extreme ones, can dominate a sum or mean. Decide on a trimming or winsorizing rule in construction, apply it once, and record it in the variable label and the data dictionary.
> - **Items are counted twice:** the questionnaire asks for a total and its sub-items, or overlapping categories, and all of them get summed. Check how the questions nest before choosing what to add.
> - Document the unit of every constructed indicator.
> - **In code:** Stata: `egen rowtotal()`, `rownonmiss()`, `mvdecode`, `assert inrange()`. R: `rowSums()`, `across()`, `na_if()`, `assert_that()`.
> - Exercise 1's "mixed units" and "missing codes" bugs live here.
> - **AI makes these mistakes too:** assistants add `na.rm = TRUE` (or `rowtotal()`) by default, which turns missing parts into zeros, and they don't know your survey's missing codes or units unless you tell them. Put both in the prompt or the agents file.

---

## Slide 10 — Creating lags: what can go wrong · 2 min

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

## Slide 11 — EXERCISE 1 · Construction bug hunt · 12 min (brief 1 · work 8 · reveal 3)

*In pairs · `construction_exercise/`*

Your AI assistant wrote this script. It runs without errors. **It is wrong in five places.**

1. Run it. Does anything look implausible?
2. Find at least **two** bugs
3. Add **one assertion** per bug that would have stopped the script

**Success = writing the checks, not finding all five.**

> **Notes:**
> - **The packet:** `hh_roster.csv`, `hh_survey.csv` (two survey rounds), and a construction script in both flavors, `01_construct.do` and `01_construct.R`. The script produces a village-level water-use indicator and its change since the last round.
> - Each bug matches one of the four dangerous steps. Assertions: `assert` in Stata, `assertthat::assert_that()` in R.
> - Framing: reviewing code an AI wrote is now the realistic version of this task. The script looks clean and well commented, which is the point: plausible code with silent bugs.
> - *Stretch 1:* ask your AI assistant to review the script, then compare what it found with what you found. Which bugs did it miss? Did it flag anything that wasn't a bug?
> - *Stretch 2:* write the data-dictionary entry for the corrected indicator (name, definition, unit, decisions made).

---

## Slide 12 — Five bugs, revealed · *(part of the 12 min)*

| Bug | Step | Check |
|---|---|---|
| **Duplicated key** in the merge | Joining | `isid`, then `assert _N` |
| **False zeros** after the collapse | Changing units | Count non-missing obs |
| **Mixed units** (gallons) | Aggregating | Assert a plausible range |
| **`-99` codes** in the total | Aggregating | Recode, then assert ≥ 0 |
| **Lag across households** | Lags | Lag within unit; assert round 1 missing |

> **Notes:**
> - Take answers from pairs before showing the table. Point back to the matching slide for each row: joining (slide 7), changing units (8), aggregating (9), lags (10).
> - **Duplicated key:** the survey is merged onto the roster with `m:m`. Fix: `isid hh_id` in the survey file, `merge 1:m`, then `assert _N == <expected>`. R: `left_join(..., relationship = "one-to-many")`.
> - **False zeros:** `collapse (sum)` turns an all-missing village into 0. Fix: count non-missing obs in the collapse, then `replace water_lpd = . if n_obs == 0`. R: `sum(x, na.rm = TRUE)` also returns 0 for an all-`NA` group.
> - **Mixed units:** one enumerator logged gallons. Check: `assert inrange(water_lpd, 0, 500) if !missing(water_lpd)`. R: `assert_that(all(hh$water_lpd <= 500, na.rm = TRUE))`.
> - **Missing codes:** `mvdecode water_*, mv(-99 = .a)`, then `assert water_lpd >= 0 if !missing(water_lpd)`.
> - **Lag across households:** the previous round's value is taken from the row above without grouping by household. Fix: `xtset hh_id round`, use `L.water_lpd`, then `assert missing(L.water_lpd) if round == 1`. R: `group_by(hh_id) %>% arrange(round) %>% mutate(water_lag = lag(water_lpd))`.
> - This closes the dangerous-steps block; the best-practices slides that follow generalise the checks they just wrote.

---

## Slide 13 — Best practices · 1 min

**Values change in construction only**
- Research decisions go into the data here, and nowhere else

**Datasets people can read**
- New variables, never overwritten ones
- Descriptive names, sensible order
- Labels with units and transformations

**Documentation**
- Keep a shareable data dictionary: AI can draft it from the code
- Why, when and by whom each decision was made: only you can write that

> **Fix before presenting:** the slide has a stray vertical text box ("e di t_ di ff er e nt st or y_ e d u"). Delete it.
>
> **Notes:**
> - Data construction should be the only point in your workflow where values change (not format). *Exception:* corrections based on field feedback.
> - Create new variables instead of replacing the ones originally observed, so you can easily compare them. Names should be intuitive, descriptive and functional. Order variables so information is easy to find. Labels should say the units and any trimming, winsorizing or normalization.
> - Internal documentation should tell your future reader or reviewer **why** a definition was chosen, **when** the decision was made, and **by whom**.
> - **With AI:** an assistant can draft the data dictionary (names, labels, units, how each variable is computed) straight from the construction code. Review it. What it can't write is the reasoning: why a definition was chosen, when the decision was made, and by whom. That lives in the team's memory, so it's the part of the documentation that is yours.
> - The data dictionary should be in a format you can easily export into a Supplemental Information page or an appendix, include references for the methods you followed, and explain decisions that were hard to make or could be questioned by a reviewer.

---

## Slide 14 — Automating best practices · 1 min **(draft content — review)**

*Put your construction rules in your agents file (`AGENTS.md`, `CLAUDE.md`).*

```markdown
## Data construction rules
- Never overwrite an observed variable
- Merges: check keys, declare 1:1 / m:1 / 1:m, assert N
- Sums and means: one unit, plausible range
- Recode missing codes before any calculation
- Collapses and reshapes: assert N, define "empty"
- Label units and transformations; update the dictionary
- Don't make research decisions: list them as questions
```

> **Notes:**
> - 30 seconds on the slide, then point at where the full file lives in the exercise folder. The AI follows these rules; it doesn't replace your judgement about the definitions.
> - Full version of the rules for the file:
>   - Never overwrite an originally observed variable. Create a new one.
>   - Before any merge: run `isid` on the key in both datasets and state 1:1, m:1 or 1:m. Never use m:m. Assert the expected N after the merge.
>   - Before any sum or mean: check that all values share one unit and assert a plausible range.
>   - Recode survey missing codes (-99, -88, ...) to missing before any calculation. Never let them enter a sum.
>   - After every collapse or reshape: assert the expected number of observations, and decide explicitly whether "no observations" means missing or zero.
>   - Label every constructed variable with its unit and any transformation (trimming, winsorizing, normalization), and add it to the data dictionary.
>   - Do not make research decisions (definitions, cut-offs, trimming rules) on your own. List them as open questions for the team.

---

## Slide 15 — Section divider

**02 · Exploratory analysis with literate programming**
Fast results for the team, in one command
~27 minutes, including Exercises 2 and 3

---

## Slide 16 — Some opinionated advice · 2 min

1. **Use literate programming tools:** Quarto, RMarkdown
2. **Compile in one command:** tables, graphs and inline results
3. **Document as you go:** narrative next to code
4. **AI writes the code, never the output**

> **Notes:**
> - These tools are powerful assets throughout your data processing and analysis workflow. They compile code directly into professional-grade documents, with graphs, formatted tables and inline results produced automatically. Writing code alongside a descriptive narrative, instead of relying on occasional code comments, makes the whole data lineage clear and reproducible.
> - **AI writes the code, never the output:** ask your AI assistant for the chunks, the figures and the inline references. Every number in the document is computed when it renders. A number typed by you or by a model is a bug.
> - Why they work well together: a literate document puts the code right next to the result it produces, so you can check what the AI wrote line by line, and re-render the moment the data changes.
> - Say the principle out loud. It comes back in Session 5 ("AI writes the pipeline, never the output"). It's fine to have AI draft the narrative around a result, but the numbers in that narrative must be inline code. Read the rendered output against the code the first time, because you are the fact-checker of record.

---

## Slide 17 — Start simple, iterate fast · 3 min

**Content: where your time goes**
- Linear before fancy
- Build the pipeline on simulated data

**Form: cheap now, and cheaper with AI**
- Exploratory means markdown
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

## Slide 18 — EXERCISE 2 · Descriptives in a literate report · 10 min (brief 1 · build 7 · re-render 2)

*In pairs · `explore_exercise/report.qmd`*

1. **Render** the template as is
2. **Describe:** summary statistics by treatment arm
3. **Look:** one figure of the main outcome
4. **Say it:** one sentence with N and the mean, as inline code
5. **Switch it:** add `last_week_only`, re-render, check the sentence changed

| Parameter | `params: last_week_only: false` |
|---|---|
| Inline code | `` `r nrow(hh)` `` |
| Render | `quarto render report.qmd -P last_week_only:true` |

> **Notes:**
> - The template (`report.qmd`, or `report.Rmd`) already has a header and a setup chunk that loads the course dataset constructed in Exercise 1. If it doesn't render, fix that first: everything else depends on it.
> - Summary statistics: the main outcomes and key household characteristics (e.g., the main outcome, household size, respondent age, district). No formatting effort.
> - AI can write the chunks. It can't type the numbers.
> - This replaces the anatomy demo, so participants learn the parts of the file by using them. Before the session, make sure the starter file renders on a clean machine. At minute 5, render one pair's file on the projector.
> - Keep the file: it's the starting point for Session 5.

---

## Slide 19 — Outputs that update themselves · 2 min

**Code → files → GitHub → Overleaf**

1. Your script exports tables (`.tex`), figures (`.png`) and key numbers
2. You push them to GitHub
3. Overleaf pulls them, and your short report to the PI recompiles with the new results

**Nobody retypes a number. Nobody re-pastes a table.**

> **Notes:**
> - Same principle as inline code in Quarto, applied to a short LaTeX report: the kind of 2–3 page exploratory update a PI reads and comments on in Overleaf. The report is not a paper: a few exhibits, short notes, open questions. As with Quarto, the document only *references* outputs, it never contains typed results. Tables come in with `\input{tables/desc.tex}`, figures with `\includegraphics{figures/outcome.png}`, and numbers in the text with macros written by the code (e.g., `\Nhh`), so the text updates too.
> - When the data or a decision changes: rerun the script, push, pull in Overleaf, recompile. Every exhibit and every number in the text moves together.
> - **With AI:** AI can write the LaTeX around your outputs (the document skeleton, table formatting, the `\input` lines). It never types a result. Same rule as slide 16.
> - **How the link works:** an Overleaf project is linked to a GitHub repository (Overleaf menu → GitHub → sync, or create the project via *Import from GitHub*). Changes come in with *Pull GitHub changes into Overleaf*; edits made in Overleaf go back with *Push Overleaf changes to GitHub*.
> - **Access:** GitHub sync is an Overleaf premium feature; it's covered by the licence participants use. If someone's account isn't linked on the day, they can follow along on the facilitator's project on screen.
> - Why Overleaf for this: it's where many PIs already read and comment, and a shared project means they always see the latest results without you emailing PDFs.
> - Polished exhibits and the full paper pipeline are Session 5; here the goal is a quick report that keeps itself up to date.

---

## Slide 20 — EXERCISE 3 · A report that updates itself · 10 min (brief 1 · build 7 · update 2)

*In pairs · your Exercise 2 project + `report_template/`*

1. **Export:** save your descriptives table as `.tex` and your figure as `.png`
2. **Push** them to your GitHub repository
3. **Link:** open the linked Overleaf project, `\input` the table, include the figure, compile
4. **Update:** flip `last_week_only`, rerun, push, pull in Overleaf, recompile

**Did the report change without you typing anything?**

> **Notes:**
> - **Before the session:** each pair needs a GitHub repository created from the course template (with `report_template/main.tex`, a 2–3 page exploratory-update template: title, date, a short summary, one table, one figure, open questions), and an Overleaf project already linked to it. Set these up in advance: creating accounts and linking them eats the whole exercise. Add GitHub and Overleaf sign-ins to the pre-work email.
> - **R export:** `modelsummary::datasummary_balance(~treat, data = hh, output = "tables/desc.tex")` and `ggsave(here("figures", "outcome.png"), width = 6, height = 4)`. Key number for the text: `writeLines(sprintf("\\newcommand{\\Nhh}{%s}", nrow(hh)), here("tables", "numbers.tex"))`.
> - **Push:** `git add tables figures`, `git commit -m "Update descriptives"`, `git push`, or the GitHub Desktop equivalent.
> - *Stretch:* `\input{tables/numbers.tex}` in the preamble of `main.tex`, use `\Nhh` in the summary sentence, and check that it changes after the update.
> - AI can write the export code and the LaTeX lines. It can't type the numbers.

---

## Slide 21 — Section divider

**03 · Silent bugs in analysis code**
Code that runs is not code that's right
~12 minutes, including the spot-the-bug race

---

## Slide 22 — Common errors in analysis code (1/2) · 2.5 min

*More silent bugs.*

| Error | The fix |
|---|---|
| **Categories treated as numbers** | `i.` / `factor()`, with a chosen base |
| **Hand-rolled dummies** | Let `i.` / factors build them |
| **Missing values in conditions** | Handle missing explicitly |
| **The sample shifts across columns** | Define the sample once; assert N |

> **Notes:**
> - These mistakes don't produce an error message. They give you the wrong number.
> - **Check the AI's code for these:** AI-written analysis code often has them, especially hand-rolled dummies, number-coded categories treated as continuous, and control lists retyped in each script. Read every regression line the AI writes against this list.
> - **Categories treated as numbers** (Stata and R): a labeled variable is not automatically categorical. `reg y treat district` treats the district code as a number. Use `i.district` / `factor(district)`, and set the base category on purpose (`ib3.district`, `fct_relevel()`). This includes `haven`-imported labelled variables in R.
> - **Hand-rolled dummies** (both, with a Stata-only detail): homemade indicators invite gaps, overlaps and confusion about which category is omitted. In Stata, `gen d1 = (district == 1)` also sets missing values to 0; R's `x == 1` returns `NA`. If you must build them: `gen d1 = (district == 1) if !missing(district)`.
> - **Missing values in conditions** (both, in opposite directions): in Stata, missing counts as larger than any number, so `keep if hh_size > 6` keeps missing values. In R, `filter(hh_size > 6)` silently drops them, and base R's `df[df$x > 6, ]` adds all-`NA` rows. Write `if hh_size > 6 & !missing(hh_size)` and decide on missing values explicitly.
> - **The sample shifts across columns** (both): observations with a missing regressor are dropped silently (`regress`, `lm()`, `feols()`), so adding one control can change N. Define the estimation sample once (a sample flag, or `e(sample)`) and assert N.

---

## Slide 23 — Common errors in analysis code (2/2) · 2.5 min

| Error | The fix |
|---|---|
| **Silently dropped variables** | Read the log; set the base; assert the coefficient exists |
| **Interaction syntax** | `treat##c.age` · `treat * age` |
| **Stale stored results** | Save results immediately |
| **Changing data mid-script** | Define the sample once, at the top |
| **No single source of truth** | Define everything once |

> **Notes:**
> - **Silently dropped variables** (both): collinear regressors, or fixed effects that absorb the treatment, are dropped with only a note in the log (`NA` coefficients in `lm()`, a message in `fixest`). Which category becomes the base can change with the sample or the data order (Stata picks the lowest value, R the first factor level), so coefficients move between runs. Set the base explicitly (`ib#.`, `fct_relevel()`).
> - **Interaction syntax** (differs by language): Stata treats variables in an interaction as categorical unless you write `c.`, so `treat##age` creates one dummy per age, and `#` alone drops the main effects. In R, `:` gives only the product term; `*` includes the main effects. The general rule, keep the main effects, applies to both.
> - **Stale stored results** (Stata-only): `summarize y` → `count if missing(y)` → `local cm = r(mean)` leaves the local empty, because `count` overwrote `r()`. A second regression overwrites `e()`. Run `eststo clear` before building a table. The closest R version is a stale object left over from an earlier run.
> - **Changing data mid-script** (both): a `keep if` or `drop` in the middle of the script changes the sample for every model below it. In R, the same happens with `df <- df %>% filter(...)` halfway through. Use `preserve`/`restore` or `if` conditions, and never save over the analysis data.
> - **No single source of truth** (both): the sample, an outcome or a control list is defined again in each script, and the definitions drift apart: one table trims at the 99th percentile and another doesn't, or one script's control list has a variable the other lacks. Each table looks fine; together they disagree. Define variables once, in construction. Define samples, outcomes and control lists once, in one settings file that every script loads (a globals `.do` file, or a sourced `.R` file). This is the seed of Session 5's "inputs in one place" and DRY slides; say that it comes back this afternoon.

---

## Slide 24 — SPOT THE SILENT BUG · 7 min (show 1 · race 4 · reveal 2)

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

## Slide 25 — Three silent bugs, revealed · *(part of the 7 min)*

| Line | Bug | Fix |
|---|---|---|
| `keep if hh_size > 6` | Keeps missing `hh_size` | `& !missing(hh_size)` |
| `local control_mean = r(mean)` | `count` overwrote `r()` | Save right after `summarize` |
| `reg … district` | District entered as a number | `i.district` |

> **Notes:**
> - The `keep if` line also changes the data mid-script, so every model below it runs on the restricted sample. Better: define the sample once at the top, or use `if` in each command.
> - Bonus question: what else would you check before trusting this regression? (N against expectations, the control mean against the descriptives from Exercise 2.)

---

## Slide 26 — Section divider

**04 · From result to PI**
Judge the number, check the exhibit, then communicate
~12 minutes, including the peer check

---

## Slide 27 — Interpret first, then share · 3 min

*Construction has rules you can assert. Results don't. The check is whether you believe the number.*

1. **Is this the estimate you meant to run?**
2. **How big is it?**
3. **How precise is it?**
4. **Is it plausible?**

**Write the answers in three sentences. Send them with the table.**

> **Notes:**
> - Contrast with the first half of the session: in construction you know what the data should look like (unique keys, the number of villages, plausible ranges), so you can write assertions. In analysis there's no hard rule for what an estimate should be, so you can't assert your way to a correct result. The check is your judgement: think hard about whether you believe the numbers you're seeing.
> - Before a result leaves your laptop, try to convince yourself that it's right, or find out why it isn't. Then anticipate the questions it will raise. These four questions are a starting point.
> - **The estimate you meant:** sample, outcome and specification match the plan (the PAP, or what the PI asked for). N is what you expect in every column, and you can explain any change.
> - **How big:** relative to the control mean, in the outcome's own units (percentage points, litres, rupees). Compared to what the study was powered to detect, or to similar studies.
> - **How precise:** read the confidence interval, not just the stars. An insignificant estimate is not a zero effect: say what effect sizes the interval rules out.
> - **Plausible:** sign and size make sense for this intervention and this population. If not, check for a bug first. Only then look for an explanation.
> - If possible, put one regression table on screen and answer the four questions out loud. Examples to use: an effect on a share that is larger than the control mean is a bug until proven otherwise; an N that drops between columns should match a skip pattern or a control with missing values.
> - Automation doesn't replace this step: a report that re-renders in one command repeats whatever wasn't checked.

---

## Slide 28 — Before you share it · 2 min + 2 min peer check

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

## Slide 29 — Managing your time and your PIs · 2 min

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

## Slides 30–31 — Managing your time and your PIs: real examples · 2 min total

*One Slack screenshot per slide, with a one-line caption:*

- **(1/2)** Ask with your understanding attached
- **(2/2)** Share results with notes and a plan

> **Notes:**
> - **(1/2):** an RA asks for a reference on double machine learning and writes out how they currently understand the method, so the reply can correct their understanding, not just send a link.
> - **(2/2):** an RA shares results with notes on what needs manual overrides, pushes the code, and proposes double-coding with a colleague, then asks "Do you think this is a good idea?"
> - Ask the RAs in the screenshots for permission before presenting their messages.

---

## Slide 32 — Wrap-up · 2 min

**Questions? Go construct something you can defend.**

- Name the dangerous steps and the check for each
- Spot the analysis errors that don't raise an error
- Render a report with no typed numbers
- Interpret before you share, and share early

*The worst bug is the silent one: compute every number, assert every assumption.*

> **Notes:** Remind everyone to keep their Exercise 2 report: it's the starting point for Session 5 this afternoon.

---

## Appendix — Pre-work email (send 2–3 days before)

1. Install Quarto (quarto.org) and render the test file in `explore_exercise/hello.qmd`
2. Install R and `pacman`, then run `pacman::p_load(tidyverse, haven, here, fixest, assertthat)`
3. Create a GitHub account and an Overleaf account, send us both usernames, and install git (or GitHub Desktop)
4. Sign in to the AI assistant you'll use during the exercises (e.g., Claude Desktop), and check that it can open files in the exercise folder.
5. Reply with a screenshot of your rendered test file, or tell us what broke.

**Fallback on the day:** a hosted environment (e.g., Posit Cloud) with the exercise pre-loaded, and a pre-rendered HTML version of the template.
