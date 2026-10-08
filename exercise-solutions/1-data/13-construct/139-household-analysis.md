This report was created by the Stata command iesave (version 7.5). Read more about this command and the purpose of this report on https://dimewiki.worldbank.org/iesave

- **Number of observations:** 1254
- **Number of variables:** 25
- **ID variable(s):** key
- **.dta version used:** 14
- **Data signature:** 1254:25(28897):3683855458:1772540141
- **Last saved by:** User info withheld, see option userinfo in command iesave.
- **Last saved at:** 04:33:54 8 Oct 2026

## Variable type: String

| Name | Label | Type | Complete obs | Number of levels |
|---|---|---|---|---|
| key | "SurveyCTO submission ID (unique row ID)" | str41 | 1254 | 1254 |

## Variable type: Continuous

| Name | Label | Type | Complete obs | Mean | Std Dev | p0 | p25 | p50 | p75 | p100 |
|---|---|---|---|---|---|---|---|---|---|---|
| diarrhea_2d_share | "Share of children under 5 with diarrhea in the past 2 days" | float | 938 | .1084 | .263 | 0 | 0 | 0 | 0 | 1 |
| diarrhea_2d_total | "Number of children under 5 with diarrhea in the past 2 days" | byte | 938 | .1844 | .4146 | 0 | 0 | 0 | 0 | 2 |
| diarrhea_week_share | "Share of children under 5 with diarrhea in the past 7 days" | float | 938 | .2486 | .3716 | 0 | 0 | 0 | .5 | 1 |
| diarrhea_week_total | "Number of children under 5 with diarrhea in the past 7 days" | byte | 938 | .4179 | .6043 | 0 | 0 | 0 | 1 | 3 |
| hh_children | "C6. Children under 5 in household" | byte | 1254 | 1.274 | .9888 | 0 | 0 | 1 | 2 | 6 |
| hh_size | "C5. People living in household" | byte | 1252 | 5.611 | 2.681 | 2 | 4 | 6 | 8 | 45 |
| resp_age | "C1. Respondent's age (years)" | int | 1246 | 49.93 | 18.67 | 8 | 34 | 50 | 66 | 112 |
| treat_boil | "E2. Days water boiled, past 7 days" | byte | 1246 | 3.003 | 2.395 | 0 | 1 | 3 | 5 | 10 |
| treat_chlorine | "E1. Days chlorine added, past 7 days" | byte | 1245 | 2.824 | 2.529 | 0 | 0 | 3 | 5 | 12 |
| village_id | "A3. Village" | int | 1254 | 1300 | 81.71 | 1201 | 1203 | 1302 | 1401 | 1404 |

## Variable type: Categorical

| Name | Label | Value label | Complete obs | Number of levels | Number of unlabeled levels | Top count |
|---|---|---|---|---|---|---|
| diarrhea_2d_any | "At least one child under 5 with diarrhea in the past 2 days" | yesno | 938 | 2 | 0 | No:775 Yes:163 |
| diarrhea_week_any | "At least one child under 5 with diarrhea in the past 7 days" | yesno | 938 | 2 | 0 | No:602 Yes:336 |
| hh_watersource | "C7. Main drinking water source" | watersource | 1246 | 5 | 0 | Piped:567 Protected well:328 River or stream:174 Trucked:114 Other:63 |
| main_sample | "In main analysis sample: children under 5, no missing outcomes/controls" | yesno | 1254 | 2 | 0 | Yes:930 No:324 |
| resp_sex | "C2. Respondent's sex" | sex | 1252 | 2 | 0 | Male:631 Female:621 |
| storage_time_cat | "Time since water was collected" | storage_cat | 774 | 6 | 0 | 0-12 hours:384 12-24 hours:126 48-72 hours:73 More than 72 hours:72 36-48 hours:63 |
| stored_chlorine | "D7. Chlorine added before storing" | yesno | 772 | 2 | 0 | No:536 Yes:236 |
| stored_clean | "D5. Container washed with soap, past 7 days" | yesno | 772 | 2 | 0 | Yes:435 No:337 |
| stored_container | "D2. Storage container type" | container | 774 | 4 | 0 | Bucket:260 Clay pot:241 Jerry can:232 Other:41 |
| stored_covered | "D4. Storage container covered" | yesno | 772 | 2 | 0 | Yes:576 No:196 |
| treat_chlorine_any | "Treated water with chlorine on at least 1 of the past 7 days" | yesno | 1245 | 2 | 0 | Yes:864 No:381 |
| treatment | "Village assigned to chlorine access" | treatment | 1254 | 2 | 0 | Control:658 Treatment:596 |
| water_safety | "F1. Perceived safety of drinking water" | safety | 1248 | 3 | 0 | Somewhat safe:521 Not safe:473 Very safe:254 |
| water_satisfaction | "F2. Satisfaction with water quality" | satisfaction | 1247 | 3 | 0 | Somewhat satisfied:489 Not satisfied:478 Very satisfied:280 |

