# Data dictionary: 121-household-clean

| | |
|---|---|
| **File** | `${data_box}/1-data/12-clean/121-household-clean.dta` (Box) |
| **Created by** | `2-code/21-wrangling/213-clean/2131-clean-household.do` |
| **Input** | `11-tidy/111-tidy-household.dta` |
| **Unit of observation** | Household survey submission, consenting households only |
| **ID** | `key` (SurveyCTO submission ID). `hh_id` is **not** unique: 6 values have two submissions each, kept for the HFC session. |
| **Observations** | 1,254 (the 39 non-consenting submissions are dropped) |
| **Variables** | 31 |
| **Questionnaire** | [`4-documentation/Household_Water_Questionnaire.md`](../../Household_Water_Questionnaire.md). Codes in brackets are question numbers. |
| **Last updated** | 7 October 2026 |

Cleaning changes format, not values. Missing values: `.` is system missing (not asked, or not answered), `.d` is "Don't know" (recoded from -999) and `.r` is "Declined to answer" (recoded from -888). -666 "Other" is a real answer and stays as a labelled value. Duplicates, out-of-range answers and skip-pattern violations are kept as recorded, for the HFC session (see Known data issues).

## Identifiers and metadata

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `key` | SurveyCTO submission ID. Unique row ID. | string | metadata | none |
| `hh_id` | Household ID as entered by the enumerator. Not unique (see above). | numeric ID | A2 | none |
| `village_id` | Village | numeric code (1201–1204, 1301–1304, 1401–1404) | A3 | none |
| `enumerator` | Enumerator ID | string | A1 | none |
| `deviceid` | SurveyCTO device ID | string | metadata | none |
| `starttime` | Interview start | date-time | A5 | none |
| `endtime` | Interview end | date-time | A5 | none |
| `submissiondate` | Date-time the form reached the server | date-time | metadata | none |
| `survey_date` | Date of interview, from `starttime` | date | A5 | none |
| `duration_min` | Interview duration | minutes | H2 (from start and end time) | none |

## Consent (Section B)

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `consent` | Consent to interview. Always 1 in this file. | 1 Yes, 0 No | B1 | none |

## Respondent and household (Section C)

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `resp_age` | Respondent's age | years (form range 18–100) | C1 | as recorded |
| `resp_sex` | Respondent's sex | 1 Male, 2 Female | C2 | as recorded |
| `resp_hh_head` | Respondent is the household head | 1 Yes, 0 No | C3 | as recorded |
| `resp_educ` | Respondent's highest education level completed | 0 None, 1 Primary, 2 Secondary, 3 Tertiary | C4 | `.r` = declined |
| `hh_size` | People living in the household, including children | people (form range 1–20) | C5 | as recorded |
| `hh_children` | Children under 5 in the household. Sets the number of child roster rows (Section G). | children (0 to C5) | C6 | as recorded |
| `hh_watersource` | Main drinking water source | 1 Piped, 2 Protected well, 3 River or stream, 4 Trucked, -666 Other | C7 | `.d` = don't know |
| `hh_watersource_o` | Other water source, specified | text | C8 | only asked if C7 = Other |

## Water storage (Section D)

D2–D7 are only asked if D1 = Yes, so they are missing for households without stored water.

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `stored_yn` | Drinking water stored in the household now | 1 Yes, 0 No | D1 | as recorded |
| `stored_container` | Storage container type, observed or asked | 1 Bucket, 2 Clay pot, 3 Jerry can, -666 Other | D2 | skipped if D1 = No |
| `stored_container_o` | Other container type, specified | text | D3 | only asked if D2 = Other |
| `stored_covered` | Storage container covered (lid or plate), observed or asked | 1 Yes, 0 No | D4 | skipped if D1 = No |
| `stored_clean` | Container washed with soap and water in the past 7 days | 1 Yes, 0 No | D5 | skipped if D1 = No |
| `storage_time` | Hours since the stored water was collected. 99 is a code for "more than 72 hours", not a number of hours: don't average this variable. | hours (0–72), 99 = more than 72 (labelled) | D6 | skipped if D1 = No |
| `stored_chlorine` | Chlorine added to the stored water before storing it | 1 Yes, 0 No | D7 | skipped if D1 = No |

## Water treatment (Section E)

E1 and E2 are separate questions. A day with both chlorine and boiling appears in both, so they can't be added to get days of treatment.

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `treat_chlorine` | Days chlorine was added to drinking water in the past 7 days | days (0–7) | E1 | as recorded |
| `treat_boil` | Days drinking water was boiled in the past 7 days | days (0–7) | E2 | as recorded |
| `treat_notablets` | Household ran out of chlorine tablets in the past 30 days | 1 Yes, 0 No | E3 | as recorded |

## Perceptions (Section F)

| Variable | Definition | Type / unit | Source | Missing values |
|---|---|---|---|---|
| `water_safety` | Perceived safety of drinking water | 1 Very safe, 2 Somewhat safe, 3 Not safe | F1 | `.r` = declined |
| `water_satisfaction` | Satisfaction with drinking water quality | 1 Very satisfied, 2 Somewhat satisfied, 3 Not satisfied | F2 | `.r` = declined |

## Decisions

| Decision | By | Date | Why |
|---|---|---|---|
| Drop non-consenting submissions (39), including 3 with answers after B1 | L. Andrade | 7 Oct 2026 | *to fill in* |
| Recode -999 to `.d` and -888 to `.r`; keep -666 "Other" as a value | *to fill in* | *to fill in* | -666 is a real answer; -999 and -888 are non-responses. |
| Label code 99 in D6 as "More than 72 hours" | *to fill in* | *to fill in* | So it isn't averaged as 99 hours. |

## Known data issues (kept, for the HFC session)

| Issue | Count |
|---|---|
| `hh_id` values with two submissions | 6 (12 submissions) |
| C1 age outside 18–100 | 3 |
| C5 household size outside 1–20 | 2 |
| C6 children under 5 greater than C5 household size | 2 |
| D1 missing | 157 |
| D2 answered although D1 = No | 8 |
| D6 answered although D1 isn't Yes | 10 |
| D6 above 72 but not coded 99 | 2 |
| E1 above 7 days | 3 |
| E2 above 7 days | 2 |
| Interview longer than 120 minutes | 3 |
