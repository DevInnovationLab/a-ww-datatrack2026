# Data Session 5 — Publication: reports & replicability

**Slide content, 90-minute session** (slides add up to 87 minutes, including the 5-minute poll on slide 2b, the 8-minute exercise on slide 7, two 5-minute exercises on slides 11–12, the 12-minute Overleaf exercise on slide 23b and the 28-minute hands-on block that closes the session, slide 32) · first draft · follows `session4_session5_split_plan.md` and builds on `session4_slide_content.md`

- **Header on every slide:** PUBLICATION: REPORTS & REPLICABILITY
- **Footer:** Development Innovation Lab / University of Chicago · Publication: Reports & Replicability
- **Sources:** "S5 v2" = DIL_DataSession5_Publication_Reports_Replicability_v2 · "Copy" = 2026_Publication_Reports_Replicability · **NEW** = not in any existing deck
- **Convention:** slide text is kept short; detail, examples and code live in the notes.

## To-dos

- [ ] **Carried over from S5 v2:**
  - [ ] Agree the presenter split
  - [ ] Exhibit skill: get it from Sneha and add how to load it to slide 12 (participants use it hands-on)
- [ ] Example of reproducibility: this project
---

## Slide 1 — Title · 0.5 min · *S5 v2 1*

**DATA SESSION 5 · WELCOME WEEK INDIA 2026 · THURSDAY, OCTOBER 8 · 2:00 – 3:30 PM**

# From analysis to publication

*The output of a study is not just a paper, it's a verifiable set of findings.*

Sneha Nimmaggada – Lead Researcher · David Torres – Data Manager · Luiza Andrade – Data Analytics Lead 
Development Innovation Lab · Welcome Week India 2026

> **Notes:**

---

## Slide 1b — Why we're here · 1 min · **NEW**

**Horror stories**

- The text said one thing. The table said another.

> **Notes:**
> - **Luiza tells her own story (R&R):** while revising a paper for a revise-and-resubmit, she updated the results in the text but didn't update the table. The two didn't match in the version sent to the journal. She had to write to the editors, retract the new draft, and send a corrected version.
> - The point: nothing was wrong with the analysis. The numbers were typed by hand in two places, and only one of them got updated. Part 04 is about making that impossible: every number in the paper comes from the code.

---

## Slide 2 — By the end of this session, you'll be able to… · 0.5 min · *S5 v2 2, adapted*

- Write analysis scripts a stranger can read and rerun
- Polish tables and figures into exhibits that stand on their own
- Name where replicability breaks, and prevent it
- Turn results into a report where no number is typed
- Build a replication package a stranger can run with one command
- Check a paper against its PAP

**Every claim in a paper is a citation or an exhibit. Every exhibit is produced by code.**

> **Notes:**
> - Frame the arc: write → polish → protect → automate → package → submit.
> - The last objective is the one to say slowly: this session doesn't walk through the checklist, it makes them run it.
> - Plant the rule at the bottom here; it comes back in Part 06.

---

## Slide 2b — SPOT THE ISSUES · The analysis script · 5 min **(new)**

*Individually · read only, don't run it*

1. **Open** the analysis script: `exercises/2-code/analysis.do`
   on GitHub: github.com/DevInnovationLab/a-ww-datatrack2026 → `exercises` → `2-code` → `analysis.do`
2. **Vote** in the poll: will it run on your computer? Will it give the same result every time?
3. **List** every issue you find, with its line number

> **Notes:**
> - This is the warm-up: they read the script before any of the content, so the list is their own; Part 01 (slides 4–6) and Part 03 then give names to what they found. For example: a `cd` to a folder on Luiza's computer, an unseeded `bootstrap`, numbers in `numbers.tex` copied from the log, and a table edited by hand in Overleaf. They come back to the same script on slides 11 and 12.
> - Poll in Mentimeter (to be created): two yes/no votes first, then an open list of "issue + line number". Read the votes out before the list: most people say yes to both, and the list is the answer.
> - Read only: nobody needs to run anything. Anyone with the repository cloned can open it locally instead.

---

## Slide 3 — Section divider · **NEW**

**01 · Analysis code**
Scripts your reader, and your future self, will thank you for

---

## Slide 4 — What a good analysis script looks like · 1.5 min

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

## Slide 5 — In practice · 1 min

- **Inputs in one place:** a settings file every script loads
- **Functions for the boring parts:** themes, table formats
- **Names that connect:** script ↔ exhibit

