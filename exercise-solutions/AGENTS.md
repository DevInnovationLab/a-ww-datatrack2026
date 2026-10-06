# Agent Instructions

## Data Source of Truth

For data variable names, labels, and file contents, treat the Box data files as the source of truth. In particular, the constructed `.dta` files in Box should be assumed to align with the `main` branch, while checked-in metadata files or another working branch may lag behind. When there is a mismatch, inspect the Box `.dta` file directly before changing analysis code.

For canonical analysis-code definitions, specifications, and globals, use the `main` branch as the source of truth unless the user explicitly says otherwise.

## Data Storage

Binary data files (`.dta`, `.csv`, raw inputs) are stored in Box and are **not tracked in git**. Git tracks only code and the `.md` metadata files generated alongside each constructed dataset.

The Box folder mirrors the structure of `1-data/` in the repository. When adding a new dataset, create the corresponding subfolder in both locations using the same name.

## Repository Structure

```
1-data/                        — data files (not tracked in git; live in Box)
2-code/                        — all scripts; see 2-code/AGENTS.md for conventions
  20-programs/                 — reusable programs
    ado/                       — Stata ado files
    funs/                      — R helper functions
  21-wrangling/                — data processing, one subfolder per source
  22-power/                    — power calculations
  23-randomization/            — randomization scripts and placebo   24-analysis/                 — analysis scripts
    241-exploratory/           — exploratory analysis
    248-appendix/              — appendix analysis tables
    249-main/                  — final paper analysis
3-output/                      — outputs
  31-notebooks/                — rendered Rmd notebooks
  32-overleaf/                 — files synced to Overleaf via the main branch; manuscript text and LaTeX configuration may be edited in Overleaf directly, but tables and figures must be exported from scripts and committed to 321-exhibits/ — never edited in Overleaf
    320-settings/
    321-exhibits/ 
      3210-deprecated/              — exhibits removed from the paper; preserved for reference; broken Overleaf references to files here are acceptable
      3211-tables/
      3212-figures/
      3213-appendix-tables/
      3214-appendix-figures/
    322-reports/
    329-manuscript/            — sections/, appendices/, scrap/ (unused text)
4-documentation/               — project documentation
  41-data/                     — data documentation
    410-data-sources.md        — origin, provider, and access instructions for each raw source
    411-wrangling.md             — cleaning decisions and indicator definitions
    412-data-dictionaries/     — data dictionaries for constructed datasets
  42-power/                    — power calculation documentation (not yet created)
  43-randomization/            — randomization design documentation (not yet created)
  44-analysis.md               — analysis documentation including randomization inference design
```

## Personal context

At the start of each session, check whether a file named `AGENTS.local.md` exists in the repo root. If it does, read and apply it. It contains user-specific context (local paths, personal preferences, in-progress notes) that is not committed to git.

## Checking Repository

When asked to check the repository, follow the checklist in `.context/check-repo.md`.

## R Workflows

Assume that `path_box` and `path_git` are always defined in the user's and lab
members' `.Rprofile` files. Use these existing globals directly; do not redefine
them, check whether they exist, or add fallback paths.

Put all R helper-function files in `2-code/20-programs/funs`. When an R workflow
has a master `.Rmd` or master script, source shared helper files once in the
master setup. Do not source the same helper file again from each individual step
script; those scripts should assume the master has loaded the shared functions.
