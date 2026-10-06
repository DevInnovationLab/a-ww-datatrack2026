# exercises

Hands-on exercises for the DIL Welcome Week data sessions, one folder per session. Each exercise folder is self-contained (instructions, clean data, code) and is shared with participants as the zip next to it. Facilitator material (solutions, notes, the script that builds the clean data) is kept separately in [facilitator/](facilitator).

```
exercises/
  session4/
    exercise1/
    exercise2/        + exercise2.zip
  session5/
    exercise1b/       + exercise1b.zip
  facilitator/
```

| Folder | Session | What participants do |
|---|---|---|
| [session4/exercise1](session4/exercise1) | 4 · Exercise 1, construction bug hunt | Run a construction script "written by an AI" (`01_construct.do` or `01_construct.R`) that builds village-level indicators (child diarrhoea, water treatment, storage time) from the course's clean household and child data. It runs without errors but has five bugs, all from problems the clean data really has: a join on `hh_id` (not unique) instead of `key`, a skipped question read as missing, households without children counted as 0, chlorine and boiling days added together, and a "more than 72 hours" code averaged as hours. Participants add an assertion per bug. |
| [session4/exercise2](session4/exercise2) | 4 · Exercise 2 | Fill in an R Markdown template (`report.Rmd`): descriptives by water source, one figure, one sentence with inline numbers, then a `last_week_only` parameter. Same data and indicators as Session 5's exercise 1b. Solution: `facilitator/session4_exercise2_solution.Rmd`. |
| [session5/exercise1b](session5/exercise1b) | 5 · Exercise 1b, GitHub → Overleaf (demoed in Session 4) | Connect their own Overleaf project to GitHub, point the Stata (`stata/main.do`) or R (`R/main.R`) code at their local clone, run and push, then change the `last_week_only` flag and watch every number in the Overleaf report update. Notes: `facilitator/session5_exercise1b_notes.md`. |

The clean data for Session 4's Exercise 2 and Session 5 is built by `facilitator/make_exercise_data.R`. After changing anything in an exercise folder, re-zip it from its session folder, e.g. `cd exercises/session4 && zip -r exercise2.zip exercise2`.