> **Notes:**
> - **Inputs in one place:** outcomes, controls and samples defined once, at the top or in their own file (`00_settings.R`, a globals `.do` file), and retrieved when needed.
> - **Functions for the boring parts:** graphics themes and table formatting standardized once, so the research code stays short. This is also where the exhibit style lives (Part 02).
> - **Names that connect:** file names and outlines map each script to the exact table or figure it produces (`03_table2_chlorine.R` → `table2_chlorine.tex`).

---

## Slide 6 — Don't reinvent the wheel · 1 min

- **Canned beats custom**
- **Write from scratch only when there's no other way**
- **Not sure? Test it against another implementation**

> **Notes:**
> - Established packages are reviewed, tested, and handle errors you haven't thought of yet.
> - This matters more with AI: assistants happily write a custom estimator or standard-error correction from scratch. Ask for the established package instead, and check the result against a second implementation if you're not sure.
> - If you are not sure whether a function does something right, check the output against another sotware (or your own code)

---

## Slide 7 — EXERCISE · Improve the analysis script · 8 min **(new)**

*Individually or in pairs · `exercises/2-code/analysis.do`, the script from slide 2b*

1. **Start from your list** of issues from the poll
2. **Restructure:** a header, decisions at the top, one section per output
3. **Make it stop loudly:** add assertions where you rely on an assumption
4. **Swap with your neighbour:** can they tell what it makes and change one setting?

**Don't change any results yet: only how the script is organized.**

> **Notes:**
> - This is where slides 4–6 turn into practice. Point at them: starts fresh, does one thing, decisions at the top, defined once (DRY), easy to change; settings in one place, functions for the boring parts, names that connect, assumptions as assertions.
> - Good candidates in `analysis.do`: the hardcoded `cd`; the sample restriction commented out mid-script and the `keep if hh_children > 0` buried between the two tables; outcomes and controls retyped in every regression; the winsorizing loop that changes the data silently; `numbers.tex` written from typed values.
> - Assertions to suggest: the merge with treatment matches every household, `village_id` takes 12 values, `treatment` is 0/1.
> - "Don't change results" is the rule from this repository too: restructuring shouldn't move any number. If it does, they've found a bug, which is worth saying out loud.
> - AI is fine here for the restructuring. They check that the outputs are unchanged.

---

## Slide 8 — Section divider 

**02 · Polishing tables & graphs**
Publication polish, once the story is stable
~10 minutes

> **Notes:** Keep this part brisk; most of the room already half-knows it. Exploratory formatting was covered in Session 4: this part is what happens once the story stops moving.

---

## Slide 9 — Formatting and standardizing outputs · 1.5 min

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
> - **Code writes the outputs:** a copy-pasted number is a bug. `esttab` / `outreg2` / `putdocx` and `graph export` in Stata; `modelsummary` / `kableExtra` / `gt` and `ggsave` in R. This line carries into the closing exercise.
> - The test to say out loud: delete every output, run one script, everything reappears

---

## Slide 10 — What a self-standing exhibit has · 1 min

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
> - If they have to ask what the sample is, it isn't finished.
> - Say at the end: they'll use this list on a script in the closing exercise, theirs or ours.
> - Do it live if you can: pull up a recent DIL table and run the three groups over it.
> - **With AI:** this is the part AI makes cheap. Once the content is settled, an assistant can apply this checklist to your export code in minutes. The content decisions (which sample, which specification, what the caption concludes) stay yours.

---

## Slide 11 — EXERCISE · Run the analysis script · 5 min **(new)**

*Individually · `exercises/2-code/analysis.do`, the script from slide 2b*

1. **Fix the bug** that stops the code from running on your computer, if you haven't yet
2. **Run it**
3. **Check the outputs:** which files did it create, and where?
4. **Interpret them:** what does each table and figure say?

**Can you tell what the results mean from the outputs alone?**

> **Notes:**
> - The first thing that breaks is the `cd` to a folder on Luiza's computer. Most people flagged it in the poll on slide 2b; now they fix it.
> - Expect the answer to step 4 to be "not really": `esttab` with default settings, no labels, no notes, no control mean, a figure that's only shown on screen and never saved, and numbers in `numbers.tex` typed from the log. That's the point: compare what they got with the self-standing checklist on slide 10.
> - The toolkit, if anyone asks which commands to use: Stata `esttab` / `outreg2` / `putdocx`, `graph export` and one style `.do` file; R `modelsummary` / `kableExtra` / `gt`, `ggplot2` + `ggsave` and one `theme_project()`. One style file per project, used by every script.

---

## Slide 12 — EXERCISE · Improve it with the exhibit skill · 5 min **(new)**

