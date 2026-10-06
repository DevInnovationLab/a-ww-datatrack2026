# Data dictionary: 131-household-construct

| | |
|---|---|
| **File** | `${data_box}/1-data/13-construct/131-household-construct.dta` (Box) |
| **Created by** | `2-code/21-wrangling/214-construct.do` |
| **Inputs** | `12-clean/121-household-clean.dta`, `12-clean/122-child-clean.dta` |
| **Unit of observation** | Household survey submission, consenting households only |
| **ID** | `key` (SurveyCTO submission ID). `hh_id` is **not** unique: 6 values have two submissions each, kept for the HFC session. |
| **Observations** | 1,254 |
| **Questionnaire** | [`4-documentation/Household_Water_Questionnaire.md`](../../Household_Water_Questionnaire.md). Codes in brackets are question numbers. |
| **Last updated** | 7 October 2026 |

Missing values: `.` is system missing (not asked, or not applicable), `.d` is "Don't know" and `.r` is "Declined to answer". Values outside the questionnaire's ranges (for example, more than 7 days in E1 or E2) are kept as recorded, for the HFC session.

## Identifiers

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `key` | SurveyCTO submission ID. Unique row ID. | string | metadata | none |
| `hh_id` | Household ID as entered by the enumerator. Not unique (see above). | numeric ID | A2 | none |
| `village_id` | Village | numeric code | A3 | none |
| `enumerator` | Enumerator ID | string | metadata | none |

## Respondent and household (Section C)

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `resp_age` | Respondent's age. Stands in for the age of the person responsible for water (see Decisions). | years | C1 | as recorded |
| `resp_sex` | Respondent's sex. Stands in for the sex of the person responsible for water (see Decisions). | 1 = Male, 2 = Female | C2 | as recorded |
| `hh_size` | People living in the household | people | C5 | as recorded |
| `hh_children` | Children under 5 in the household, as reported | children | C6 | as recorded |
| `n_children_roster` | Children under 5 listed in the child roster | children | G (count of roster rows) | 0 when C6 = 0 and there's no roster. Missing when C6 > 0 but there's no roster (2 households). |
| `hh_watersource` | Main drinking water source | 1 Piped, 2 Protected well, 3 River or stream, 4 Trucked, -666 Other | C7 | as recorded |

## Water storage (Section D)

D2–D7 are only asked if D1 = Yes, so they are missing for households without stored water.

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `stored_yn` | Drinking water stored now | 1 Yes, 0 No | D1 | as recorded |
| `stored_container` | Storage container type | 1 Bucket, 2 Clay pot, 3 Jerry can, -666 Other | D2 | skipped if D1 = No |
| `stored_covered` | Storage container covered | 1 Yes, 0 No | D4 | skipped if D1 = No |
| `stored_clean` | Container washed with soap in the past 7 days | 1 Yes, 0 No | D5 | skipped if D1 = No |
| `storage_time` | Hours since the stored water was collected, as recorded. 99 is a code for "more than 72 hours", not a number of hours: don't average this variable. | hours (0–72), 99 = more than 72 | D6 | skipped if D1 = No |
| `storage_time_cat` | Hours since the stored water was collected, in 12-hour groups. Upper bound included (12 hours is in "0–12"). Code 99 and the 2 answers above 72 that aren't 99 are in "More than 72 hours". | 1 0–12, 2 13–24, 3 25–36, 4 37–48, 5 49–60, 6 61–72, 7 More than 72 hours | D6 | same as `storage_time`; `.d`/`.r` carried over |
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
| `n_answered_2d` | Children with an answer to G3 (the denominator of `share_diarrhea_2d`) | children | G3 | missing if no roster |
| `n_diarrhea_2d` | Children under 5 with diarrhoea in the past 48 hours | children | G3 | 0 if C6 = 0; missing if no roster and C6 > 0 |
| `share_diarrhea_2d` | `n_diarrhea_2d` / `n_answered_2d` | share (0–1) | G3 | missing if no child answered |
| `any_diarrhea_2d` | At least one child under 5 with diarrhoea in the past 48 hours | 1 Yes, 0 No | G3 | missing if no child answered |
| `n_answered_7d` | Children with a 7-day answer (G4, or G3 = Yes) (the denominator of `share_diarrhea_7d`) | children | G3, G4 | missing if no roster |
| `n_diarrhea_7d` | Children under 5 with diarrhoea in the past 7 days | children | G3, G4 | 0 if C6 = 0; missing if no roster and C6 > 0 |
| `share_diarrhea_7d` | `n_diarrhea_7d` / `n_answered_7d` | share (0–1) | G3, G4 | missing if no child answered |
| `any_diarrhea_7d` | At least one child under 5 with diarrhoea in the past 7 days | 1 Yes, 0 No | G3, G4 | missing if no child answered |

## Decisions

| Decision | By | Date | Why |
|---|---|---|---|
| Drop non-consenting submissions (39 households, and the 2 children listed in 2 of them) in cleaning | L. Andrade | 7 Oct 2026 | *to fill in* |
| Use the respondent's age and sex (C1, C2) for the person responsible for water | L. Andrade | 7 Oct 2026 | The questionnaire doesn't ask who is responsible for water. *Add any further reasoning.* |
| Measure diarrhoea three ways: count, share of children, any child | L. Andrade | 7 Oct 2026 | *to fill in* |
| Group D6 into 12-hour categories, with code 99 as "More than 72 hours" | L. Andrade | 7 Oct 2026 | *to fill in* |
| "Treated with chlorine" = E1 > 0; keep E1 and E2 separate; also keep D7 | L. Andrade | 7 Oct 2026 | *to fill in* |
| Counts of children are 0 (not missing) when C6 = 0 and there's no roster | *to confirm* | 7 Oct 2026 | Section G was skipped because C6 = 0. |

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
