# 249-main

Final analysis: the scripts that produce the tables, figures and numbers in the paper.

- **Input:** the analysis data, `${data_box}/13-construct/139-household-analysis.dta`. Check each variable in its data dictionary, [`139-household-analysis.md`](../../../4-documentation/41-data/412-data-dictionaries/139-household-analysis.md), before using it.
- **Output:** exhibits are exported to `${output}` (`3-output/32-overleaf/321-exhibits/`): tables as `.tex` in `3211-tables/`, figures as `.png` in `3212-figures/`, and key numbers as LaTeX macros. Never edit exhibits in Overleaf.
- **Rules:** follow [`.context/analysis-rules.md`](../../../.context/analysis-rules.md). Scripts create no variables: add any missing variable to the construction scripts in `2-code/21-wrangling/214-construct/`. Samples, outcomes and control lists are defined once, in a settings file every script loads. Assert N in every model.
