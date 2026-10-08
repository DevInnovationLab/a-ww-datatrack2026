# Data dictionary: 139-household-analysis

| | |
|---|---|
| **File** | `${data_box}/1-data/13-construct/139-household-analysis.dta` (Box) |
| **Created by** | `2-code/21-wrangling/214-construct/`: `2141-construct-household.do` (household indicators), `2142-construct-child.do` (child indicators by household), `2149-construct-combine.do` (merge and analysis variables) |
| **Inputs** | `12-clean/121-household-clean.dta`, `12-clean/122-child-clean.dta`, through the intermediate files `13-construct/131-household-indicators.dta` (all clean household variables plus indicators) and `13-construct/132-child-indicators.dta` (one row per household with a roster) |
| **Unit of observation** | Household survey submission, consenting households only |
| **ID** | `key` (SurveyCTO submission ID). The household ID (`hh_id`, in the intermediate files) is **not** unique: 6 values have two submissions each, kept for the HFC session. |
| **Variables** | 23 analysis variables, the treatment assignment (`treatment`) and 1 sample flag (`main_sample`). Variables used only to build them (`hh_id`, `enumerator`, `stored_yn`, `storage_time`, `n_children_roster`, `n_answered_2d`, `n_answered_7d`, ...) are in the intermediate files, and all of them together (42 variables) are in `13-construct/133-household-constructed.dta`, also saved by `2149-construct-combine.do`. |
| **Observations** | 1,254 |
| **Questionnaire** | [`4-documentation/Household_Water_Questionnaire.md`](../../Household_Water_Questionnaire.md). Codes in brackets are question numbers. |
| **Last updated** | 8 October 2026 |

Missing values: `.` is system missing (not asked, or not applicable), `.d` is "Don't know" and `.r` is "Declined to answer". Values outside the questionnaire's ranges (for example, more than 7 days in E1 or E2) are kept as recorded, for the HFC session.

## Identifiers

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `key` | SurveyCTO submission ID. Unique row ID. | string | metadata | none |
| `village_id` | Village | numeric code | A3 | none |
| `treatment` | Village assigned to chlorine access. Made up for teaching, NOT a real RCT: the 6 villages with the highest chlorine take-up are treated (`exercises/facilitator/make-treatment-assignment.do`). Merged from `10-raw/102-treatment/1020-village-treatment.dta`. | 0 Control, 1 Treatment | assignment file | none |

## Respondent and household (Section C)

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `resp_age` | Respondent's age. Stands in for the age of the person responsible for water (see Decisions). | years | C1 | as recorded |
| `resp_sex` | Respondent's sex. Stands in for the sex of the person responsible for water (see Decisions). | 1 = Male, 2 = Female | C2 | as recorded |
| `hh_size` | People living in the household | people | C5 | as recorded |
| `hh_children` | Children under 5 in the household, as reported. This is the analysis count; the roster count is only used to check it. | children | C6 | as recorded |
| `hh_watersource` | Main drinking water source | 1 Piped, 2 Protected well, 3 River or stream, 4 Trucked, -666 Other | C7 | as recorded |

## Water storage (Section D)

D2–D7 are only asked if D1 = Yes (`stored_yn`, in the intermediate file), so they are missing for households without stored water.

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `stored_container` | Storage container type | 1 Bucket, 2 Clay pot, 3 Jerry can, -666 Other | D2 | skipped if D1 = No |
| `stored_covered` | Storage container covered | 1 Yes, 0 No | D4 | skipped if D1 = No |
| `stored_clean` | Container washed with soap in the past 7 days | 1 Yes, 0 No | D5 | skipped if D1 = No |
| `storage_time_cat` | Hours since the stored water was collected, in 12-hour groups. Upper bound included (12 hours is in "0–12"). Code 99 and the 2 answers above 72 that aren't 99 are in "More than 72 hours". | 1 0–12, 2 13–24, 3 25–36, 4 37–48, 5 49–60, 6 61–72, 7 More than 72 hours | D6 | skipped if D1 = No; `.d`/`.r` carried over |
| `stored_chlorine` | Chlorine added to the stored water before storing it | 1 Yes, 0 No | D7 | skipped if D1 = No |

## Water treatment (Section E)

