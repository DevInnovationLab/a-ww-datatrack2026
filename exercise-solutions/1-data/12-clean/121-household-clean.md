This report was created by the Stata command iesave (version 7.5). Read more about this command and the purpose of this report on https://dimewiki.worldbank.org/iesave

- **Number of observations:** 1254
- **Number of variables:** 31
- **ID variable(s):** key
- **.dta version used:** 14
- **Data signature:** 1254:31(31497):3653408979:4263358409
- **Last saved by:** User info withheld, see option userinfo in command iesave.
- **Last saved at:** 04:25:41 8 Oct 2026

## Variable type: String

| Name | Label | Type | Complete obs | Number of levels |
|---|---|---|---|---|
| deviceid | "SurveyCTO device ID" | str11 | 1254 | 8 |
| enumerator | "Enumerator ID" | str6 | 1254 | 8 |
| hh_watersource_o | "C8. Other water source (specify)" | str24 | 63 | 9 |
| key | "SurveyCTO submission ID (unique row ID)" | str41 | 1254 | 1254 |
| stored_container_o | "D3. Other container type (specify)" | str12 | 41 | 1 |

## Variable type: Continuous

| Name | Label | Type | Complete obs | Mean | Std Dev | p0 | p25 | p50 | p75 | p100 |
|---|---|---|---|---|---|---|---|---|---|---|
| duration_min | "Interview duration (minutes)" | double | 1254 | 18.13 | 11.24 | .8 | 13.7 | 18.6 | 23.2 | 246 |
| hh_children | "C6. Children under 5 in household" | byte | 1254 | 1.274 | .9888 | 0 | 0 | 1 | 2 | 6 |
| hh_id | "A2. Household ID" | long | 1254 | 1300146 | 81705 | 1201001 | 1203116 | 1302103 | 1401093 | 1404105 |
| hh_size | "C5. People living in household" | byte | 1252 | 5.611 | 2.681 | 2 | 4 | 6 | 8 | 45 |
| resp_age | "C1. Respondent's age (years)" | int | 1246 | 49.93 | 18.67 | 8 | 34 | 50 | 66 | 112 |
| treat_boil | "E2. Days water boiled, past 7 days" | byte | 1246 | 3.003 | 2.395 | 0 | 1 | 3 | 5 | 10 |
| treat_chlorine | "E1. Days chlorine added, past 7 days" | byte | 1245 | 2.824 | 2.529 | 0 | 0 | 3 | 5 | 12 |
| village_id | "A3. Village" | int | 1254 | 1300 | 81.71 | 1201 | 1203 | 1302 | 1401 | 1404 |

## Variable type: Date or date-time

| Name | Label | Format | Complete obs | Unique values | Mean | Std Dev | Min | Median | Max |
|---|---|---|---|---|---|---|---|---|---|
| endtime | "Interview end date-time" | %tcCCYY-NN-DD_HH:MM:SS | 1254 | 1193 | 2026-07-11 05:40:17 | 4.92e+08 | 2026-07-01 07:44:45 | 2026-07-11 06:17:49 | 2026-07-20 18:02:04 |
| starttime | "Interview start date-time" | %tcCCYY-NN-DD_HH:MM:SS | 1254 | 1189 | 2026-07-11 05:22:08 | 4.92e+08 | 2026-07-01 07:29:28 | 2026-07-11 06:00:20 | 2026-07-20 17:57:42 |
| submissiondate | "Date-time the form reached the server" | %tcCCYY-NN-DD_HH:MM:SS | 1254 | 1199 | 2026-07-11 06:27:39 | 4.92e+08 | 2026-07-01 09:09:57 | 2026-07-11 06:40:45 | 2026-07-21 10:29:29 |
| survey_date | "Date of interview (from starttime)" | %tdCCYY-NN-DD | 1254 | 20 | 2026-07-10 | 5.703 | 2026-07-01 | 2026-07-11 | 2026-07-20 |

## Variable type: Categorical

| Name | Label | Value label | Complete obs | Number of levels | Number of unlabeled levels | Top count |
|---|---|---|---|---|---|---|
| consent | "B1. Consent to interview" | yesno | 1254 | 1 | 0 | Yes:1254 |
| hh_watersource | "C7. Main drinking water source" | watersource | 1246 | 5 | 0 | Piped:567 Protected well:328 River or stream:174 Trucked:114 Other:63 |
| resp_educ | "C4. Respondent's education" | educ | 1244 | 4 | 0 | Secondary:331 None:313 Tertiary:310 Primary:290 |
| resp_hh_head | "C3. Respondent is household head" | yesno | 1246 | 2 | 0 | Yes:629 No:617 |
| resp_sex | "C2. Respondent's sex" | sex | 1252 | 2 | 0 | Male:631 Female:621 |
| storage_time | "D6. Hours since water was collected" | storage | 774 | 15 | 1 | :78 :74 :73 More than 72 hours:70 :67 |
| stored_chlorine | "D7. Chlorine added before storing" | yesno | 772 | 2 | 0 | No:536 Yes:236 |
| stored_clean | "D5. Container washed with soap, past 7 days" | yesno | 772 | 2 | 0 | Yes:435 No:337 |
| stored_container | "D2. Storage container type" | container | 774 | 4 | 0 | Bucket:260 Clay pot:241 Jerry can:232 Other:41 |
| stored_covered | "D4. Storage container covered" | yesno | 772 | 2 | 0 | Yes:576 No:196 |
| stored_yn | "D1. Drinking water stored now" | yesno | 1097 | 2 | 0 | Yes:767 No:330 |
| treat_notablets | "E3. Ran out of chlorine tablets, past 30 days" | yesno | 1246 | 2 | 0 | No:833 Yes:413 |
| water_safety | "F1. Perceived safety of drinking water" | safety | 1248 | 3 | 0 | Somewhat safe:521 Not safe:473 Very safe:254 |
| water_satisfaction | "F2. Satisfaction with water quality" | satisfaction | 1247 | 3 | 0 | Somewhat satisfied:489 Not satisfied:478 Very satisfied:280 |

