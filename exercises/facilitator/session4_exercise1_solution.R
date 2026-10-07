# ==============================================================================
#  session4_exercise1_solution.R  ·  Construction bug hunt: SOLUTION
# ------------------------------------------------------------------------------
#  FACILITATORS ONLY. Not part of the participant folder.
#  Run from exercises/session4/exercise1/ (open exercise1.Rproj), e.g.
#    source("../../facilitator/session4_exercise1_solution.R")
#
#  The five bugs in 01_construct.R / 01_construct.do (slide 13), each with
#  the assertion that stops the original script and the fix:
#   1. Joined on hh_id, which isn't unique (6 hh_ids have two submissions)
#   2. Skipped question read as missing: G4 is only asked if G3 = No
#   3. Households without children become 0 instead of missing
#   4. Chlorine + boiling days added up: can exceed 7 (and non-consenting
#      households become 0 days)
#   5. "More than 72 hours" (code 99) averaged as 99 hours
#
#  Expected: households with a child with diarrhoea, past 7 days
#            original script 15.9% (all 1,293 submissions in the denominator)
#            corrected      35.8% of the 938 consenting households with children
# ==============================================================================

library(dplyr)

households <- read.csv("data/households.csv")
children   <- read.csv("data/children.csv")

# ---- Bug 1: join on key, the unique submission ID, not hh_id ---------------------
# The check that stops the original script:
stopifnot(!anyDuplicated(households$key))
# anyDuplicated(households$hh_id) > 0: 6 hh_ids have two submissions, so a
# join on hh_id gives each pair's children to both submissions.
n_children <- nrow(children)

stopifnot(all(children$key %in% households$key))      # every child's household exists

# The analysis sample. Note: 2 children belong to households coded as not
# consenting (a data question for the HFC session); they drop out here.
households <- households %>% filter(consent == 1)

# ---- Bug 2: construct the skipped question ------------------------------------------
children <- children %>%
  mutate(diarrhea_7d_all = if_else(diarrhea_2d == 1, 1L, diarrhea_7d))
stopifnot(!anyNA(children$diarrhea_7d_all))            # 165 children were NA before

# ---- Bug 3: households without children stay missing ---------------------------------
child_hh <- children %>%
  group_by(key) %>%
  summarise(n_children = n(), n_diarrhea = sum(diarrhea_7d_all), .groups = "drop")
stopifnot(sum(child_hh$n_children) == n_children)

household_level <- households %>%
  left_join(child_hh, by = "key", relationship = "one-to-one") %>%
  mutate(hh_diarrhea = if_else(n_children > 0, as.numeric(n_diarrhea > 0), NA_real_))
stopifnot(nrow(household_level) == nrow(households),
          all(is.na(household_level$hh_diarrhea) == is.na(household_level$n_children)))

# ---- Bug 4: E1 + E2 can't be added -------------------------------------------------------
# The check that stops the original script:
#   stopifnot(all(with(households, treat_chlorine + treat_boil <= 7), na.rm = TRUE))
# 383 households add up to more than 7 days. The overlap can't be recovered,
# so the fix is a different indicator (a research decision):
household_level <- household_level %>%
  mutate(treated_any = as.numeric(treat_chlorine > 0 | treat_boil > 0))

# ---- Bug 5: 99 is a code, not 99 hours ----------------------------------------------------
# The check that stops the original script:
#   stopifnot(all(households$storage_time <= 72, na.rm = TRUE))
# 70 households answered 99 = "more than 72 hours" (and two have 250 and 400,
# outside the questionnaire's range: for the HFC session). A mean can't use a
# "more than" answer, so the fix is again a new indicator:
household_level <- household_level %>%
  mutate(stored_over_24h = as.numeric(storage_time > 24))

# ---- Village-level indicators ----------------------------------------------------------------
village_indicators <- household_level %>%
  group_by(village_id) %>%
  summarise(n_households        = n(),
            n_hh_with_children  = sum(!is.na(hh_diarrhea)),
            pct_hh_diarrhea     = round(100 * mean(hh_diarrhea, na.rm = TRUE), 1),
            pct_treated_any     = round(100 * mean(treated_any, na.rm = TRUE), 1),
            pct_stored_over_24h = round(100 * mean(stored_over_24h, na.rm = TRUE), 1),
            .groups = "drop")
print(village_indicators)

cat("\nAll villages: ", round(100 * mean(household_level$hh_diarrhea, na.rm = TRUE), 1),
    "% of the ", sum(!is.na(household_level$hh_diarrhea)),
    " households with children had a child with diarrhoea in the past 7 days\n", sep = "")
