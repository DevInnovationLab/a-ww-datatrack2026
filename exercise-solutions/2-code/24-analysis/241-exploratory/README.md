# 241-exploratory

Exploratory analysis: literate reports (R Markdown or Quarto) that render in one command, with the code visible.

- **Input:** the analysis data, `${data_box}/13-construct/139-household-analysis.dta`. Check each variable in its data dictionary, [`139-household-analysis.md`](../../../4-documentation/41-data/412-data-dictionaries/139-household-analysis.md), before using it.
- **Output:** rendered notebooks go to `3-output/31-notebooks/`.
- **Rules:** follow [`.context/analysis-rules.md`](../../../.context/analysis-rules.md). Reports create no variables: add any missing variable to the construction scripts in `2-code/21-wrangling/214-construct/`. Every number in the text is inline code, never typed.
