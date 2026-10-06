# a-ww-datatrack2026

Teaching repository for the DIL Welcome Week "Data Ingestion, Cleaning & Tidying" session. It walks through a mock pipeline that takes a deliberately messy raw export of a household water/chlorine survey and turns it into tidy, labeled, de-identified Stata datasets, ready for a follow-up High-Frequency Checks (HFC) session.

**The one rule the pipeline follows:** each step changes the *shape* and *format* of the data, never its *content*. Duplicates, outliers, and contradictions found in the raw data are intentionally left in place — finding and acting on them is out of scope for this pipeline.

**Contents**
- [How to run](#how-to-run)
- [Pipeline](#pipeline)
- [Description of programs/code](#description-of-programscode)
- [List of datasets](#list-of-datasets)
- [Exercises](#exercises)
- [Known inconsistencies](#known-inconsistencies)
- [Repository structure](#repository-structure)

## How to run

1. Open [main.do](main.do) and add your username/file path under **"2 Set file paths"** (`di c(username)` shows your machine's username).
2. Toggle the `import` / `deidentify` / `tidy` / `clean` locals at the top of the file to `1` for the stages you want to run.
3. Run `main.do`. It sets `adopath` to the project's `code/ado` folder (so the user-written commands below are found without an internet install) and calls the scripts in [code/](code) in sequence.

Note: `04-codebook-verify.do`, the last step `main.do` runs, is stale relative to the rest of the pipeline (it targets files/variables from an earlier version of this exercise) and will not run successfully as-is — see [Known inconsistencies](#known-inconsistencies).

### Software requirements

- Stata 15+ (`ieboilstart` pins version-specific settings at the top of `main.do`).
- User-written commands from the `ietoolkit`/`iefieldkit` family, vendored in [code/ado/i](code/ado/i) (`iesave`, `iecodebook`, `ieboilstart`, etc.) — `main.do` points `adopath` at this folder, so no package install is needed.

## Pipeline

```
data/raw/household_water_questionnaire__v1.csv
        │
        ▼  1-import.do
data/raw/household_water_questionnaire.dta
        │
        ▼  2-deidentify.do
data/raw/household_water_questionnaire-deid.dta   (+ PII crosswalk kept in data/raw)
        │
        ▼  3-tidy.do
data/tidy/household-tidy.dta          data/tidy/child-tidy.dta
        │                                     │
        ▼  4-clean-household.do               ▼  5-clean-child.do
data/clean/household-clean.dta        data/clean/child-clean.dta
documentation/data-dictionaries/      documentation/data-dictionaries/
  household-clean.xlsx                  child-clean.xlsx
        │                                     │
        └───────────────────┬─────────────────┘
                             ▼  04-codebook-verify.do
              Excel codebook + HFC-readiness checks (console output)
```

## Description of programs/code

All paths below are relative to [code/](code).

### [1-import.do](code/1-import.do)
- **Input:** `data/raw/household_water_questionnaire__v1.csv` — the raw partner export: banner/junk formatting, every column read as text, two different date formats.
- **Task:** Imports the CSV with all columns forced to string (`stringcols(_all)`), so Stata never guesses a type on a messy file, then `destring`s the numeric-looking columns and saves a working `.dta`.
- **Output:** `data/raw/household_water_questionnaire.dta` (id: `key`) + an auto-generated `iesave` report, `data/raw/household_water_questionnaire.md`.

### [2-deidentify.do](code/2-deidentify.do)
- **Input:** `data/raw/household_water_questionnaire.dta`.
- **Task:** Separates direct identifiers (`devicephonenum`, `gps`, `child_name_*`) into a standalone crosswalk (in a real project this would live in encrypted storage), then drops them from the working data.
- **Output:**
  - `data/raw/household_water_questionnaire-crosswalk-PII.dta` — `key` + PII columns only.
  - `data/raw/household_water_questionnaire-deid.dta` — de-identified working data, + `data/raw/household_water_questionnaire-deid.md` report.

### [3-tidy.do](code/3-tidy.do)
- **Input:** `data/raw/household_water_questionnaire-deid.dta`.
- **Task:** The survey arrived wide, with one household row holding up to three children's data (`child_age_1..3`, `diarrhea_2d_1..3`, `diarrhea_7d_1..3`). Splits the file into a household-level table and a child-level table (reshaped long, one row per child), checking ID uniqueness and expected observation counts before and after the reshape.
- **Output:**
  - `data/tidy/household-tidy.dta` (id: `key`) + `data/tidy/household-tidy.md`.
  - `data/tidy/child-tidy.dta` (id: `key child_index`) + `data/tidy/child-tidy.md`.

### [4-clean-household.do](code/4-clean-household.do)
- **Input:** `data/tidy/household-tidy.dta`.
- **Task:** Brings the household table to analysis-ready format without changing any values:
  - encodes `enumerator`/`deviceid` as labeled categorical variables;
  - parses `submissiondate`/`starttime`/`endtime` strings into Stata `%tc` datetimes;
  - recodes numeric sentinel missing codes (`-666`, `-888`, `-999`) into Stata extended missing values (`.o`/`.r`/`.k`);
  - value-labels categorical variables (consent, sex, education, water source, storage container, safety/satisfaction scales), reclassifying "other, specify" write-ins into existing or new categories (e.g. river/truck/rain water sources, plastic-drum containers);
  - adds `.d`/`.r`/`.o` ("Don't know"/"Refused"/"Other") extended-missing labels to every label definition created.
- **Output:** `data/clean/household-clean.dta` + `data/raw/household.md` report, and a mini-codebook exported to `documentation/data-dictionaries/household-clean.xlsx` (via `iecodebook export`).

### [5-clean-child.do](code/5-clean-child.do)
- **Input:** `data/tidy/child-tidy.dta`.
- **Task:** Labels the child-level variables (`child_age`, `diarrhea_2d`, `diarrhea_7d`) and the `key`/`child_index` ID pair.
- **Output:** `data/clean/child-clean.dta` + `data/clean/child-clean.md` report, and a mini-codebook exported to `documentation/data-dictionaries/child-clean.xlsx`. *(Not present as of this writing — either not yet run, or its outputs weren't committed; see [Known inconsistencies](#known-inconsistencies).)*

### [04-codebook-verify.do](code/04-codebook-verify.do)
- **Input (as currently written):** `data/clean/households.dta` and `data/clean/containers.dta`.
- **Task:** Intended as the pipeline's final QA gate — exports a one-row-per-variable mini codebook to Excel, then runs an "HFC-readiness check": expected row count, no leftover PII columns, unique row key, harmonized Yes/No values, `chlorine_mgl` numeric, and a uniquely-identified container table.
- **Output:** Excel codebook at `${codebook_excel}` (global not defined anywhere in this repo) + pass/fail messages printed to the console.
- **Status:** stale relative to the rest of the pipeline — see [Known inconsistencies](#known-inconsistencies).

### [4-clean.do](code/4-clean.do)
Not called from `main.do`. Its first 145 lines duplicate `4-clean-household.do`, followed by an unreachable `exit` and leftover teaching-exercise stubs (`households.dta`, `containers.dta`, `chlorine_mgl`, `treats_water`, ...) from an earlier version of this exercise. Looks like a superseded draft left in the repo by accident rather than an active pipeline step.

## List of datasets

### Raw data

| Data set | Location | Unit of observation | Key | Created by |
|---|---|---|---|---|
| Raw CSV export | `data/raw/household_water_questionnaire__v1.csv` | Household (wide, incl. up to 3 children) | `KEY` | Partner/survey platform export |
| Imported | `data/raw/household_water_questionnaire.dta` | Household (wide) | `key` | `1-import.do` |
| De-identified | `data/raw/household_water_questionnaire-deid.dta` | Household (wide) | `key` | `2-deidentify.do` |
| PII crosswalk | `data/raw/household_water_questionnaire-crosswalk-PII.dta` | Household | `key` | `2-deidentify.do` |

### Tidy data

| Data set | Location | Unit of observation | Key | Created by |
|---|---|---|---|---|
| Household tidy | `data/tidy/household-tidy.dta` | Household | `key` | `3-tidy.do` |
| Child tidy | `data/tidy/child-tidy.dta` | Household-child | `key`, `child_index` | `3-tidy.do` |

### Clean data

| Data set | Location | Unit of observation | Key | Main variables | Created by |
|---|---|---|---|---|---|
| Household clean | `data/clean/household-clean.dta` (+ codebook at `documentation/data-dictionaries/household-clean.xlsx`) | Household | `key` | Respondent demographics, water source, storage practices, treatment behavior, perceived safety/satisfaction | `4-clean-household.do` |
| Child clean | `data/clean/child-clean.dta` (+ codebook at `documentation/data-dictionaries/child-clean.xlsx`) | Household-child | `key`, `child_index` | Child age, diarrhea in past 2/7 days | `5-clean-child.do` (outputs not yet present) |

## Exercises

Hands-on exercises live in [exercises/](exercises), one self-contained folder each (`README.txt` with participant instructions, and facilitator notes). They are separate from the pipeline above: `main.do` at the repository root does not run them.

### [explore_exercise](exercises/explore_exercise)
- **Session:** 4, Exercise 2 (syntax on slide 19a, solution on slide 19b). Self-contained, four files, no paths to set. Solution: `exercises/facilitator/explore_exercise_solution.Rmd`.
- **Input:** `exercises/explore_exercise/household_water_clean.csv` (id: `key`) — one row per consenting household, built by `exercises/facilitator/make_exercise_data.R` from the Session 2 export (with `exercises/facilitator/prep-standin.R`), the same construction as the Session 5 Overleaf exercise's data, so the numbers match the Session 5 Overleaf report. Rerun that script (from `exercises/facilitator/`) if the construction changes.
- **Task:** `report.Rmd` has the instructions and the variable list at the top, and the code written with `___` where variable names go: descriptives by water source, a figure, an inline-code sentence, and a `last_week_only` parameter. `hello.Rmd` is the pre-work check.
- **Output:** the knitted `report.html` (not tracked in git).

### [overleaf_exercise](exercises/overleaf_exercise)
- **Session:** 5 (demoed in Session 4, slide 19c). Self-contained: shared with participants as is. Facilitator notes: `exercises/facilitator/overleaf_exercise_notes.md`.
- **Input:** `exercises/overleaf_exercise/data/households_clean.csv` (id: `key`; one row per household visited, including non-consenting ones) and `data/children_clean.csv` (id: `key child_index`). Clean data only: built by `exercises/facilitator/make_exercise_data.R` from the Session 2 export of the same survey (kept in `exercises/facilitator/raw/`; see [Known inconsistencies](#known-inconsistencies)). Participants get no raw data or prep code.
- **Task:** two equivalent versions that write identical outputs:
  - Stata — `stata/main.do` runs `stata/code/2-export-outputs.do`; `ieboilstart` (with `iesave`/`ietoolkit`) is copied into `stata/ado/` from `code/ado/i`.
  - R — `R/main.R` runs `R/2-export-outputs.R` (same logic; can optionally commit and push the outputs to GitHub).
  Participants upload `overleaf.zip` to Overleaf, sync it to a GitHub repository, point the code at their local clone, run, push and pull, then flip `last_week_only` and rerun.
- **Output:** in the participant's Overleaf clone (or `overleaf/` here): `tables/numbers.tex` (one LaTeX command per number quoted in `main.tex`), `tables/tab1-water-practices.tex`, `figures/fig1-chlorination-village.png`.

## Known inconsistencies

The scripts were adapted from an older version of this teaching exercise (built around a differently-named "chlorine testing" dataset with `households.dta`/`containers.dta`/`submission_id`) to the current `household_water_questionnaire` data (`household-tidy.dta`/`child-tidy.dta`, keyed by `key`). That migration is incomplete:

- **`04-codebook-verify.do` still targets the old schema** (`households.dta`, `containers.dta`, `submission_id`, `chlorine_mgl`, `treats_water`, `tested_this_morning`, `water_safe_yn`) instead of the files/variables the current pipeline actually produces (`household-clean.dta`, `child-clean.dta`, `key`, `water_safety`, `hh_watersource`, ...). It won't run successfully against current outputs without a rewrite, and it also references an undefined global, `${codebook_excel}`.
- **`4-clean.do` is very likely dead code** — a pre-migration draft of `4-clean-household.do`, not referenced by `main.do`, containing an unreachable `exit` followed by exercise stubs for variables that don't exist in this dataset.
- **`data/clean/` currently only contains `household-clean.dta`** (its codebook lives in `documentation/data-dictionaries/household-clean.xlsx`) — the child-level outputs described for `5-clean-child.do` are missing entirely, so it either hasn't been run yet or its outputs weren't committed.

- **Two versions of the raw export.** `data/raw/household_water_questionnaire__v1.csv` is an earlier export than the one Session 2's tidying exercise uses (copied to `exercises/facilitator/raw/`, from which the exercises' clean CSVs are built). Same 1,293 submissions and columns, different content: the earlier file has 3 refusals (`consent = 0`) and dates like `7/12/26 4:40`; the Session 2 file has 39 refusals, dates like `Jul 12, 2026 4:04:50 AM`, and the planted HFC problems (e.g. section D blank for most of ENUM05's interviews). The pipeline in `code/` parses only the earlier date format.

- **`.Rprofile` sources `renv/activate.R`, but the repository has no `renv/` folder**, so starting R from the repository root (e.g. opening it as an RStudio project) prints an error. Either add the renv setup or remove the line.

If you pick this pipeline back up: treat `1-import.do` → `2-deidentify.do` → `3-tidy.do` → `4-clean-household.do` → `5-clean-child.do` as the source of truth, and rewrite `04-codebook-verify.do` to match before relying on it.

## Repository structure

- [code/](code) — Stata do-files (this repo) plus vendored user-written ado packages in `code/ado/i`.
- [data/raw/](data/raw) — raw CSV export, imported/de-identified `.dta` versions, and the PII crosswalk.
- [data/tidy/](data/tidy) — one file per unit of observation (household, child), reshaped but not yet labeled.
- [data/clean/](data/clean) — analysis-ready, labeled data.
- [output/](output) — reserved for tables/figures; currently empty.
- [exercises/](exercises) — hands-on session exercises, each self-contained (see [Exercises](#exercises)).
- [documentation/](documentation) — the SurveyCTO questionnaire (`Household Water Questionnaire - V1.xlsx`), plain-text project documentation, and `data-dictionaries/` (the Excel mini-codebooks `iecodebook` exports for each clean dataset).

See [CONTRIBUTING.md](CONTRIBUTING.md) for the general DIL folder-structure/workflow conventions this repo is based on, and [CLAUDE.md](CLAUDE.md) for guidance on keeping this README in sync with the code.
