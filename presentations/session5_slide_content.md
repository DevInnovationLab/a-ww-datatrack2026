# Data Session 5 — Publication: reports & replicability

**Slide content, 90-minute session** (slides add up to 104 minutes, including the 12-minute Overleaf exercise on slide 23b) · first draft · follows `session4_session5_split_plan.md` and builds on `session4_slide_content.md`

- **Header on every slide:** PUBLICATION: REPORTS & REPLICABILITY
- **Footer:** Development Innovation Lab / University of Chicago · Publication: Reports & Replicability
- **Sources:** "S5 v2" = DIL_DataSession5_Publication_Reports_Replicability_v2 · "Copy" = 2026_Publication_Reports_Replicability · **NEW** = not in any existing deck
- **Convention:** slide text is kept short; detail, examples and code live in the notes.

## To-dos

- [ ] **Start with a motivation slide**, as in Session 4's "Why this session": open with why reproducibility and publication-ready outputs matter, ideally a real story, before the objectives.
- [ ] **Harmonize Exercise 1 with Session 4.** Session 4 now ends with an R Markdown exploratory report (Exercise 2), followed by a 3-minute GitHub → Overleaf demo (Session 4 slide 19c); the hands-on version is here (slides 23 and 23b). Session 4 has no regression exercise. This draft makes Exercise 1 start from that report and supply the model in the packet. Check that it doesn't feel like a repeat of Session 4.
- [ ] **Decide the language for the exercises.** Session 4's report exercises are R-only. S5 v2 ran Exercise 1 with Stata chunks, and the replicability snippet is in Stata. This draft uses R for Exercise 1 and keeps the Stata snippet, with Stata notes where useful.
- [ ] **Replace the placeholder script** on "What reproducible code looks like" with a real DIL snippet (the draft below is illustrative).
- [ ] **Fit to time:** the slides add up to 104 minutes for a 90-minute session, with no buffer: slide 23 (moved from Session 4) added 2 minutes and the Overleaf exercise (slide 23b) 12. If you run behind, cut Part 05 (replication package), never Exercise 2.
- [ ] **Check presenter notes that don't match the expected time.** At about 130 spoken words a minute, these notes are too long for their slide: 33 So: should a model run this checklist? (225 words, 1 min), 20 One source, two outputs, then a report (158, 1 min), 23 Outputs that update themselves (299, 2 min), 30 The DIL paper-submission checklist (146, 1 min). Trim the notes or give the slides more time.
- [x] **Decide how much GitHub → Overleaf practice to include.** Decided: a standalone exercise (slide 23b, 12 min in session) in `exercises/session5/exercise1b/`, shared with participants as is: instructions, data, Stata and R scripts, and the Overleaf project. Participants set their paths to their own Overleaf clone, run, push and pull, then flip `last_week_only` and rerun. Session 4 shows it as a demo (Session 4 slide 19c). Facilitator notes: `exercises/facilitator/session5_exercise1b_notes.md`.
- [ ] **Session 4's Exercise 2 is now R Markdown** (`exercise2/report.Rmd`, rendered with `rmarkdown::render`), not Quarto. Exercise 1 here still says `report.qmd` and Quarto: align the format (and the pre-work) before building Part A's materials.
- [ ] **Fit to time after adding slide 23b:** it adds 12 minutes (about 104 for 90). Cut Part 05 (replication package) first, as the to-do above suggests, and decide what else goes.
- [ ] **Pre-work email:** ask participants to create a GitHub account and an Overleaf account (with GitHub sync), install GitHub Desktop, download `exercises/session5/exercise1b/`, and do steps 1–3 of its `README.txt` (upload `overleaf.zip` to Overleaf, sync it to GitHub, clone it with GitHub Desktop), so the session time is only steps 4–5.
- [x] ~~Pre-create each pair's GitHub repo and linked Overleaf project~~ — no longer needed: participants create their own in the pre-work (steps 1–3 of the exercise README). Still confirm the Overleaf licence covers GitHub sync for everyone.
- [x] ~~Pre-work email: GitHub and Overleaf accounts, git or GitHub Desktop~~ — merged into the pre-work email to-do above (no usernames needed now: participants create their own repositories)
- [ ] **Carried over from S5 v2:**
  - [ ] Confirm Sneha's surname and title, and agree the presenter split
  - [ ] Exhibit skill: ask Sneha for her workflow; decide whether to demo it or present it as coming (owners: David and Sneha)
  - [ ] Fold section 8 (compare to the PAP) and the deviations table into the published submission guide (owner: David, reviewer: Witold)
  - [ ] Confirm the paper-submission-check skill loads in Claude Desktop, and decide on a 60-second demo
  - [ ] Pick the two replication packages to open live, and check the URLs the morning of
  - [ ] Distribute `report_exercise/`, `PAP_checklist_exercise/` and `exercise1b/` before the session; everyone signed in to Claude Desktop

---

## Slide 1 — Title · 1 min · *S5 v2 1*

**DATA SESSION 5 · WELCOME WEEK INDIA 2026 · THURSDAY, OCTOBER 8 · 2:00 – 3:30 PM**

# Publication: reports & replicability

*If nobody can rerun it, it isn't a result.*

Sneha [surname] – co-lead · David Torres Leon – Data Manager
Development Innovation Lab · Welcome Week India 2026

> **Notes:**
> - 90 minutes. Session 4 (11:30 AM) went from raw data to a first exploratory report; this session makes results publishable and reproducible.
> - Suggested split (from S5 v2): Sneha takes Part 02 (exhibits, including her own workflow) and Part 05; David takes Parts 01, 03, 04 and 06 and runs both exercises. Agree before Thursday.
> - Open with the one-liner: the deliverable of a study is not a table, it's a package a stranger can rerun. Two hands-on blocks, about 40 of the 90 minutes, laptops open from the start.

