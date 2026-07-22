This report was created by the Stata command iesave (version 7.5). Read more about this command and the purpose of this report on https://dimewiki.worldbank.org/iesave

- **Number of observations:** 1293
- **Number of variables:** 29
- **ID variable(s):** key
- **.dta version used:** 14
- **Data signature:** 1293:29(63685):201837588:3949658091
- **Last saved by:** luizaandrade - DIL-35269
- **Last saved at:** 14:50:08 22 Jul 2026

## Variable type: String

| Name | Label | Type | Complete obs | Number of levels |
|---|---|---|---|---|
| enum_comments | "(H1) Enumerator comments about the interview" | str1 | 0 | 0 |
| hh_id | "(A1) Household ID" | str7 | 1293 | 1287 |
| key | "Unique submission ID" | str41 | 1293 | 1293 |
| village_id | "(A2) Community/village name" | str4 | 1293 | 12 |

## Variable type: Continuous

| Name | Label | Type | Complete obs | Mean | Std Dev | p0 | p25 | p50 | p75 | p100 |
|---|---|---|---|---|---|---|---|---|---|---|
| duration_min | "Survey duration in minutes" | double | 1293 | 19.94 | 9.989 | .8 | 15.3 | 19.5 | 23.7 | 246 |
| hh_children | "(C6) Number of children under 5 in the household" | byte | 1293 | 1.261 | .9732 | 0 | 0 | 1 | 2 | 3 |
| hh_size | "(C5) Number of people living in the household" | byte | 1291 | 5.572 | 2.321 | 2 | 4 | 6 | 8 | 19 |
| resp_age | "(C1) Respondent's age, in years" | byte | 1285 | 49.97 | 18.58 | 12 | 34 | 50 | 66 | 98 |
| storage_time | "(D5) Hours since the stored water was collected" | int | 908 | 27.12 | 29.25 | 0 | 4 | 18 | 48 | 130 |
| treat_boil | "(E2) Days in past 7 drinking water was boiled" | byte | 1285 | 2.984 | 2.382 | 0 | 1 | 3 | 5 | 7 |
| treat_chlorine | "(E1) Days in past 7 chlorine added to drinking water" | byte | 1284 | 2.818 | 2.508 | 0 | 0 | 2.5 | 5 | 7 |

## Variable type: Date or date-time

| Name | Label | Format | Complete obs | Unique values | Mean | Std Dev | Min | Median | Max |
|---|---|---|---|---|---|---|---|---|---|
| endtime | "Interview end time" | %tc | 1293 | 1240 | 11jul2026 04:00:13 | 4.92e+08 | 01jul2026 07:44:45 | 11jul2026 02:15:20 | 20jul2026 18:19:33 |
| starttime | "Interview start time" | %tc | 1293 | 1225 | 11jul2026 03:40:21 | 4.92e+08 | 01jul2026 07:29:28 | 11jul2026 01:55:40 | 20jul2026 17:57:42 |
| submissiondate | "Date and time of submission" | %tc | 1293 | 1230 | 11jul2026 04:45:52 | 4.92e+08 | 01jul2026 09:09:57 | 11jul2026 03:05:34 | 21jul2026 10:27:18 |

## Variable type: Categorical

| Name | Label | Value label | Complete obs | Number of levels | Number of unlabeled levels | Top count |
|---|---|---|---|---|---|---|
| consent | "(B1) Respondent consents to the interview" | yesno | 1293 | 2 | 0 | Yes:1290 No:3 |
| deviceid | "Data collection device ID" | deviceid | 1293 | 8 | 0 | SCTO-DEV-05:190 SCTO-DEV-08:172 SCTO-DEV-01:162 SCTO-DEV-07:160 SCTO-DEV-03:157 |
| enumerator | "Enumerator ID" | enumerator | 1293 | 8 | 0 | ENUM05:190 ENUM08:172 ENUM01:162 ENUM07:160 ENUM03:157 |
| hh_watersource | "(C7) Primary source of drinking water" | source | 1285 | 5 | 0 | Piped:582 Protected well:335 River or stream:185 Trucked:120 Rainwater:63 |
| resp_educ | "(C4) Respondent's highest level of education" | educ | 1283 | 4 | 0 | Secondary:339 None:328 Tertiary:319 Primary:297 |
| resp_hh_head | "(C3) Respondent is head of household" | yesno | 1285 | 2 | 0 | Yes:651 No:634 |
| resp_sex | "(C2) Respondent's sex" | sex | 1291 | 2 | 0 | Male:652 Female:639 |
| stored_chlorine | "(D6) Chlorine added to water before storing" | yesno | 907 | 2 | 0 | No:634 Yes:273 |
| stored_clean | "(D4) Container washed with soap in past 7 days" | yesno | 907 | 2 | 0 | Yes:520 No:387 |
| stored_container | "(D2) Type of container used to store water" | container | 905 | 4 | 0 | Bucket:299 Clay pot:285 Jerry can:275 Plastic drum:46 |
| stored_covered | "(D3) Storage container was covered" | yesno | 907 | 2 | 0 | Yes:678 No:229 |
| stored_yn | "(D1) Household has drinking water stored now" | yesno | 1291 | 2 | 0 | Yes:908 No:383 |
| treat_notablets | "(E3) Household ran out of chlorine tablets in past 30 days" | yesno | 1285 | 2 | 0 | No:859 Yes:426 |
| water_safety | "(F1) Respondent's rating of drinking water safety" | safe | 1287 | 3 | 0 | Somewhat safe:530 Very safe:490 Not safe:267 |
| water_satisfaction | "(F2) Respondent's satisfaction with water quality" | satisfied | 1286 | 3 | 0 | Somewhat satisfied:508 Very satisfied:488 Not satisfied:290 |

