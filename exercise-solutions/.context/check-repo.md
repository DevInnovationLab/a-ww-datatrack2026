# Repository Check

## Known Issues

These are already documented — do not re-flag them as new findings.

### Undocumented producing scripts
- `figures/air_filter_dag.svg` — manually created figure, not produced by any script. Do not
  attempt to regenerate it from code.
- `figures/consort-simple.pdf` — no producing script found in the repository.

### Legacy vs. current section tex files
In `329-manuscript/sections/`, the following files are **current** (actively maintained):
`data.tex`, `intervention.tex`, `methods.tex`. The remaining files — `abstract.tex`,
`context.tex`, `design.tex`, `discussion.tex`, `intro.tex`, `results.tex` — are **legacy**
and may have broken `\input{...}` or `\includegraphics{...}` references. Do not flag broken
dependencies in legacy section files as errors; they are known and acceptable.

### Broken tex references in appendices
- `appendices/A2-balance.tex` references 2022-year balance files that do not exist on disk.

### Incomplete pipeline coverage in `Main.do`
The following wrangling subfolders have scripts that are not yet called in `Main.do`.
Each represents an incomplete pipeline step:
- `2-code/21-wrangling/TREBOLA/` — `1-import-monitors-data.do`, `2-clean-monitors-data.do`,
  `3-construct-monitors.do`. This pipeline is incomplete and should be added to `Main.do`
  once finished.
- `2-code/21-wrangling/Classrooms/` — `1-import-classroom.do`, `2-clean-classrooms.do`
- `2-code/21-wrangling/MasterData/` — `1-construct-master-data.do`, `2-track-schools-icfes.do`
- `2-code/21-wrangling/SISAIRE/` — `1-import-sisaire.R`, `2-clean-sisaire.R`, `3-construct-sisaire.R`, `4-construct-stations.R`
- `2-code/21-wrangling/AnalysisData/` — `1-combine-classroom-monitor.do`, `2-test-scores.do`
- `2-code/21-wrangling/Questionnaires/` — `1-construct-july-2026-visits.R`

The following analysis scripts in `249-main/` are not yet called in `Main.do`:
- `attrition.do` — commented out with no reason given
- `itt-all-subjects.do` — unclear whether this produces a final exhibit or is superseded by `itt.do`
- `timeline.R` — produces `figures/timeline.png`; not wired into the pipeline
- `09_Results_allyears.do` — legacy Rosario script kept for reference; do not add to `Main.do`

### `itt-ri.do` runtime
`itt-ri.do` is included in `Main.do` but commented out. It must be run manually before
`itt.do` and takes approximately 24 hours to complete.

### Broken tex reference — attrition table
`3-output/32-overleaf/329-manuscript/main.tex` references
`../321-exhibits/tables/balance/balance-attrition-pooled-2arms` (now in `deprecated/`).
The likely replacement is `../321-exhibits/tables/attrition-student-prepooled-2arms`,
produced by `attrition.do`, but this needs to be confirmed before updating.

### Incomplete script headers
- `2-code/21-wrangling/Questionnaires/1-construct-july-2026-visits.R` — header uses `Data/`
  paths instead of `${data_box}` globals
- `attrition.do` — no header
- `itt-all-subjects.do` — no header
- `2-code/21-wrangling/Classrooms/2-clean-classrooms.do` — title reads "Import classroom data"
  (wrong); Outputs field is blank
- `2-code/21-wrangling/MasterData/1-construct-master-data.do` — Outputs field is blank

### Missing data dictionaries
- Stage 3 (clean) scripts should export a data dictionary to `4-documentation/` documenting
  variable names, labels, and any recoding decisions. None currently exists.
- Stage 4b (construct analysis dataset) scripts should export a data dictionary to
  `4-documentation/` listing each variable's definition, source, and analysis use. None
  currently exists.

### Undocumented exhibit provenance
- `attrition.do` and `itt-all-subjects.do` have no headers, so model specification, sample,
  and indicator definitions are undocumented for the exhibits they produce

### SISAIRE path convention
- `2-code/21-wrangling/SISAIRE/3-construct-sisaire.R` reads shapefiles and coordinates from
  `${path_box}/RawData/` rather than `${path_box}/Data/`, and uses `${path_box}` instead of
  `${data_box}`. These raw geographic inputs are stored outside the standard `Data/` tree and
  are not documented in the File Dependencies table.

### Incomplete `CONTRIBUTING.md`
- `CONTRIBUTING.md` describes environment setup for Stata only. R setup instructions
(package installation, `renv` or equivalent) are missing.

### Undocumented naming conventions
- `3-output/32-overleaf/329-manuscript/sections/` and `appendices/` — no convention
  defined for how manuscript section tex files should be named.
- `2-code/23-randomization/` — no naming convention defined for randomization scripts
  (excluding the legacy `06_Randomization.do`).
- `2-code/22-power/` — no naming convention defined for power calculation scripts
  (excluding the legacy `Incorrect Power Calculations/` subfolder).