*Same script · the exhibit skill in Claude*

1. **Use the skill** to improve the tables and figures in `analysis.do`
2. **Run it again**
3. **Explain the results:** what does each exhibit mean now?

**What changed: the code, or how easy it is to read the result?**

> **Notes:**
> - The skill returns export code in the DIL house style, Stata or R, and enforces the self-standing checklist (slide 10). It's versioned in one place, so a new RA inherits it on day one.
> - Why a skill and not a snippet: a snippet gets copied and drifts; a skill is versioned in one place, carries the standard, and is reviewable (the style is a file, not a habit). Same logic as the SurveyCTO skill from Monday, and the checklist skill at the end of Part 06.
> - Debrief in one question: was the second round easier to explain than the first? The analysis is the same; only the exhibits changed.
> - Check: the AI formats, it doesn't decide. Which sample, which specification and what the caption concludes stay theirs.

---

## Slide 13 — Section divider 

**03 · Dangerous steps**
Your code runs. Will it give the same answer twice, on someone else's machine?
~9 minutes

> **Notes:** These are the places replicability quietly breaks: the silent-bug principle from Session 4, applied to time and machines. Keep the pace up: the checklist, then the prescription.

---

## Slide 14 — The replicability checklist (1/2) · 1 min

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
> - **Dependencies:** packages the script never installs, or whose versions are unpinned, so a clean machine dies or, worse, a machine that has them gives different numbers.
> - Read the headers, not the sentences. Optional opener if the room is quiet: ask two people for a result they couldn't reproduce and what caused it.

---

## Slide 15 — The replicability checklist (2/2) · 1 min

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

## Slide 16 — A reproducibility checklist: Stata and R · 2 min

<!-- columns -->

**Stata**

- [ ] `version` set once, in the main script
- [ ] `set seed` before anything random
- [ ] One root path global, set in one place
- [ ] User-written commands in a project `ado` folder
- [ ] `isid` before every sort; no ties
- [ ] Code and outputs tracked in Git

<!-- next column -->

**R**

- [ ] Package versions pinned with `renv`
- [ ] `set.seed()` before anything random
- [ ] Paths from the project root with `here()`
- [ ] `sessionInfo()` saved with the outputs
- [ ] Unique key checked before every sort
- [ ] Code and outputs tracked in Git

<!-- end columns -->

**The test: rerun everything, and Git shows no changes.**

> **Notes:**
> - The checklist on slides 14–15 is the diagnosis; this is the prescription. Most of it is a short header at the top of the main script.
> - **Stata:** `version` pins the random-number generator and the syntax; `set seed` pins every draw (`bootstrap`, `sample`, randomization); one root global, so only one line changes between computers; user-written commands (`reghdfe`, `estout`, `ietoolkit`) installed into a project `ado` folder added to the `adopath`, so everyone runs the same version (`ieboilstart` does `version` and the memory settings in one line); `isid` confirms the sort key is unique, so ties can't reorder between runs.
> - **R:** `renv::snapshot()` records package versions in `renv.lock`, and `renv::restore()` installs them on a new computer; `set.seed()`; `here()` builds paths from the project root, so no `setwd()`; `sessionInfo()` (or `writeLines(capture.output(sessionInfo()), "session-info.txt")`) records the R and package versions next to the outputs; check the key is unique before `arrange()`.
> - **Git, in both:** commit the code and the outputs it writes (`.tex` tables, figures, `numbers.tex`), not just the code. Rerun from scratch: if `git diff` shows any output changed, something isn't stable, and Git tells you exactly which number moved. That's the test at the bottom of the slide, and it's how they answer the poll's second question on slide 2b.
> - Honest caveat: `renv` and version pinning feel like overhead until the first time a package update moves a coefficient.
> - In the closing exercise, this list is the first thing to check in the script they pick.

---

## Slide 19 — Section divider 

**04 · From results to outputs**
One source, one output your code writes for you

> **Notes:** Ends with the Overleaf exercise (slide 23b, 12 minutes). Files are in `exercise1b/`; participants set up their fork, Overleaf project and clone in the pre-work.

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
> - Link to Session 4: this morning's report already had inline numbers. Today the same idea goes into a LaTeX report (slide 23), and they wire it up themselves in the Overleaf exercise (slide 23b).
---

## Slide 23 — Outputs that update themselves · 2.5 min · *moved from Session 4*

**Code → files → GitHub → Overleaf**

1. Your script exports tables (`.tex`), figures (`.png`) and key numbers
2. You push them to GitHub
3. Overleaf pulls them, and your short report to the PI recompiles with the new results

