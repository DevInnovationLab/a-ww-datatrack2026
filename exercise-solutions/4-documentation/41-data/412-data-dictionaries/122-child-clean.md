# Data dictionary: 122-child-clean

| | |
|---|---|
| **File** | `${data_box}/1-data/12-clean/122-child-clean.dta` (Box) |
| **Created by** | `2-code/21-wrangling/213-clean/2132-clean-child.do` |
| **Inputs** | `11-tidy/112-tidy-child.dta`; `12-clean/121-household-clean.dta` (to keep children of consenting submissions only) |
| **Unit of observation** | Child under 5 listed in the household's child roster (Section G) |
| **ID** | `key` + `child_index` |
| **Observations** | 1,585 children in 938 submissions (the 2 children listed in non-consenting submissions are dropped) |
| **Variables** | 5 |
| **Questionnaire** | [`4-documentation/Household_Water_Questionnaire.md`](../../Household_Water_Questionnaire.md). Codes in brackets are question numbers. |
| **Last updated** | 7 October 2026 |

The roster is collected wide in SurveyCTO and reshaped to one row per child in `212-tidy.do`. Household variables (`hh_id`, `village_id`, `enumerator`, ...) aren't in this file: merge on `key` with `121-household-clean.dta` to get them. Submissions with C6 = 0 have no rows here.

Cleaning changes format, not values. Missing values: `.` is system missing (not asked), `.d` is "Don't know" (recoded from -999) and `.r` is "Declined to answer" (recoded from -888). Out-of-range answers and skip-pattern violations are kept as recorded, for the HFC session.

## Variables

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `key` | SurveyCTO submission ID of the child's household | string | metadata | none |
| `child_index` | Child's position in the roster | 1, 2, 3, ... | G (roster order) | none |
| `child_age` | Child's age | months (form range 0–60) | G2 | as recorded |
| `diarrhea_2d` | Diarrhoea in the past 48 hours (3 or more loose or liquid stools in 24 hours) | 1 Yes, 0 No | G3 | as recorded |
| `diarrhea_7d` | Diarrhoea in the past 7 days | 1 Yes, 0 No | G4 | **only asked if G3 = No**: missing by design for children with diarrhoea in the past 48 hours (165 children). Those children did have diarrhoea in the past 7 days; `2142-construct-child.do` fills that in. |

## Decisions

| Decision | By | Date | Why |
|---|---|---|---|
| Drop children listed in non-consenting submissions (2) | L. Andrade | 7 Oct 2026 | *to fill in* |
| Recode -999 to `.d` and -888 to `.r` | *to fill in* | *to fill in* | -999 and -888 are non-responses. |

## Known data issues (kept, for the HFC session)

| Issue | Count |
|---|---|
| G2 age outside 0–60 months | 2 |
| G4 answered although G3 = Yes | 8 |
| Roster count differs from C6 in the household file | 1 household |
| C6 > 0 in the household file but no roster | 2 households |