E1 and E2 are separate questions. A day with both chlorine and boiling appears in both, so they **can't be added** to get days of treatment.

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `treat_chlorine` | Days chlorine was added to drinking water in the past 7 days | days (0–7) | E1 | as recorded; 3 answers above 7 are kept |
| `treat_chlorine_any` | Chlorine added on at least 1 of the past 7 days (E1 > 0) | 1 Yes, 0 No | E1 | missing when E1 is missing |
| `treat_boil` | Days drinking water was boiled in the past 7 days | days (0–7) | E2 | as recorded; 2 answers above 7 are kept |

## Perceptions (Section F)

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `water_safety` | Perceived safety of drinking water | 1 Very safe, 2 Somewhat safe, 3 Not safe | F1 | as recorded |
| `water_satisfaction` | Satisfaction with drinking water quality | 1 Very satisfied, 2 Somewhat satisfied, 3 Not satisfied | F2 | as recorded |

## Child diarrhoea (Section G, aggregated to the household)

G4 (past 7 days) is only asked if G3 (past 48 hours) = No. A child with diarrhoea in the past 48 hours had it in the past 7 days, so the 7-day measures count those children as Yes (165 children). Children with "Don't know" or "Declined" stay missing.

Shares and any-child indicators are missing for households without children under 5: there's no child to have diarrhoea. Counts are 0 for households with C6 = 0.

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `n_diarrhea_2d` | Children under 5 with diarrhoea in the past 48 hours | children | G3 | 0 if C6 = 0; missing if no roster and C6 > 0 |
| `share_diarrhea_2d` | `n_diarrhea_2d` / children with a G3 answer | share (0–1) | G3 | missing if no child answered |
| `any_diarrhea_2d` | At least one child under 5 with diarrhoea in the past 48 hours | 1 Yes, 0 No | G3 | missing if no child answered |
| `n_diarrhea_7d` | Children under 5 with diarrhoea in the past 7 days | children | G3, G4 | 0 if C6 = 0; missing if no roster and C6 > 0 |
| `share_diarrhea_7d` | `n_diarrhea_7d` / children with a 7-day answer | share (0–1) | G3, G4 | missing if no child answered |
| `any_diarrhea_7d` | At least one child under 5 with diarrhoea in the past 7 days | 1 Yes, 0 No | G3, G4 | missing if no child answered |

## Samples

Sample flags are built in `2149-construct-combine.do`. Analysis scripts use them with `keep if` at the top (one sample per script) or as `if` in each regression (several samples per script); they never define a sample themselves.

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `main_sample` | Main analysis sample: at least one child under 5 (C6 > 0), and non-missing `treat_chlorine_any`, `diarrhea_week_any` and the controls in `${controls}` (`main.do`). 930 households. Rerun construction when the controls change. | 1 Yes, 0 No | C1, C2, C5, C6, E1, G3, G4 | none |

## Decisions

| Decision | By | Date | Why |
|---|---|---|---|
| Drop non-consenting submissions (39 households, and the 2 children listed in 2 of them) in cleaning | L. Andrade | 7 Oct 2026 | *to fill in* |
| Use the respondent's age and sex (C1, C2) for the person responsible for water | L. Andrade | 7 Oct 2026 | The questionnaire doesn't ask who is responsible for water. *Add any further reasoning.* |
| Measure diarrhoea three ways: count, share of children, any child | L. Andrade | 7 Oct 2026 | *to fill in* |
| Group D6 into 12-hour categories, with code 99 as "More than 72 hours" | L. Andrade | 7 Oct 2026 | *to fill in* |
| "Treated with chlorine" = E1 > 0; keep E1 and E2 separate; also keep D7 | L. Andrade | 7 Oct 2026 | *to fill in* |
| Counts of children are 0 (not missing) when C6 = 0 and there's no roster | *to confirm* | 7 Oct 2026 | Section G was skipped because C6 = 0. |
| Number of children under 5 = C6; the roster count is only a check | *to confirm* | 7 Oct 2026 | *to fill in* |
| Analysis dataset keeps only the 23 variables listed here | *to confirm* | 7 Oct 2026 | *to fill in* |

## Known data issues (kept, for the HFC session)

| Issue | Count |
|---|---|
| `hh_id` values with two submissions | 6 (12 submissions) |
| C6 > 0 but no child roster | 2 households |
| Roster count differs from C6 | 1 household |
| E1 above 7 days | 3 households |
| E2 above 7 days | 2 households |
| D6 above 72 but not coded 99 | 2 households |
| G4 answered although G3 = Yes | 8 children |