**Nobody retypes a number. Nobody re-pastes a table.**

> **Notes:**
> - Same principle as inline code in R Markdown (Session 4), applied to a short LaTeX report: the kind of 2–3 page exploratory update a PI reads and comments on in Overleaf. The report is not a paper: a few exhibits, short notes, open questions. As with R Markdown, the document only *references* outputs, it never contains typed results. Tables come in with `\input{tables/desc.tex}`, figures with `\includegraphics{figures/outcome.png}`, and numbers in the text with macros written by the code (e.g., `\Nhh`), so the text updates too.
> - When the data or a decision changes: rerun the script, push, pull in Overleaf, recompile. Every exhibit and every number in the text moves together.
> - **With AI:** AI can write the LaTeX around your outputs (the document skeleton, table formatting, the `\input` lines). It never types a result. Same rule as Session 4: AI writes the code, never the output.
> - **How the link works:** an Overleaf project is linked to a GitHub repository (Overleaf menu → GitHub → sync, or create the project via *Import from GitHub*). Changes come in with *Pull GitHub changes into Overleaf*; edits made in Overleaf go back with *Push Overleaf changes to GitHub*.
> - **Access:** GitHub sync is an Overleaf premium feature; it's covered by the licence participants use. If someone's account isn't linked on the day, they can follow along on the facilitator's project on screen.
> - Why Overleaf for this: it's where many PIs already read and comment, and a shared project means they always see the latest results without you emailing PDFs.
> - Session 4 only mentioned this on one slide (its slide 19c), without a demo. Here participants do it themselves in the exercise that follows (slide 23b), with their own Overleaf project.

---

## Slide 23b — EXERCISE 1b · Results that update themselves in Overleaf · 12 min (paths and first run 6 · flag 4 · debrief 2) **(new)**

*Individually or in pairs · `exercise1b/` · Stata (`stata/main.do`) or R (`R/main.R`)*

*Before the session: fork the exercise repository on GitHub, open your fork in Overleaf (New Project → Import from GitHub) and clone it with GitHub Desktop (README steps 1–3)*

1. **Set your one path:** your clone of your fork (next slide)
2. **Run, push, pull** in Overleaf, recompile
3. **Change the flag:** `last_week_only` on. Run, push, pull, recompile

**Every number in the PDF changes. Nobody typed one.**

> **Notes:**
> - **One repository holds everything:** code, data and the report. Participants fork Nandita's repository (github.com/nanditag2548/ww-datatrack-gitoverleaf, the GitHub copy of `exercises/session5/exercise1b/`), import their fork into Overleaf and clone it, so there is only one path to set and the code and the report always travel together. Overleaf only compiles `main.tex` and ignores the code and data.
> - What's in it: `README.txt` (all steps, both languages), `main.tex` (the PI update, which only `\input`s `tables/numbers.tex`, Table 1 and Figure 1), `data/` (the clean household and child data: no raw data or prep code), `stata/` and `R/` (same logic, identical output files).
> - With the flag off the report covers 1,293 households visited and 1,254 interviewed; on, 452 and 445, from 14 to 20 July. Full expected numbers: `exercises/facilitator/session5_exercise1b_notes.md`.
> - Most common problem: a wrong path to the clone. GitHub Desktop → *Repository → Show in Finder* gives the real one.
> - Without GitHub sync on their Overleaf account, participants download the repository as a ZIP from GitHub, run it there and upload the files to Overleaf by hand (README, "If you get stuck").
> - If GitHub Desktop refuses to push ("rejected"), Overleaf pushed something first (e.g. an edit to `main.tex`): Fetch, Pull, then push again.

---

## Slide 23c — The lines you change: Stata or R · *(part of the 12 min)* **(new)**

<!-- columns -->

**Stata · `stata/main.do`**