---

## Slide 2 — By the end of this session, you'll be able to… · 2 min · *S5 v2 2, adapted*

- Write analysis scripts a stranger can read and rerun
- Polish tables and figures into exhibits that stand on their own
- Name where replicability breaks, and prevent it
- Turn results into a report where no number is typed
- Build a replication package a stranger can run with one command
- Check a paper against its PAP, and know which checks to keep for yourself

**Every claim in a paper is a citation or an exhibit. Every exhibit is produced by code.**

> **Notes:**
> - Frame the arc: write → polish → protect → automate → package → submit.
> - The last objective is the one to say slowly: this session doesn't walk through the checklist, it makes them run it.
> - Plant the rule at the bottom here; it comes back in Part 06.
> - Timing: Part 01 8 min · Part 02 10 · Part 03 9 · Part 04 19 (Exercise 1) · Part 05 7 · Part 06 30 (Exercise 2) · wrap-up 4. The first parts are fast, the middle is hands-on, and the last part is the longest because it's the newest material.
> - S5 v2's agenda slide is dropped (as in Session 4); say the shape out loud instead.

---

## Slide 3 — Section divider · **NEW**

**01 · Analysis code**
Scripts your reader, and your future self, will thank you for
~8 minutes

---

## Slide 4 — What a good analysis script looks like · 2 min · *Copy 19 + Copy 20*

- **Starts fresh:** clean workspace, loads the analysis data
- **Does one thing:** one table or one figure
- **Decisions at the top:** outcomes, controls, samples
- **Defined once, used everywhere (DRY)**
- **Easy to change:** one edit, rerun, everything follows

> **Notes:**
> - When it comes to coding, analysis is usually the easy part. Keep it that way.
> - **Starts fresh:** nothing depends on whatever you ran an hour ago.
> - **Does one thing:** runs a regression, builds a table, draws a graph, then exports the result. One script per output beats one 2,000-line monster (modularity).
> - **Decisions at the top:** research choices sit in plain sight, not buried in line 400. Simple code lets the reader focus on the economics, not the plumbing.
> - **DRY:** every piece of knowledge has one authoritative home. This is the fix for "No single source of truth" from Session 4: define outcomes, controls and samples once, and retrieve them everywhere.
> - **The payoff:** when the outcome list changes, you change one line, and every table, figure and appendix follows.

---

## Slide 5 — In practice · 2 min · *Copy 18*

- **Inputs in one place:** a settings file every script loads
- **Functions for the boring parts:** themes, table formats
- **Names that connect:** script ↔ exhibit
- **Assumptions become assertions**

> **Notes:**
> - **Inputs in one place:** outcomes, controls and samples defined once, at the top or in their own file (`00_settings.R`, a globals `.do` file), and retrieved when needed.
> - **Functions for the boring parts:** graphics themes and table formatting standardized once, so the research code stays short. This is also where the exhibit style lives (Part 02).
> - **Names that connect:** file names and outlines map each script to the exact table or figure it produces (`03_table2_chlorine.R` → `table2_chlorine.tex`).
> - **Assertions:** `assert` (Stata) and `assert_that()` (R) make the script stop loudly when the data isn't what you believed. Same principle as Session 4: turn silent bugs into loud ones.

---

## Slide 6 — Don't reinvent the wheel · 1 min · *Copy 17*

- **Canned beats custom**
- **Write from scratch only when there's no other way**
- **Not sure? Test it against another implementation**

> **Notes:**
> - Established packages are reviewed, tested, and handle errors you haven't thought of yet.
> - This matters more with AI: assistants happily write a custom estimator or standard-error correction from scratch. Ask for the established package instead, and check the result against a second implementation if you're not sure.

---

## Slide 7 — What reproducible code looks like · 3 min · *Copy 21* **(placeholder — replace with a real DIL script)**

```r
# Table 2: effect on free chlorine ---------------------------------------
# Input:  data/analysis/hh_analysis.rds
# Output: output/tables/table2_chlorine.tex

pacman::p_load(tidyverse, here, fixest, modelsummary, assertthat)
source(here("code", "00_settings.R"))

hh <- read_rds(here("data", "analysis", "hh_analysis.rds")) %>%
  filter(sample_main)

assert_that(nrow(hh) == n_expected_main)

models <- map(
  outcomes_chlorine,
  ~ feols(reformulate(c("treat", controls_main), .x), data = hh)
)

modelsummary(models, output = here("output", "tables", "table2_chlorine.tex"))
```

> **Notes:**
> - What to point at: a header that says what it makes; inputs and the output declared at the top; outcomes, controls and the sample come from the settings file; an assertion that fails loudly; the output path is the only thing the script writes.
> - What's absent matters too: no hardcoded paths, no manual steps, no "run this after commenting out line 12".
> - Stata equivalent: a `**#` header block, `do "code/00_settings.do"`, `use` the analysis data, `assert _N == ${n_expected_main}`, a loop over `${outcomes_chlorine}` with `eststo`, and one `esttab using`.
> - Replace this illustrative script with a real one from a DIL repository before the session.

---

## Slide 8 — Section divider · *S5 v2 4*

**02 · Polishing tables & graphs**
Publication polish, once the story is stable
~10 minutes

> **Notes:** Keep this part brisk; most of the room already half-knows it. Exploratory formatting was covered in Session 4: this part is what happens once the story stops moving.

---

## Slide 9 — Formatting and standardizing outputs · 3 min · *S5 v2 5 (box 01 moved to Session 4)*

- **Self-explanatory:** readable without the paper
- **Master one command:** one for tables, one for graphs
- **Common formats, intentional sizes**
- **Track changes to outputs**
- **Code writes the outputs**

