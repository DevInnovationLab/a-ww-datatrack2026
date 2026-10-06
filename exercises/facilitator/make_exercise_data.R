# ==============================================================================
#  make_exercise_data.R  ·  Build the clean data shipped with the exercises
# ------------------------------------------------------------------------------
#  Author(s): DIL Data Team · Nandita Gupta (nanditag@uchicago.edu)
#  Updated:   October 2026
#
#  Input:     raw/household_water_questionnaire__v1.csv
#             prep-standin.R  (the construction, run here only)
#  Output:    ../explore_exercise/household_water_clean.csv      (Session 4, Ex 2)
#               one row per consenting household (id: key)
#             ../overleaf_exercise/data/households_clean.csv      (Session 5)
#               one row per household visited, incl. non-consenting (id: key)
#             ../overleaf_exercise/data/children_clean.csv        (Session 5)
#               one row per child under 5 (id: key, child_index)
#
#  Summary:   Participants get clean CSVs only, so they have no prep code and
#             no raw data to deal with. Both exercises use the same
#             construction, so their numbers match. Run this from
#             exercises/facilitator/ whenever the construction changes, then
#             re-zip both exercise folders.
#
#  Notes:     The Session 5 household file keeps non-consenting submissions
#             (consented = 0, indicators empty) because the report quotes how
#             many households were visited and the consent rate.
#             Dates are written as YYYY-MM-DD; empty cells are missing.
# ==============================================================================

library(dplyr)

raw_csv <- file.path("raw", "household_water_questionnaire__v1.csv")
source("prep-standin.R")                                  # builds hh, children

write_clean <- function(df, path) write.csv(df, path, row.names = FALSE, na = "")

# ---- 1 Session 4, Exercise 2: consenting households ------------------------
explore <- hh %>%
  filter(consented == 1) %>%
  transmute(key, hh_id, village_id,
            survey_date = format(survey_date, "%Y-%m-%d"), last_week,
            piped, chlorine_any, chlorine_days, boil_any, stored_now,
            stored_chlor, ran_out, safe_very)

stopifnot(!anyDuplicated(explore$key), nrow(explore) == 1254)
write_clean(explore, file.path("..", "explore_exercise", "household_water_clean.csv"))

# ---- 2 Session 5, Overleaf exercise: households and children ---------------
households <- hh %>%
  transmute(key, village_id,
            survey_date = format(survey_date, "%Y-%m-%d"), last_week, consented,
            piped, chlorine_any, chlorine_days, boil_any, stored_now,
            stored_chlor, ran_out, safe_very)

kids <- children %>%
  select(key, child_index, last_week, consented, chlorine_any, diarrhea_any7)

stopifnot(!anyDuplicated(households$key), nrow(households) == 1293,
          sum(households$consented) == 1254,
          !anyDuplicated(kids[c("key", "child_index")]),
          all(kids$key %in% households$key))

dir.create(file.path("..", "overleaf_exercise", "data"), showWarnings = FALSE)
write_clean(households, file.path("..", "overleaf_exercise", "data", "households_clean.csv"))
write_clean(kids,       file.path("..", "overleaf_exercise", "data", "children_clean.csv"))
