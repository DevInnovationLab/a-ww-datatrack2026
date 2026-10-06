This report was created by the Stata command iesave (version 7.5). Read more about this command and the purpose of this report on https://dimewiki.worldbank.org/iesave

- **Number of observations:** 1293
- **Number of variables:** 40
- **ID variable(s):** key
- **.dta version used:** 14
- **Data signature:** 1293:40(53171):336084260:4117318707
- **Last saved by:** User info withheld, see option userinfo in command iesave.
- **Last saved at:** 21:04:24 6 Oct 2026

## Variable type: String

| Name | Label | Type | Complete obs | Number of levels |
|---|---|---|---|---|
| deviceid | "" | str11 | 1293 | 8 |
| enumerator | "" | str6 | 1293 | 8 |
| hh_watersource_o | "" | str24 | 63 | 9 |
| key | "SurveyCTO submission ID (unique row ID)" | str41 | 1293 | 1293 |
| stored_container_o | "" | str12 | 41 | 1 |

## Variable type: Continuous

| Name | Label | Type | Complete obs | Mean | Std Dev | p0 | p25 | p50 | p75 | p100 |
|---|---|---|---|---|---|---|---|---|---|---|
| child_age_1 | "" | int | 940 | 31.09 | 22.88 | 0 | 16 | 31 | 46 | 480 |
| child_age_2 | "" | byte | 489 | 29.55 | 17.76 | 0 | 14 | 30 | 46 | 60 |
| child_age_3 | "" | byte | 158 | 26.3 | 18.72 | 0 | 8 | 23 | 44 | 60 |
| consent | "" | byte | 1293 | .9698 | .1711 | 0 | 1 | 1 | 1 | 1 |
| diarrhea_2d_1 | "" | byte | 940 | .1181 | .3229 | 0 | 0 | 0 | 0 | 1 |
| diarrhea_2d_2 | "" | byte | 489 | .09202 | .2894 | 0 | 0 | 0 | 0 | 1 |
| diarrhea_2d_3 | "" | byte | 158 | .1076 | .3109 | 0 | 0 | 0 | 0 | 1 |
| diarrhea_7d_1 | "" | byte | 837 | .1553 | .3624 | 0 | 0 | 0 | 0 | 1 |
| diarrhea_7d_2 | "" | byte | 444 | .1757 | .381 | 0 | 0 | 0 | 0 | 1 |
| diarrhea_7d_3 | "" | byte | 141 | .1348 | .3427 | 0 | 0 | 0 | 0 | 1 |
| duration_min | "" | double | 1293 | 18.14 | 11.13 | .8 | 13.7 | 18.6 | 23.2 | 246 |
| hh_children | "" | byte | 1257 | 1.272 | .9884 | 0 | 0 | 1 | 2 | 6 |
| hh_id | "" | long | 1293 | 1299837 | 81737 | 1201001 | 1203116 | 1302101 | 1401091 | 1404106 |
| hh_size | "" | byte | 1255 | 5.613 | 2.679 | 2 | 4 | 6 | 8 | 45 |
| hh_watersource | "" | int | 1255 | -36.45 | 160.4 | -999 | 1 | 1 | 2 | 4 |
| resp_age | "" | int | 1249 | 49.97 | 18.67 | 8 | 34 | 50 | 66 | 112 |
| resp_educ | "" | int | 1255 | -4.866 | 79.67 | -999 | 0 | 2 | 2 | 3 |
| resp_hh_head | "" | byte | 1249 | .5052 | .5002 | 0 | 0 | 1 | 1 | 1 |
| resp_sex | "" | byte | 1255 | 1.496 | .5002 | 1 | 1 | 1 | 2 | 2 |
| storage_time | "" | int | 777 | 28.04 | 33.18 | 1 | 6 | 18 | 48 | 400 |
| stored_chlorine | "" | byte | 775 | .3058 | .461 | 0 | 0 | 0 | 1 | 1 |
| stored_clean | "" | byte | 775 | .5626 | .4964 | 0 | 0 | 1 | 1 | 1 |
| stored_container | "" | int | 777 | -33.29 | 149.4 | -666 | 1 | 2 | 3 | 3 |
| stored_covered | "" | byte | 775 | .7458 | .4357 | 0 | 0 | 1 | 1 | 1 |
| stored_yn | "" | byte | 1100 | .7 | .4585 | 0 | 0 | 1 | 1 | 1 |
| treat_boil | "" | byte | 1249 | 3.001 | 2.394 | 0 | 1 | 3 | 5 | 10 |
| treat_chlorine | "" | byte | 1248 | 2.819 | 2.528 | 0 | 0 | 2 | 5 | 12 |
| treat_notablets | "" | byte | 1249 | .3315 | .4709 | 0 | 0 | 0 | 1 | 1 |
| village_id | "" | int | 1293 | 1300 | 81.74 | 1201 | 1203 | 1302 | 1401 | 1404 |
| water_safety | "" | int | 1255 | -1.016 | 56.46 | -999 | 2 | 2 | 3 | 3 |
| water_satisfaction | "" | int | 1255 | -1.387 | 56.1 | -888 | 2 | 2 | 3 | 3 |

## Variable type: Date or date-time

| Name | Label | Format | Complete obs | Unique values | Mean | Std Dev | Min | Median | Max |
|---|---|---|---|---|---|---|---|---|---|
| endtime | "" | %tcCCYY-NN-DD_HH:MM:SS | 1293 | 1228 | 2026-07-11 03:58:58 | 4.92e+08 | 2026-07-01 07:44:45 | 2026-07-11 02:17:31 | 2026-07-20 18:02:04 |
| starttime | "" | %tcCCYY-NN-DD_HH:MM:SS | 1293 | 1223 | 2026-07-11 03:40:49 | 4.92e+08 | 2026-07-01 07:29:28 | 2026-07-11 01:57:51 | 2026-07-20 17:57:42 |
| submissiondate | "" | %tcCCYY-NN-DD_HH:MM:SS | 1293 | 1236 | 2026-07-11 04:46:22 | 4.92e+08 | 2026-07-01 09:09:57 | 2026-07-11 03:05:34 | 2026-07-21 10:29:29 |
| survey_date | "Date of interview (from starttime)" | %tdCCYY-NN-DD | 1293 | 20 | 2026-07-10 | 5.71 | 2026-07-01 | 2026-07-11 | 2026-07-20 |