> **Notes:**
> - **Self-explanatory:** if it's going to a PI or into a report, it has to be readable on its own, including long notes on sample, clustering, weighting and specification. An exhibit has to survive being ripped out of the paper.
> - **Master one command:** learn one graph command and one table command properly. It doesn't matter which.
> - **Formats and sizing:** export to tex, csv, png, pdf, jpg, html or svg. Set graph dimensions on purpose rather than inheriting your display window.
> - **Track changes:** every version of every table and graph is under version control, so you can see when a number changed and why.
> - **Code writes the outputs:** a copy-pasted number is a bug. `esttab` / `outreg2` / `putdocx` and `graph export` in Stata; `modelsummary` / `kableExtra` / `gt` and `ggsave` in R. This line carries into Exercise 1.
> - The test to say out loud: delete every output, run one script, everything reappears.
> - Box 01 of the original slide ("keep exploratory formatting minimal") is now in Session 4.

---

## Slide 10 — What a self-standing exhibit has · 3 min · *S5 v2 6*

**The numbers**
- Estimates and SEs, consistently formatted
- Stars defined · N per column · units

**The context**
- Sample and exclusions · clustering and weights
- Specification in words · control mean

**The plumbing**
- A caption that says what to conclude
- Exported by a script, never edited by hand

**Test: hand it to someone who hasn't read the paper.**

> **Notes:**
> - This is the concrete version of "self-standing": people nod at the principle and then ship tables with no N.
> - Full checklist: point estimate and SE, consistently formatted; stars defined in the note, not assumed; N per column, not just overall; units in the row or column header; what the sample is and what was excluded; clustering level and weighting; the specification in words, not just a model number; control mean or baseline, so the effect has a scale; a caption that says what the reader should conclude; numbered and referenced in the text; exported by a script to a fixed filename; regenerated, never edited by hand.
> - If they have to ask what the sample is, it isn't finished.
> - Every item is planted somewhere in Exercise 2's paper draft. Say so at the end: "you'll meet all of these again at 2:50, and a model will find most of them faster than you."
> - Do it live if you can: pull up a recent DIL table and run the three groups over it.
> - **With AI:** this is the part AI makes cheap. Once the content is settled, an assistant can apply this checklist to your export code in minutes. The content decisions (which sample, which specification, what the caption concludes) stay yours.

---

## Slide 11 — The exhibit toolkit · 2 min · *S5 v2 7*

| | **Stata** | **R** |
|---|---|---|
| Tables | `esttab`, `outreg2`, `putdocx` | `modelsummary`, `kableExtra`, `gt` |
| Graphs | `graph export` + a scheme | `ggplot2` + `ggsave` |
| Style | one style `.do` file | one `theme_project()` |

**One style file per project, used by every script.**

> **Notes:**
> - Same job, two ecosystems. Learn one column deeply rather than both badly.
> - Stata also has `estout`, `putexcel`; R has `stargazer`, `huxtable`, `kable`. Save `ggsave` outputs at a fixed width and height.
> - Ask the room which column they live in: it tells you how to pitch Part 04.
> - The style-file habit is the practical takeaway: people hand-format because there's no shared style to inherit. Changing a font should be one edit, not forty.

---

## Slide 12 — An exhibit skill, so nobody formats from scratch · 2 min · *S5 v2 8*

**Proposed:** a Claude skill that produces DIL-standard tables and figures

- Returns export code in our house style, Stata or R
- Enforces the self-standing checklist
- Versioned in one place, so a new RA inherits it on day one

> **Notes:**
> - From David's comment on the polishing section: "Sneha has a skill for this type of workflow. We can ask her for this and create one (figures, graphs, tables)." Action item: owners David and Sneha.
> - Why a skill and not a snippet: a snippet gets copied and drifts; a skill is versioned in one place, carries the standard, and is reviewable (the style is a file, not a habit). Same logic as the SurveyCTO skill from Monday, and the checklist skill at the end of Part 06.
> - Same exhibit twice should give the same file.
> - If the skill exists by October, demo it for 60 seconds and drop the "proposed" framing. Otherwise present it as the direction. Say: "this is the pattern, and you'll build one yourself on Friday."

---

## Slide 13 — Section divider · *S5 v2 9*

**03 · Dangerous steps**
Your code runs. Will it give the same answer twice, on someone else's machine?
~9 minutes

> **Notes:** These are the places replicability quietly breaks: the silent-bug principle from Session 4, applied to time and machines. Keep the pace up: the checklist, the prescription, then a two-minute race.

---

## Slide 14 — The replicability checklist (1/2) · 1.5 min · *S5 v2 11*

**Randomness**
- No seed
- Unstable sort
- Software version changes the draws

**Environment**
- Hardcoded paths
- Uninstalled or unpinned packages

> **Notes:**
> - These two travel badly between machines.
> - **No seed:** bootstraps, simulations, random assignment. Pin every draw with `set seed` / `set.seed()`.
> - **Unstable sort:** ties are broken differently each run; add a unique tie-breaker to every sort.
> - **RNG version:** same seed, different draws across software versions. Set the version explicitly.
> - **Hardcoded paths:** machine-specific paths scattered through the code. Use one global (Stata) or `here()` (R), set in one place.
> - **Dependencies:** user-written commands the script never installs, or whose versions are unpinned, so a clean machine dies or, worse, a machine that has them gives different numbers.
> - Read the headers, not the sentences. Optional opener if the room is quiet: ask two people for a result they couldn't reproduce and what caused it (S5 v2 "story time", now cut for time).

---

## Slide 15 — The replicability checklist (2/2) · 1.5 min · *S5 v2 12*

