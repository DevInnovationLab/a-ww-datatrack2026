This report was created by the Stata command iesave (version 7.5). Read more about this command and the purpose of this report on https://dimewiki.worldbank.org/iesave

- **Number of observations:** 1293
- **Number of variables:** 31
- **ID variable(s):** key
- **.dta version used:** 14
- **Data signature:** 1293:31(31497):296536278:1116545405
- **Last saved by:** User info withheld, see option userinfo in command iesave.
- **Last saved at:** 21:04:24 6 Oct 2026

## Variable type: String

| Name | Label | Type | Complete obs | Number of levels |
|---|---|---|---|---|
| deviceid | "SurveyCTO device ID" | str11 | 1293 | 8 |
| enumerator | "Enumerator ID" | str6 | 1293 | 8 |
| hh_watersource_o | "C8. Other water source (specify)" | str24 | 63 | 9 |
| key | "SurveyCTO submission ID (unique row ID)" | str41 | 1293 | 1293 |
| stored_container_o | "D3. Other container type (specify)" | str12 | 41 | 1 |

## Variable type: Continuous

| Name | Label | Type | Complete obs | Mean | Std Dev | p0 | p25 | p50 | p75 | p100 |
|---|---|---|---|---|---|---|---|---|---|---|
| duration_min | "Interview duration (minutes)" | double | 1293 | 18.14 | 11.13 | .8 | 13.7 | 18.6 | 23.2 | 246 |
| hh_children | "C6. Children under 5 in household" | byte | 1257 | 1.272 | .9884 | 0 | 0 | 1 | 2 | 6 |
| hh_id | "A2. Household ID" | long | 1293 | 1299837 | 81737 | 1201001 | 1203116 | 1302101 | 1401091 | 1404106 |
| hh_size | "C5. People living in household" | byte | 1255 | 5.613 | 2.679 | 2 | 4 | 6 | 8 | 45 |
| resp_age | "C1. Respondent's age (years)" | int | 1249 | 49.97 | 18.67 | 8 | 34 | 50 | 66 | 112 |
| treat_boil | "E2. Days water boiled, past 7 days" | byte | 1249 | 3.001 | 2.394 | 0 | 1 | 3 | 5 | 10 |
| treat_chlorine | "E1. Days chlorine added, past 7 days" | byte | 1248 | 2.819 | 2.528 | 0 | 0 | 2 | 5 | 12 |
| village_id | "A3. Village" | int | 1293 | 1300 | 81.74 | 1201 | 1203 | 1302 | 1401 | 1404 |

## Variable type: Date or date-time

| Name | Label | Format | Complete obs | Unique values | Mean | Std Dev | Min | Median | Max |
|---|---|---|---|---|---|---|---|---|---|
| endtime | "Interview end date-time" | %tcCCYY-NN-DD_HH:MM:SS | 1293 | 1228 | 2026-07-11 03:58:58 | 4.92e+08 | 2026-07-01 07:44:45 | 2026-07-11 02:17:31 | 2026-07-20 18:02:04 |
| starttime | "Interview start date-time" | %tcCCYY-NN-DD_HH:MM:SS | 1293 | 1223 | 2026-07-11 03:40:49 | 4.92e+08 | 2026-07-01 07:29:28 | 2026-07-11 01:57:51 | 2026-07-20 17:57:42 |
| submissiondate | "Date-time the form reached the server" | %tcCCYY-NN-DD_HH:MM:SS | 1293 | 1236 | 2026-07-11 04:46:22 | 4.92e+08 | 2026-07-01 09:09:57 | 2026-07-11 03:05:34 | 2026-07-21 10:29:29 |
| survey_date | "Date of interview (from starttime)" | %tdCCYY-NN-DD | 1293 | 20 | 2026-07-10 | 5.71 | 2026-07-01 | 2026-07-11 | 2026-07-20 |

## Variable type: Categorical

| Name | Label | Value label | Complete obs | Number of levels | Number of unlabeled levels | Top count |
|---|---|---|---|---|---|---|
| consent | "B1. Consent to interview" | yesno | 1293 | 2 | 0 | Yes:1254 No:39 |
| hh_watersource | "C7. Main drinking water source" | watersource | 1249 | 5 | 0 | Piped:568 Protected well:329 River or stream:175 Trucked:114 Other:63 |
| resp_educ | "C4. Respondent's education" | educ | 1247 | 4 | 0 | Secondary:332 None:314 Tertiary:310 Primary:291 |
| resp_hh_head | "C3. Respondent is household head" | yesno | 1249 | 2 | 0 | Yes:631 No:618 |
| resp_sex | "C2. Respondent's sex" | sex | 1255 | 2 | 0 | Male:633 Female:622 |
| storage_time | "D6. Hours since water was collected" | storage | 777 | 15 | 1 | :79 :75 :74 More than 72 hours:70 :67 |
| stored_chlorine | "D7. Chlorine added before storing" | yesno | 775 | 2 | 0 | No:538 Yes:237 |
| stored_clean | "D5. Container washed with soap, past 7 days" | yesno | 775 | 2 | 0 | Yes:436 No:339 |
| stored_container | "D2. Storage container type" | container | 777 | 4 | 0 | Bucket:263 Clay pot:241 Jerry can:232 Other:41 |
| stored_covered | "D4. Storage container covered" | yesno | 775 | 2 | 0 | Yes:578 No:197 |
| stored_yn | "D1. Drinking water stored now" | yesno | 1100 | 2 | 0 | Yes:770 No:330 |
| treat_notablets | "E3. Ran out of chlorine tablets, past 30 days" | yesno | 1249 | 2 | 0 | No:835 Yes:414 |
| water_safety | "F1. Perceived safety of drinking water" | safety | 1251 | 3 | 0 | Somewhat safe:522 Not safe:474 Very safe:255 |
| water_satisfaction | "F2. Satisfaction with water quality" | satisfaction | 1250 | 3 | 0 | Somewhat satisfied:489 Not satisfied:480 Very satisfied:281 |

