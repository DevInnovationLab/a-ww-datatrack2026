# Household Water Questionnaire - V1

*Clean Fielding Version · Development Innovation Lab, University of Chicago · Data Quality Session*

This is the deployment-ready instrument for the Data Quality session exercises. It is the paper rendering of the SurveyCTO form "Household Water Questionnaire - V1" built in the Data Ingestion, Cleaning & Tidying session, the same case study runs through all the data sessions. Variable names in brackets are shown for training purposes so participants can map questions to the fake dataset and HFC code; answers are numeric-coded in the data (Yes = 1, No = 0; Other = -666, Declined = -888, Don't know = -999).

## SECTION A · IDENTIFICATION

**A1** Enumerator ID *[enumerator]*

> *(numeric, auto-filled from device login)*

**A2** Household ID *[hh_id]*

> *(numeric, unique per household, greater than 0)*

**A3** Community / village name *[village_id]*

> *(select from list: 1201–1204, 1301–1304, 1401–1404)*

**A4** GPS coordinates *[gps]*

> *(auto-captured by device)*

**A5** Start time / End time *[starttime / endtime]*

> *(auto-captured by device; survey duration is calculated from these)*

## SECTION B · CONSENT

**B1** Do you consent to volunteer about 15 minutes of your time to talk with me about your household's drinking water? *[consent]*

> *( Yes / No )*
>
> **If No → thank respondent and END the interview. Everything after this point must remain blank.**

## SECTION C · RESPONDENT & HOUSEHOLD ROSTER

**C1** Record respondent's age in completed years. *[resp_age]*

> *(numeric, 18–100 · printed form note reads: "Accepts ages \> 3 and \< 130 only.")*

**C2** Record respondent's sex. *[resp_sex]*

> *( Male / Female )*

**C3** Is the respondent the head of this household? *[resp_hh_head]*

> *( Yes / No )*

**C4** What is the highest level of education the respondent completed? *[resp_educ]*

> *( None / Primary / Secondary / Tertiary / Declined to answer )*

**C5** Including children, how many people currently live in this household? *[hh_size]*

> *(numeric, 1–20)*

**C6** How many children under 5 years of age live in this household? *[hh_children]*

> *(numeric, 0 up to C5, cannot exceed total household size)*

**C7** What is the primary source of drinking water for this household? *[hh_watersource]*

> *( Piped / Protected well / River or stream / Trucked / Other / Don't know )*

**C8** [If C7 = Other] What is the other water source? *[hh_watersource_o]*

> *(open text; only asked when C7 = Other)*

## SECTION D · HOUSEHOLD WATER STORAGE

**D1** Do you have drinking water stored in your household now? *[stored_yn]*

> *( Yes / No )*
>
> **If No → skip to Section E. D2–D7 must remain blank.**

**D2** [ENUMERATOR: observe. If not possible to observe, ask] What type of container do you use to store that water? *[stored_container]*

> *( Bucket / Clay pot / Jerry can / Other )*

**D3** [If D2 = Other] What is the other type of container? *[stored_container_o]*

> *(open text)*

**D4** [ENUMERATOR: observe. If not possible to observe, ask] Was the water storage container covered (e.g., with a lid or a plate)? *[stored_covered]*

> *( Yes / No )*

**D5** Did you or someone else wash this water storage container with soap and water in the past 7 days? *[stored_clean]*

> *( Yes / No )*

**D6** About how many hours have passed since this water was collected? *[storage_time]*

> *(numeric, 0–72 · if more than 72 hours, enter 99)*

**D7** Did you or someone else add chlorine to this water before storing it? *[stored_chlorine]*

> *( Yes / No )*

## SECTION E · WATER TREATMENT PRACTICES

**E1** In the past 7 days, on how many days did you or someone else add chlorine to your household's drinking water? *[treat_chlorine]*

> *(numeric, 0–7)*

**E2** In the past 7 days, on how many days did you or someone else boil your household's drinking water? *[treat_boil]*

> *(numeric, 0–7)*

**E3** In the past 30 days, has your household run out of chlorine tablets? *[treat_notablets]*

> *( Yes / No )*

## SECTION F · PERCEPTIONS & SATISFACTION

**F1** Overall, how would you rate the safety of your drinking water? *[water_safety]*

> *( Very safe / Somewhat safe / Not safe / Declined to answer )*

**F2** How satisfied are you with your household's drinking water quality? *[water_satisfaction]*

> *( Very satisfied / Somewhat satisfied / Not satisfied / Declined to answer )*

## SECTION G · CHILDREN ROSTER

*Repeat once for each child under 5 living in the household (C6 sets the number of repeats; skip the section entirely if C6 = 0). In the dataset the roster arrives WIDE: child_name_1, child_age_1, diarrhea_2d_1, diarrhea_7d_1, then \_2, \_3, …*

**G1** What is the child's name? *[child_name]*

> *(open text)*

**G2** What is the child's age (in months)? *[child_age]*

> *(numeric, 0–60 months)*
>
> *READ: Diarrhoea is defined as the passage of three or more loose or liquid stools within a 24 hour period. Frequent passing of formed stools is not diarrhoea, nor is the passing of loose, "pasty" stools by breastfed babies.*

**G3** Has the child presented with diarrhea in the past 48 hours? *[diarrhea_2d]*

> *( Yes / No )*

**G4** [Only if G3 = No] Has the child presented with diarrhea in the past 7 days? *[diarrhea_7d]*

> *( Yes / No )*
>
> **Note the direction of this skip: G4 is asked only when G3 = No.**

## SECTION H · ENUMERATOR OBSERVATIONS (not read to respondent)

**H1** Enumerator: any comments about this interview? *[enum_comments]*

> *(open text)*

**H2** Survey duration in minutes *[duration_min]*

> *(auto-calculated from start and end time)*

*Development Innovation Lab / University of Chicago · Data Quality Session · Clean fielding version*