**Hidden state**
- Manual edits
- Run-order dependence
- Untracked outputs

**Data & locale**
- Encoding, dates, decimal separators
- Duplicate keys in merges

> **Notes:**
> - These two travel badly through time.
> - **Manual edits:** fixes made by hand in the data or in an output, never in code. The most common and the most invisible. Slow down on this one: people don't think of it as a bug.
> - **Run order:** code that only works top to bottom, on whatever happens to be left in memory.
> - **Untracked outputs:** tables not under version control, so you can't see when a number changed.
> - **Parsing:** encoding, date formats and decimal separators that depend on machine settings.
> - **Merges:** duplicate keys, or an `m:m` merge that silently mismatches rows. Covered in Session 4; name it and move on.

---

## Slide 16 — The five lines that make a run reproducible · 2 min · *S5 v2 13*

```stata
version 18
set seed 20261008
global root "..."
ssc install reghdfe, replace
sort hh_id round
```

```r
pacman::p_load(tidyverse, here)
set.seed(20261008)
renv::restore()
df <- df %>% arrange(hh_id, round)
sessionInfo()
```

**Without these, nothing downstream is reproducible.**

> **Notes:**
> - The checklist is diagnosis; this is the prescription. Most of it collapses into a short header at the top of your master script.
> - **Stata:** `version` pins the RNG and syntax; `set seed` pins every draw; one path global, set in one place; install and pin user-written commands (`ssc install`, or `stata-require` to pin versions); sort on a unique key so ties are stable.
> - **R:** `set.seed()`; `here()` builds paths from the project root; `renv` pins package versions (`renv::snapshot()` records them, `renv::restore()` installs them on a new machine); sort on a unique key; `sessionInfo()` records the environment.
> - Honest caveat: `renv` and version pinning feel like overhead until the first time a package update moves a coefficient.
> - Both exercise packets open with exactly this header; point at it when they get there.

---

## Slide 17 — Two minutes: what threatens replicability here? · 2 min · *S5 v2 14*

```stata
* teammate note: I hand-fixed 3 ages in the .dta first
do "C:/Users/david/water/setup.do"
use "$data/analysis_data.dta", clear
winsor2 treat_chlorine, cuts(1 99) replace
bootstrap r(mean), reps(500): su treat_chlorine
reghdfe treat_chlorine hh_size resp_age, absorb(village_id)
esttab using "$tables/table1.tex", se replace
sort duration_min
keep in 1/10
export excel using "backcheck.xlsx", replace
```

**Shout them out. Name the type, not just the line. There are at least six.**

> **Notes:**
> - Run it from the front as a race, not in pairs: call on people, take answers, keep moving. The four types: randomness, environment, hidden state, data and locale.
> - If the room is silent for ten seconds, point at the comment on line 1: it's the free one, and it unlocks the rest.
> - Don't let this run over. The minutes belong to the exercises.

---

## Slide 18 — Six threats, revealed · 2 min · *S5 v2 15*

| Type | Threat | Fix |
|---|---|---|
| Randomness | No seed; unstable sort; no version | `version` + `set seed`; unique sort key |
| Environment | `C:/Users` path; uninstalled, unpinned packages | One path global; install and pin |
| Hidden state | Hand-edited ages | Never touch data by hand |

**One master script. Never touch data by hand.**

> **Notes:**
> - Take answers from the room first; show the card only after two or three people have offered something.
> - Detail: the bootstrap SEs move every run without a seed; `sort duration_min` has ties, so `keep in 1/10` returns a different ten households each run; without `version`, the RNG shifts between Stata releases. The hardcoded path and a `setup.do` nobody else has break on any other machine; `winsor2` and `reghdfe` are never installed or version-pinned. The hand-edit to three ages lives in no script: invisible, and unreproducible by anyone, including the person who did it.
> - Also worth naming: `table1.tex` is overwritten with no record of what changed, and `backcheck.xlsx` is written to whatever the working directory happens to be.
> - Close Part 03 on the fix, not the problem. Then straight into Part 04.

---

## Slide 19 — Section divider · *S5 v2 16*

**04 · From results to reports**
One source, one report your code writes for you
~21 minutes, including Exercise 1

> **Notes:** The first hands-on anchor: 18 of the 21 minutes. If Part 03 overran, protect the exercise. Files are in `report_exercise/`; distribute them before the session, not during.

---

## Slide 20 — One source, two outputs, then a report · 1 min · *S5 v2 19*

**One model → one table and one figure → one report**

- The estimation lives in exactly one place
- The table and the figure read the same fitted object
- The report runs the same code; you add the prose

**Drop a control: one edit, and both exhibits and the text move together.**

> **Notes:**
> - From David's comment: "use the same source for the table & graph, and then we recycle the same source for this exercise. We turn this code into a report."
> - One duplicated estimation is one place where the table and the figure can drift apart. With one source, they can never disagree, because there's nothing to keep in sync.
> - Link to Session 4: this morning's report already had inline numbers and a `last_week_only` switch. What's new here is the model, and exhibits polished to publication standard. `code/01_analysis.R` in the packet is exactly this pattern: one model object, and both exhibits read from it.
> - S5 v2's "Stata users and R users are not in the same place" slide is cut: Session 4's report exercises are R-only. Stata users can use Quarto with Stata chunks via nbstata; the Stata version of the analysis script is in the packet as a handout.

---

## Slide 21 — EXERCISE 1 · The report that writes itself · 18 min (brief 2 · build 10 · render and flip 4 · debrief 2) · *S5 v2 21, adapted to Session 4*

*In pairs · `report_exercise/` · start from your Session 4 report*

