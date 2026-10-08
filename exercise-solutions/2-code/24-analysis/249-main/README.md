# 249-main

Final analysis: the scripts that produce the tables, figures and numbers in the paper.

- **Input:** the analysis data, `${data_box}/13-construct/139-household-analysis.dta`. Check each variable in its data dictionary, [`139-household-analysis.md`](../../../4-documentation/41-data/412-data-dictionaries/139-household-analysis.md), before using it. It includes `treatment`, the (made-up, for teaching) village assignment merged in by `2149-construct-combine.do` from `${data_box}/10-raw/102-treatment/1020-village-treatment.dta`, which `exercises/facilitator/make-treatment-assignment.do` builds.
- **Output:** exhibits are exported to `${output}` (`3-output/32-overleaf/321-exhibits/`): tables as `.tex` in `3211-tables/`, figures as `.png` in `3212-figures/`, and key numbers as LaTeX macros in `3213-numbers/`. Never edit exhibits in Overleaf.
- **Rules:** follow [`.context/analysis-rules.md`](../../../.context/analysis-rules.md). Scripts create no variables: add any missing variable to the construction scripts in `2-code/21-wrangling/214-construct/`. Controls, the clustering level and exhibit formatting (table notes, `${esttab_style}`, graph options) are globals in `main.do`. Samples are flags built in construction (`main_sample`, in `2149-construct-combine.do`): `keep if main_sample` at the top of a script when all its exhibits share the sample, or `if` in each regression when they don't. Analysis scripts contain no assertions: data checks go in the wrangling scripts. Report N in every table.

| Script | Produces |
|---|---|
| `2491-first-stage.do` | `3211-tables/table1-first-stage.tex`, `3213-numbers/numbers-first-stage.tex`: chlorine take-up on treatment, on `main_sample` (930 households). |
| `2492-itt.do` | `3211-tables/table2-itt.tex`, `3212-figures/figure1-itt.png`, `3213-numbers/numbers-itt.tex`: diarrhea in the past 7 days on treatment. Same sample as Table 1. Table and figure come from the same stored models. |

Run them from `main.do` (`local analysis 1`). This is the corrected version of `exercises/2-code/analysis.do`, Session 5's bad analysis script.
