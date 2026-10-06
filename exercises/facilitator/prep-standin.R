# ==============================================================================
#  prep-standin.R  ·  Build a minimal analysis dataset                 [STAND-IN]
# ------------------------------------------------------------------------------
#  Author(s): DIL Data Team · Nandita Gupta (nanditag@uchicago.edu)
#  Updated:   October 2026
#
#  Input:     raw/household_water_questionnaire__v1.csv
#               (SurveyCTO export of household_water_v1, Session 2 version)
#  Output:    two data frames in memory, used by make_exercise_data.R:
#               hh        one row per submission           (id: key)
#               children  one row per child under 5         (id: key, child_index)
#
#  Summary:   The course has no constructed dataset yet, so this builds just
#             enough of one: import, de-identify, recode missing codes,
#             construct the indicators the exercises use. Observed variables
#             are never overwritten. FACILITATORS ONLY: participants get the
#             clean CSVs that make_exercise_data.R writes, never this script.
#
#  Notes:     Sourced by make_exercise_data.R, which sets raw_csv.
#             TEMPORARY: when the constructed course data exists, build the
#             clean CSVs from it instead.
#             -999 = Don't know and -888 = Declined become NA; -666 = Other
#             is a real answer and stays. Decisions that exclude impossible
#             values are marked STAND-IN DECISION.
# ==============================================================================

library(dplyr)
library(tidyr)

# ---- 1 Import: everything as text first -------------------------------------
raw <- read.csv(raw_csv,
                colClasses = "character", na.strings = "")
names(raw) <- tolower(names(raw))
stopifnot(!anyDuplicated(raw$key))

num_vars <- c(
  "duration_min", "hh_id", "village_id", "consent",
  "resp_age", "resp_sex", "resp_hh_head", "resp_educ", "hh_size", "hh_children",
  "hh_watersource", "stored_yn", "stored_container", "stored_covered",
  "stored_clean", "storage_time", "stored_chlorine", "treat_chlorine",
  "treat_boil", "treat_notablets", "water_safety", "water_satisfaction",
  grep("^(child_age|diarrhea_2d|diarrhea_7d)_[123]$", names(raw), value = TRUE)
)

hh <- mutate(raw, across(all_of(num_vars), as.numeric))

# ---- 2 Interview date (both export formats) ----------------------------------
invisible(Sys.setlocale("LC_TIME", "C"))
start <- as.POSIXct(hh$starttime, format = "%b %d, %Y %I:%M:%S %p", tz = "UTC")
start[is.na(start)] <- as.POSIXct(hh$starttime[is.na(start)],
                                  format = "%m/%d/%y %H:%M", tz = "UTC")
stopifnot(!anyNA(start))
hh$survey_date <- as.Date(start)

# ---- 3 De-identify and recode missing codes ----------------------------------
hh <- hh %>%
  select(-devicephonenum, -gps, -starts_with("child_name_")) %>%
  mutate(across(all_of(num_vars), ~ replace(.x, .x %in% c(-999, -888), NA)))

# ---- 4 Household indicators ---------------------------------------------------
hh <- hh %>%
  mutate(
    consented     = as.numeric(consent == 1),
    last_week     = as.numeric(survey_date > max(survey_date) - 7),
    # STAND-IN DECISION: E1/E2 allow 0-7 days; anything above 7 is impossible
    chlorine_days = if_else(between(treat_chlorine, 0, 7), treat_chlorine, NA_real_),
    chlorine_any  = as.numeric(chlorine_days > 0),
    boil_days     = if_else(between(treat_boil, 0, 7), treat_boil, NA_real_),
    boil_any      = as.numeric(boil_days > 0),
    ran_out       = treat_notablets,
    stored_now    = stored_yn,
    stored_chlor  = if_else(stored_yn == 1, stored_chlorine, NA_real_),  # D7 only if D1 = Yes
    piped         = as.numeric(hh_watersource == 1),                     # -666 Other = not piped
    safe_very     = as.numeric(water_safety == 3)
  )

# ---- 5 Child table: one row per child ----------------------------------------
child_cols <- grep("^(child_age|diarrhea_2d|diarrhea_7d)_[123]$", names(hh), value = TRUE)

n_children <- sum(sapply(1:3, function(i) {
  rowSums(!is.na(hh[, paste0(c("child_age_", "diarrhea_2d_", "diarrhea_7d_"), i)])) > 0
}))

children <- hh %>%
  select(key, all_of(child_cols)) %>%
  pivot_longer(-key, names_to = c(".value", "child_index"),
               names_pattern = "(.*)_([123])$") %>%
  mutate(child_index = as.integer(child_index)) %>%
  filter(!is.na(child_age) | !is.na(diarrhea_2d) | !is.na(diarrhea_7d))

stopifnot(!anyDuplicated(children[c("key", "child_index")]),
          nrow(children) == n_children)

children <- children %>%
  mutate(
    # G4 (past 7 days) is only asked if G3 (past 48 hours) = No
    diarrhea_any7 = case_when(diarrhea_2d == 1 | diarrhea_7d == 1 ~ 1,
                              diarrhea_2d == 0 & diarrhea_7d == 0 ~ 0),
    # STAND-IN DECISION: Section G covers children under 5 (0-60 months)
    diarrhea_any7 = if_else(between(child_age, 0, 60), diarrhea_any7, NA_real_)
  ) %>%
  inner_join(select(hh, key, consented, last_week, chlorine_any),
             by = "key", relationship = "many-to-one")

stopifnot(nrow(children) == n_children)

rm(raw, start, child_cols, n_children)