1. **Read the debt:** `static_report.md`, a memo with every number typed. Pick one you don't trust.
2. **Rebuild it:** use the prompt to turn it into `report.qmd`, with the model from `code/01_analysis.R`
3. **Polish:** make the table and figure self-standing
4. **Prove it:** render, flip `last_week_only`, render again

**One number in the memo doesn't reproduce. One sentence can't be reproduced from any data.**

> **Notes:**
> - **The packet:** `static_report.md` (a midline memo whose numbers were typed from a log), `code/01_analysis.R` (one model, one table, one coefficient plot from the same object), and a starter `report.qmd` for anyone who didn't finish Session 4's Exercise 2. The Stata analysis script is included as a handout.
> - **Polish** means the self-standing checklist from slide 10: N per column, control mean, notes on the sample and specification, a caption that says what to conclude. AI can do the formatting; the content decisions are theirs.
> - **The planted faults** (in `facilitator/FACILITATOR_NOTES.md`): the memo says the non-response rate is 3.6 percent and the data say 3.83; the claim "take-up is well above what we assumed at design stage" has no source at all. Watch for pairs who "fix" their code to match the memo: that instinct is what the session is trying to break, and it's worth naming out loud.
> - **Prep:** `report_exercise/` distributed, Quarto installed, the data file opens in R. Test the render yourself the week before: a broken install eats the whole block.
> - **Stretch:** push the exported table and figure to your GitHub repo and pull them into Overleaf: that is the Overleaf exercise on slide 23b.

---

## Slide 22 — The AI step: the prompt · *(said while they open files)* · *S5 v2 22, adapted*

> *Rewrite `static_report.md` as a reproducible Quarto report (`report.qmd`) with R chunks. Every table, figure and in-text number is computed at render, nothing typed, including dates, counts and the median interview length. Use the model in `code/01_analysis.R` for both the table and the figure. Keep the `last_week_only` parameter so it moves every number. At the end, list the numbers in the memo you could NOT reproduce from the data.*

**Two rules:**
1. Every number is inline code. A typed coefficient is a bug.
2. Verify by rendering, flipping the switch, and rendering again.

> **Notes:**
> - Say the two rules before people start, not after: they are the assessment criteria for the exercise.
> - Session 4's rule applies: AI writes the code, never the output. You're the fact-checker of record. Check the rendered output against `code/01_analysis.R`, line by line, the first time.
> - The last line of the prompt, asking which numbers it could NOT reproduce, sets up Part 06: automation handles recall, not judgement.
> - Full prompt: `report_exercise/ai_prompt.txt`.

---

## Slide 23 — Outputs that update themselves · 2 min · *moved from Session 4*

**Code → files → GitHub → Overleaf**

1. Your script exports tables (`.tex`), figures (`.png`) and key numbers
2. You push them to GitHub
3. Overleaf pulls them, and your short report to the PI recompiles with the new results

**Nobody retypes a number. Nobody re-pastes a table.**

> **Notes:**
> - Same principle as inline code in Quarto, applied to a short LaTeX report: the kind of 2–3 page exploratory update a PI reads and comments on in Overleaf. The report is not a paper: a few exhibits, short notes, open questions. As with Quarto, the document only *references* outputs, it never contains typed results. Tables come in with `\input{tables/desc.tex}`, figures with `\includegraphics{figures/outcome.png}`, and numbers in the text with macros written by the code (e.g., `\Nhh`), so the text updates too.
> - When the data or a decision changes: rerun the script, push, pull in Overleaf, recompile. Every exhibit and every number in the text moves together.
> - **With AI:** AI can write the LaTeX around your outputs (the document skeleton, table formatting, the `\input` lines). It never types a result. Same rule as Session 4: AI writes the code, never the output.
> - **How the link works:** an Overleaf project is linked to a GitHub repository (Overleaf menu → GitHub → sync, or create the project via *Import from GitHub*). Changes come in with *Pull GitHub changes into Overleaf*; edits made in Overleaf go back with *Push Overleaf changes to GitHub*.
> - **Access:** GitHub sync is an Overleaf premium feature; it's covered by the licence participants use. If someone's account isn't linked on the day, they can follow along on the facilitator's project on screen.
> - Why Overleaf for this: it's where many PIs already read and comment, and a shared project means they always see the latest results without you emailing PDFs.
> - Session 4 showed this as a 3-minute demo (its slide 19c). Here participants do it themselves in the exercise that follows (slide 23b), with their own Overleaf project.

---

## Slide 23b — EXERCISE 1b · Results that update themselves in Overleaf · 12 min (paths and first run 6 · flag 4 · debrief 2) **(new)**

*Individually or in pairs · `exercise1b/` · Stata (`stata/main.do`) or R (`R/main.R`)*

*Before the session: your Overleaf project is synced with GitHub and cloned on your computer (README steps 1–3)*

1. **Set your paths** to this folder and to your Overleaf clone (next slide)
2. **Run, push, pull** in Overleaf, recompile
3. **Change the flag:** `last_week_only` on. Run, push, pull, recompile

**Every number in the PDF changes. Nobody typed one.**

> **Notes:**
> - The folder is self-contained: `README.txt` (all steps, both languages), `data/` (the clean household and child data, ready to use: no raw data or prep code), `stata/` and `R/` (same logic, identical output files), `overleaf/` and `overleaf.zip` (the PI update, which only `\input`s `tables/numbers.tex`, Table 1 and Figure 1).
> - With the flag off the report covers 1,293 households visited and 1,254 interviewed; on, 452 and 445, from 14 to 20 July. Full expected numbers: `exercises/facilitator/session5_exercise1b_notes.md`.
> - Most common problem: a wrong path to the clone. GitHub Desktop → *Repository → Show in Finder* gives the real one.
> - R users can push from R (`push_to_github <- TRUE`); everyone else uses GitHub Desktop.
> - Without GitHub sync on their Overleaf account, participants run with the folder's own `overleaf/` and upload the three files by hand.