### Dataset naming
- `saber11-full.dta` (`ICFES/constructed/`) — `full` is ambiguous as a sample name;
  consider a more descriptive label (e.g. `saber11-all-shifts.dta`)
- `Implementation/clean/sensor-school.dta` — missing source prefix

---

When asked to check or update the repository, perform all of the following checks. Naming conventions, style guide, pipeline stage rules, and file dependencies are in `2-code/AGENTS.md`. Exhibit requirements are in `2-code/24-analysis/249-main/AGENTS.md`.

1. **Folder structure** — compare the current directory tree against the
   Repository Structure section in the root `AGENTS.md` and update it if anything has changed
   (new folders, renamed folders, removed folders).

2. **Main script coverage** — open `Main.do` and verify:
   - Every data processing script in `2-code/21-wrangling/` is called in the
     `wrangling` block (or explicitly commented out with a reason).
   - Every final analysis script in `2-code/24-analysis/249-main/` is called
     in the `analysis` block (or explicitly commented out with a reason).
   - The globals for input/output paths defined in `Main.do` match the paths
     used in each called script's header. Flag any mismatch or missing entry.

3. **File dependencies** — verify that the input/output paths declared in
   script headers match the actual files on disk. Flag any header that points
   to a path that no longer exists or that omits a file the script actually
   reads or writes.

4. **Broken dependencies** — cross-check all path references across scripts
   and tex files against what actually exists on disk:
   - In do-files: every `use`, `merge … using`, `do`, `parallel do`,
     `includefile`, `savetex`, `file open … using`, and `save` path.
   - In tex files: every `\input`, `\include`, and `\includegraphics` path.
   - Compare against the File Dependencies section in `2-code/AGENTS.md` as a
     starting point, but also check any paths not listed there.
   Present the full list of broken references to the user and ask which ones
   to fix before making any changes.

5. **Unmatched data folders** — compare every subfolder of `1-data/` against
   the subfolders of `2-code/21-wrangling/`. Flag any `1-data/` folder that
   has no corresponding wrangling folder (no script is known to produce it) and
   add it to the Known Issues section in the root `AGENTS.md` until it is resolved.

6. **Naming conventions** — check every folder and script against the Naming
   Conventions section in `2-code/AGENTS.md`. Flag any violation. Present
   violations to the user and ask which to fix before renaming anything.

7. **Style guide compliance** — check that all scripts have a standard header
   (title, description, inputs, outputs, author). Flag scripts that are missing
   a header or whose header is incomplete.

8. **Dataset metadata** — for every constructed dataset saved to `1-data/`,
   confirm that a corresponding metadata file (variable labels, source, and
   construction notes) exists in `4-documentation/`. Flag any dataset that
   lacks metadata.

9. **Variable coverage** — for each analysis dataset (stage 4b output, saved to
   `AnalysisData/constructed/`), cross-check variables against all analysis scripts
   in `2-code/24-analysis/249-main/` that use it:
   - Read the `.md` metadata sidecar to get the full variable list.
   - Scan every analysis script for variable references (`use`, `merge … using`,
     regression variable lists, `global` macros expanded in context).
   - **Flag any variable referenced in an analysis script that is not present in
     the dataset** — this is a broken dependency that will cause a runtime error.
   - **Flag any variable in the dataset that is not referenced in any analysis
     script** — this variable should be removed from the stage 4b construction
     script to keep the analysis dataset lean.
   Present both lists to the user before making any changes.

10. **Documentation gaps** — review `4-documentation/` and flag any of the
    following that are missing or out of date:
    - A data sources file (`4-documentation/data-sources.md`) documenting the
      origin, provider, and access instructions for each raw data source
    - A data dictionary covering variable definitions, labels, and sources for
      each constructed dataset
    - An indicator definitions file for each stage 4a construction script, generated
      from script comments. If the script has no comments documenting construction
      choices, ask the user for the relevant documentation before proceeding.
    - Cleaning decision notes for major wrangling scripts (especially ICFES)
    - A description of the randomization design and why standard RI tools
      (`ritest`) could not be used
    - Any other institutional knowledge that exists only in script comments

11. **Exhibit notes** — see `2-code/24-analysis/249-main/AGENTS.md` for requirements.
    For every table and figure in `3-output/32-overleaf/321-exhibits/`, verify that
    the producing script documents the model specification, sample, and indicator
    definitions. Flag any exhibit whose script does not cover all three.

12. **Contributing guidelines** — verify that the current branch follows `CONTRIBUTING.md`:
    - Branch was made from `main` (not from another feature branch).
    - Binary data files (`.dta`, `.csv`, raw inputs) are not staged or committed.
    - Every dataset saved in this branch uses `iesave` (Stata) or `write_meta()` (R), so a
      `.md` sidecar was generated and committed alongside the script change.
    - Output files updated by scripts in this branch are committed (so Overleaf stays in sync).
    - Scripts added or modified follow the style guide and naming conventions in `2-code/AGENTS.md` —
      `AGENTS.md` is the single source of truth; `CONTRIBUTING.md` references it rather than
      duplicating rules. Flag any standard that appears in both files with different wording.
