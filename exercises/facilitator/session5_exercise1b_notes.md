# Facilitator notes · Session 5 Overleaf exercise

*Not part of the folder participants get. The exercise itself is `exercises/session5/exercise1b/`; share that folder as is.*

## What participants do (~20 min)

| Min | Step |
|---|---|
| 2 | Upload `overleaf.zip` to Overleaf, recompile |
| 2 | Overleaf: Menu → Sync → GitHub → Create a GitHub repository |
| 2 | Clone it with GitHub Desktop |
| 6 | Set their two paths in `stata/main.do` or `R/main.R`, run, push, pull in Overleaf |
| 4 | Change `last_week_only`, run, push, pull, recompile |
| 4 | Buffer and debrief |

Nothing to pre-create per pair: each participant makes their own Overleaf project and repository in steps 1–2.

## Before the session

- **Run both versions once**, with the flag off and on, and check against the numbers below. Already checked: the R scripts (both settings, plus a push to a test repository) and the Stata do-files (run on 5 October, before the folder was reorganized: run `stata/main.do` once from `exercise1b/` to confirm the paths).
- **Overleaf licence:** GitHub sync is premium. Confirm every participant's account has it. Without it, the README's fallback (upload the three files by hand) still works.
- **Pre-work email:** GitHub account, GitHub Desktop installed, Overleaf account, Stata 15+ or R with `dplyr`, `tidyr`, `ggplot2`, and the folder downloaded.

## Expected numbers

| Command | `last_week_only` off | on |
|---|---|---|
| `\fieldworkStart` – `\fieldworkEnd` | 1 July 2026 – 20 July 2026 | 14 July 2026 – 20 July 2026 |
| `\nVisited` | 1,293 | 452 |
| `\nHH` | 1,254 | 445 |
| `\consentRate` | 97.0 | 98.5 |
| `\shareChlorine` | 69.3 | 69.9 |
| `\meanChlorineDays` | 2.8 | 2.8 |
| `\sharePiped` | 45.5 | 46.0 |
| `\nChildren` | 1,583 | 552 |
| `\diarrheaChlor` | 24.5 | 21.7 |
| `\diarrheaNoChlor` | 25.5 | 31.1 |

Table 1, households (piped / other / all): 567 / 679 / 1,254 off; 204 / 239 / 445 on.

## Things to watch for

- **Wrong path:** the most common problem. In GitHub Desktop, *Repository → Show in Finder* gives the clone's real path.
- **Pulling without pushing**, or **pushing without committing**: GitHub Desktop should show *No local changes* afterwards.
- **Editing `tables/` or `figures/` in Overleaf** causes merge conflicts on the next pull: keep the GitHub version.
- **R's optional push** (`push_to_github <- TRUE`) only runs from the clone itself and only commits the three outputs. If git has no GitHub login, it says so: push from GitHub Desktop.

## Data

Participants get clean data only: `data/households_clean.csv` (one row per household visited, including non-consenting ones, so the report can quote households visited and the consent rate; id `key`) and `data/children_clean.csv` (one row per child under 5; id `key child_index`). No raw data or prep code is in their folder.

Both files (and Session 4's `exercise2/household_water_clean.csv`) are built by `facilitator/make_exercise_data.R`, which runs `facilitator/prep-standin.R` on the Session 2 export in `facilitator/raw/` (de-identify, recode missing codes, construct indicators). Run it from `exercises/facilitator/` if the construction changes, then re-zip both exercise folders. When the course's constructed data exists, build the CSVs from it instead, keeping the same variable names. `facilitator/prep-standin.do` is the old Stata version of the same construction, kept for reference only.