---

## Slide 23c — The lines you change: Stata or R · *(part of the 12 min)* **(new)**

<!-- columns -->

**Stata · `stata/main.do`**

```stata
* Section 1: the switch (0 first, then 1)
global last_week_only 0

* Section 2: copy Nandita's block for yourself
else if "`c(username)'" == "yourname" {
    global ex           "/path/to/exercise1b"
    global report_clone "/path/to/your/overleaf/clone"
}
```

Run: **Do** (Ctrl/Cmd+D) on the whole file

<!-- next column -->

**R · `R/main.R`**

```r
# Section 1: the switch (FALSE first, then TRUE)
last_week_only <- FALSE

# Section 2: copy Nandita's block for yourself
} else if (user == "yourname") {
  exercise_dir <- "/path/to/exercise1b"
  overleaf_dir <- "/path/to/your/overleaf/clone"
}
```

Run: **Source** (Ctrl/Cmd+Shift+S) on the whole file

<!-- end columns -->

**Your username:** `di c(username)` in Stata · `Sys.info()[["user"]]` in R · **Your clone's path:** GitHub Desktop → *Repository → Show in Finder*

> **Notes:**
> - Leave this up while people work: it is the only code anyone edits. Both versions write the same three files, so the rest of the exercise (push, pull, recompile) is identical.
> - Nobody needs to read or change `2-export-outputs`. If someone asks what it does: it reads the clean data in `data/` and writes `numbers.tex`, Table 1 and Figure 1 into the clone.
> - Windows paths: use forward slashes (`C:/Users/...`) in both Stata and R.
> - R users can set `push_to_github <- TRUE` (section 1 of `main.R`) to commit and push from R; everyone else uses GitHub Desktop.

---

## Slide 24 — Section divider · *S5 v2 23*

**05 · Replication package & data publication**
One command, one stranger, one clean machine
~7 minutes

> **Notes:** Reference material. Move briskly: they'll come back to these slides when a paper is actually going out. This is the section to cut if you're behind: say "these slides are in the folder" and skip to Part 06.

---

## Slide 25 — What the package looks like · 2.5 min · *S5 v2 24*

```text
paper-replication/
├── README.md
├── MASTER.do / main.R   <- the one command
├── 01_documentation/    questionnaire, PAP, codebook
├── 02_code/             00-setup, 01-construct, 02-analysis, 03-exhibits
├── 03_data/             raw (or a DOI), clean
└── 04_output/           tables, figures
```

**The README says:** what software, how to run it, how long it takes, which script makes which exhibit, where the data comes from.

> **Notes:**
> - The bar: a stranger on a clean machine reproduces every exhibit with one command.
> - People agree with "write a README" and then write four lines. The full specification: what the paper is, and which version; what software and which versions, exactly; how to run it (the one command, and from where); how long a full run takes, and what it needs; which script produces which numbered exhibit; where the data comes from, and its licence; what a user must supply themselves (restricted data, a key); who to contact, and how to cite.
> - The exhibit-to-script mapping is the item reviewers use most and the one most often missing.
> - `01_documentation/` holds the PAP: that's the handoff into Part 06.

---

## Slide 26 — Publishing the data itself · 2 min · *S5 v2 25*

- **De-identify, again**
- **A real repository, with a DOI**
- **A licence, and a citation**

**At DIL: talk to the data team before a release, not after.**

> **Notes:**
> - The data in the package is a publication too. Treat it like one.
> - **De-identify again:** what was fine internally may still re-identify people once it's public. Review before release, with fresh eyes. "Again" is the word that matters: de-identification for publication is a different bar from de-identification for internal analysis, and much harder to undo once the file is public.
> - **Repository:** a trusted archive with a DOI, not a personal Dropbox link that dies with the project.
> - **Licence and cite:** say what others may do with it, and make it citable. Your data is part of your contribution.

---

## Slide 27 — Past replication packages: let's open real ones · 2.5 min · *S5 v2 26*

- `github.com/DevInnovationLab/i-h2o-meta`
- `github.com/DevInnovationLab/deworming`

**While you scroll:** Where's the one command? Is the data in the repo or behind a DOI? Do outputs map to exhibits? Is there a deviations table?

> **Notes:**
> - Open one live and scroll: two minutes of a real repository beats twenty of principles. Walk the folder structure and the master script of the first; compare the README of the second against slide 25.
> - Also ask: what would you still need to ask the authors for?
> - The deviations-table question is the deliberate handoff into Part 06. Ask it out loud: "does this package tell you what changed between the plan and the paper?"
> - Prep: swap these two for whatever is most relevant to the India cohort's projects, and check both URLs the morning of.

---

## Slide 28 — Section divider · *S5 v2 27*

**06 · Paper-submission checklist & the PAP**
You already know most of the list. So we stop reading it and start running it.
~30 minutes, including Exercise 2

> **Notes:** The longest section, and the one that changed most. David's original note was "be quick on the things people already have in mind". That's now structural: five framing slides in eight minutes, twenty minutes hands-on, then the skill. Say the shape at the top: "the checklist is on the wall behind you; what we're actually doing is working out which half of it you should stop doing by hand."

---

## Slide 29 — One rule, before the checklist · 2 min · *S5 v2 28*

**Every claim in the paper is either a citation or an exhibit.**

- "Take-up was high": compared to what, shown where?
- A magnitude in the abstract that's in no table
- A robustness claim with no robustness exhibit

> **Notes:**
> - Nothing in between. If a sentence asserts something about the world and points at neither a reference nor a table, figure or reported statistic, it isn't yet a claim you can defend. Another example: a mechanism asserted in the discussion and never tested.
> - How to run it: read the paper marking every factual sentence; write the exhibit number or citation beside each one; anything with a blank margin is cut, softened, or given an exhibit. Do this before the co-author read, not after.
> - From David's comment: "every result (exhibit), every claim should be a citation or an exhibit."
> - Slow down here. Then say what makes the exercise land: this rule is mechanical, which is exactly why a model is good at it, and they're about to watch one do it in ninety seconds on a paper they haven't read.

---

## Slide 30 — The DIL paper-submission checklist · 1 min · *S5 v2 29*

1. Proof-read the text
2. Journal guidelines
3. Results and summary tables
4. Graphs and figures
5. –7. Authors, numbering, bibliography
8. **NEW: Compare the results to the pre-analysis plan**

> **Notes:**
> - Name the seven, point at the guide, and move: sections 1–7 are already published and most of the room has met them. Full list: `packet/03_checklist.md` · devinnovationlab.github.io/guides/templates/paper-submission.html
> - Detail for reference: (1) results in the text appear in exhibits, values match, terminology is consistent, no comments left in; (2) word limits, citation style, required disclosures (CONSORT, IRB, data deposit); (3) labels, N, R², control means, SEs not t-stats, notes that define everything; (4) axes and units, readable in black and white, self-contained notes; (5–7) affiliations current, exhibits cited in order, every citation resolves both ways.
> - Land on section 8: it's the new material and what the exercise runs on.
> - Action still open: section 8 was sent to Witold on 25 Aug ("that all sounds sensible"); it still has to be folded into the published guide. Owner: David.

---

## Slide 31 — Compare your results to the pre-analysis plan · 2 min · *S5 v2 30*

- Map each hypothesis to an exhibit
- Report every registered outcome, nulls included
- Match the specification
- Label exploratory analyses as exploratory
- Explain every deviation, in one place

**Enumerate from the plan, never from the paper.**

> **Notes:**
> - Most DIL papers have a PAP, so the comparison is a step in the process, not an optional extra. From David's comment: "Most papers from Michael have PAP. Report the registered outcomes, and have an appendix that lists the deviation from this PAP."
> - **Registered outcomes, nulls included:** a pre-specified outcome missing from the paper is the most damaging thing a referee can find. Worth a beat: it's the one people quietly skip under submission pressure.
> - **Specification:** estimator, controls, clustering level, sample restrictions, and any pre-specified multiple-hypothesis correction.
> - **Exploratory:** analyses decided after seeing the data are labelled exploratory, in the text and in the exhibit title.
> - **Deviations:** an appendix table, not footnotes scattered through the paper.
> - The callout is the most transferable line on the slide, and the design principle behind prompt 2. If you read the paper first, you only find what's in it. Say it twice.

---

## Slide 32 — The deviations appendix · 2 min · *S5 v2 31*

**Five columns come from the documents**
- PAP section · what the plan said · what the paper does · why · where

**Two don't**
- When the decision was made
- Before or after seeing outcome data

**"Before or after" establishes good faith, and no model can fill it.**

> **Notes:**
> - One table, at the back of the paper. It turns an awkward conversation with a referee into a document you already wrote.
> - The five: PAP section number, so a reader can find it; what the plan said, quoted not paraphrased; what the paper does instead; why it changed, where the paper says so; where in the paper the affected result appears.
> - The two that aren't in any document live in the team's memory and the project log. That's why this check can never be fully automated. Fill them in while the deviation is still a choice, not a year later when it has become an accident.
> - This is the pivot of the section: don't rush it. It's the answer to Witold's second question, on screen before the question is asked. Point back here at the debrief.
> - Action: not yet in the published DIL guide. Owner: David, with Witold's review (no changes to the columns on 25 Aug).

---

## Slide 33 — So: should a model run this checklist? · 1 min · *S5 v2 32*

> *"Have you tried throwing this submission checklist at LLMs? … Then the conversation becomes (1) what is the workflow for humans using LLMs with this checklist, (2) which items on the checklist people should do themselves."* — Witold Więcek

**Lane A:** it does it, you spot-check · **Lane B:** it drafts, you decide · **Lane C:** only you

> **Notes:**
> - Full quote: "Have you tried throwing this submission checklist at LLMs? I doubt that people will be doing proof-reading themselves, but LLMs should be close to 100% at it. Then the conversation becomes (1) what is the workflow for humans using LLMs with this checklist, (2) which items on the checklist people should do themselves." Read it out loud; attributing it matters: this exercise exists because Witold asked on Slack on 25 August.
> - **Lane A:** mechanical and fully determined by the documents. Faster and more consistent than you, and it doesn't get bored on page 30. **Lane B:** reading two documents against each other; it gets you a first version, but being wrong is expensive, so you read every row. **Lane C:** the answer isn't in the documents. A model here is guessing, and a confident guess is worse than a blank.
> - Then say what the next twenty minutes are: they answer his second question themselves, on a real packet.
> - Don't pre-fill the lanes here: the filled version is slide 36, after they've done it.

---

## Slide 34 — EXERCISE 2 · Run the checklist with an LLM · 20 min (brief 2 · round 1 7 · round 2 6 · lanes 5) · *S5 v2 33*

*In pairs · `PAP_checklist_exercise/`*

1. **Round 1 · mechanical pass (7 min):** prompt 1 over the paper. Meanwhile, read the abstract and Table 1 yourself, then compare.
2. **Round 2 · PAP pass (6 min):** attach the plan, run prompt 2. Is every registered outcome accounted for?
3. **Debrief (5 min):** sort the checklist items into the three lanes. What did the model tell you confidently that wasn't true?

**Every finding points at a location. "UNKNOWN, ask the team" is a finding.**

> **Notes:**
> - **The packet:** a simulated paper draft, the pre-analysis plan it was written from, and the checklist. Both documents have problems planted in them.
> - **What success looks like:** not finding every problem, but finding where the model beats you, where it needs you, and where it will lie to you.
> - **Prep:** packet distributed, everyone signed in to Claude Desktop. Check this at the start of the session, not at 2:50: it's the single thing most likely to eat the block.
> - **Answer key** in `facilitator/ANSWER_KEY.md`. Know these four: H3 (under-five diarrhoea) is a registered primary outcome that appears nowhere in the paper; the paper runs a simple difference in means where the PAP specified ANCOVA; the household-size subgroup is called pre-specified and isn't in the plan; Table 1 reports a dummy with a mean of 1.04.
> - While circulating, ask one pair the FP1 question: the paper says a 0.197 effect on a 0.152 control mean is a 130 percent increase. Models often flag that as an error. It's correct. Find a pair that accepted the model's "fix": that's the best thing that can happen in this exercise.

---

## Slide 35 — The two prompts · *(left up while they work)* · *S5 v2 34*

**Round 1 · mechanical pass**
Checklist sections 1, 3, 4, 6, 7 only. One table: item · where · what's wrong · how you know · confidence. Only rows you can point at. Then a list: CANNOT VERIFY FROM THESE DOCUMENTS. Find and report only; don't fix.

**Round 2 · PAP pass**
(A) One row for every PAP hypothesis and outcome, including ones missing from the paper. (B) The deviations table: write "UNKNOWN – ask the team" for why, when and before/after unless the paper says so. (C) Every UNKNOWN as a question, and who would know.

> **Notes:**
> - Don't present this slide; leave it up while they work. Copy the prompts verbatim the first time: changing them afterwards is most of the skill.
> - Round 1 detail: "where" is a section or table number or a quoted phrase, never a page number. Round 2 detail: status per row is reported / different spec / not reported / not registered; the deviations table has seven columns; a wrong entry in the last column is worse than a blank one.
> - The design choice to name once, at the debrief: prompt 2 forces the model to enumerate from the PAP rather than the paper, and forbids it from filling the two judgement columns. Those two instructions turn a plausible summary into a usable check.
> - Full text: `packet/04_prompts.md`.

---

## Slide 36 — The three lanes, filled in · 3 min (part of the debrief) · *S5 v2 35*

| **A · It does it** | **B · It drafts** | **C · Only you** |
|---|---|---|
| Text vs exhibit values | Registered outcomes vs reported | Before or after seeing the data |
| Stars, units, N | Specification vs the plan | When a decision was made |
| Impossible values | Subgroups and corrections | Whether an exclusion was legitimate |
| Citations, numbering | First draft of deviations | Whether a magnitude is plausible |
| Leftover TODOs | | What this journal requires |

**The model does the recall. You do the memory.**

> **Notes:**
> - Put this up only after pairs have filled their own worksheet. Argue with it: the disagreements are the useful part.
> - Full lists: A also includes terminology drift and exhibit order (spot-check two rows). B also includes sample and exclusions vs the plan (read every row). C also includes whether someone outside the team has read it.
> - Take the second worksheet question out loud, "what did the model tell you confidently that was wrong?", and collect three answers. Almost every room produces the journal one: asked to check section 2, models state a word limit or declare CONSORT required, with no source. That's why "check journal guidelines" is Lane C even though it looks mechanical.
> - Close on the bottom line and let it sit: it's the answer to Witold's second question in six words. It also echoes Session 4's slide on interpreting results: whether a magnitude is plausible is your judgement, not the model's.

---

## Slide 37 — From an exercise to a skill you keep · 2 min · *S5 v2 36*

**`skill/paper-submission-check/`** is in the packet: a first draft

- Carries the checklist and both prompts as one workflow
- Every finding names a location; unknowns stay UNKNOWN
- Try it on a paper of yours, and tell us what it missed

> **Notes:**
> - You just pasted two prompts; nobody will do that on a Tuesday in March. The skill carries the checklist (so it can't drift from the guide), the two prompts as one workflow, the location rule, the refusal to guess, and a closing section on what the check can't tell you.
> - Next steps: run it against three DIL papers that already went through submission and count catches, misses and inventions; fold section 8 into the guide first so the skill and the guide agree; decide whether the deviations table comes out as LaTeX for the appendix.
> - The second half of Witold's message was "I wonder if it would make for a good agent workflow". This is the answer, and it's deliberately unfinished. Owner: David. Reviewer: Witold.
> - Point forward to Friday 10:45, "Improve your AI usage", where they build a skill of their own. This is the worked example to steal from.
> - Prep: confirm the skill loads in Claude Desktop, and decide on a 60-second demo. If it works, demo it: it's the strongest minute of the session.

---

## Slide 38 — Wrap-up · 4 min · *S5 v2 37, adapted*

**Questions? Go make something a stranger could rerun.**

- Analysis scripts that are readable, modular and safe to change
- Exhibits that stand on their own, written by code
- The replicability killers, and the header that prevents them
- One source → a table, a figure and a report in one command
- A replication package, and a paper checked against its PAP

*Every claim is a citation or an exhibit. The model does the recall; you do the memory.*

> **Notes:**
> - Recap the takeaways. Close on both halves of the callout: "every claim is a citation or an exhibit" is the rule from slide 2; "the model does the recall, you do the memory" is what they just proved to themselves.
> - Tie back to Session 4: the silent-bug principle and "AI writes the code, never the output" run through both sessions.
> - Last ask, if there's time: anyone who runs the skill on a real paper this month, send David what it missed.
> - Guide: devinnovationlab.github.io/guides/templates/paper-submission.html