```stata
* Section 1: the switch (0 first, then 1)
global last_week_only 0

* Section 2: copy Nandita's block for yourself
else if "`c(username)'" == "yourname" {
    global repo "/path/to/your/clone"
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
  repo_dir <- "/path/to/your/clone"
}
```

Run: **Source** (Ctrl/Cmd+Shift+S) on the whole file

<!-- end columns -->

**Your username:** `di c(username)` in Stata · `Sys.info()[["user"]]` in R · **Your clone's path:** GitHub Desktop → *Repository → Show in Finder*

> **Notes:**
> - Leave this up while people work: it is the only code anyone edits. Both versions write the same three files, so the rest of the exercise (push, pull, recompile) is identical.
> - Nobody needs to read or change `2-export-outputs`. If someone asks what it does: it reads the clean data in `data/` and writes `numbers.tex`, Table 1 and Figure 1 into `tables/` and `figures/` of the same repository.
> - Windows paths: use forward slashes (`C:/Users/...`) in both Stata and R.

---

## Slide 24 — Section divider · *S5 v2 23*

**05 · Replication package & data publication**
One click, one stranger, one clean machine

> **Notes:** Reference material. Move briskly: they'll come back to these slides when a paper is actually going out. This is the section to cut if you're behind: say "these slides are in the folder" and skip to Part 06.

---

## Slide 25 — What the package looks like · 1 min · *S5 v2 24*

```text
paper-replication/
├── README.md
├── MASTER.do / main.R   <- the one command
├── 1-data/             raw (or a DOI), clean
├── 2-code/             00-setup, 01-construct, 02-analysis, 03-exhibits
├── 3-output/           tables, figures
└── 4-documentation/    questionnaire, PAP, data dictionaries
```

**The README says:** what software, how to run it, how long it takes, which script makes which exhibit, where the data comes from.

> **Notes:**
> - The bar: a stranger on a clean machine reproduces every exhibit with one command.
> - People agree with "write a README" and then write four lines. The full specification: what the paper is, and which version; what software and which versions, exactly; how to run it (the one command, and from where); how long a full run takes, and what it needs; which script produces which numbered exhibit; where the data comes from, and its licence; what a user must supply themselves (restricted data, a key); who to contact, and how to cite.
> - The exhibit-to-script mapping is the item reviewers use most and the one most often missing.
> - `01_documentation/` holds the PAP: that's the handoff into Part 06.

---

## Slide 26 — Publishing the data itself · 1 min · *S5 v2 25*

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

> **Notes:** The longest section, and the one that changed most. David's original note was "be quick on the things people already have in mind". That's now structural: five framing slides in eight minutes, twenty minutes hands-on, then the skill. Say the shape at the top: "the checklist is on the wall behind you; what we're actually doing is working out which half of it you should stop doing by hand."

---

## Slide 29 — One rule, before the checklist · 1 min · *S5 v2 28*

**Every claim in the paper is either a citation or an exhibit.**

- "Take-up was high": compared to what, shown where?
- A magnitude in the abstract that's in no table
- A robustness claim with no robustness exhibit

> **Notes:**
> - Nothing in between. If a sentence asserts something about the world and points at neither a reference nor a table, figure or reported statistic, it isn't yet a claim you can defend. Another example: a mechanism asserted in the discussion and never tested.
> - How to run it: read the paper marking every factual sentence; write the exhibit number or citation beside each one; anything with a blank margin is cut, softened, or given an exhibit. Do this before the co-author read, not after.
> - From David's comment: "every result (exhibit), every claim should be a citation or an exhibit."
> - Slow down here. This rule is mechanical, which is exactly why a model is good at checking it.

---

## Slide 30 — The DIL paper-submission checklist · 1.5 min · *S5 v2 29*

1. Proof-read the text
2. Journal guidelines
3. Results and summary tables
4. Graphs and figures
5. Authors, numbering, bibliography
6. **NEW: Compare the results to the pre-analysis plan**

> **Notes:**
> - Name the seven, point at the guide, and move: sections 1–7 are already published and most of the room has met them. Full list: `packet/03_checklist.md` · devinnovationlab.github.io/guides/templates/paper-submission.html
> - Detail for reference: (1) results in the text appear in exhibits, values match, terminology is consistent, no comments left in; (2) word limits, citation style, required disclosures (CONSORT, IRB, data deposit); (3) labels, N, R², control means, SEs not t-stats, notes that define everything; (4) axes and units, readable in black and white, self-contained notes; (5–7) affiliations current, exhibits cited in order, every citation resolves both ways.
> - Land on section 8: it's the new material.
> - Action still open: section 8 was sent to Witold on 25 Aug ("that all sounds sensible"); it still has to be folded into the published guide. Owner: David.

---

## Slide 31 — Compare your results to the pre-analysis plan · 1.5 min · *S5 v2 30*

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

## Slide 32 — Section divider · 28 min

**07 · Hands-on: fix it, then publish it**
Your code or ours, one report nobody typed

> **Notes:** The main hands-on block, and the last slide: leave it up while people work. Two options, same finish line: improve `analysis.do` (ours) or a script from their own project, then publish its outputs to an Overleaf report synced with GitHub, as in the Overleaf exercise (slide 23b). Done when they change one thing, rerun, and every number in the PDF moves. If a part overran, take the time from here but keep at least 15 minutes of work.
