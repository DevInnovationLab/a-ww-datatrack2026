# ==============================================================================
#  01_construct.R  ·  Village-level indicators for the PI's fieldwork update
# ------------------------------------------------------------------------------
#  Written by:  an AI assistant, from this prompt:
#               "Using households.csv and children.csv, construct three
#                village-level indicators for the PI: the share of households
#                with a child who had diarrhoea in the past 7 days, the
#                average number of days households treated their drinking
#                water in the past 7 days, and the average number of hours
#                stored water had been kept. Save one row per village."
#
#  Input:       data/households.csv  one row per submission
#               data/children.csv    one row per child under 5
#  Output:      output/village_indicators.csv  one row per village
#
#  How to run:  open exercise1.Rproj (so R starts in this folder), open this
#               file and click Source.
# ==============================================================================

library(dplyr)

# ---- 1 Load the data -----------------------------------------------------------
households <- read.csv("data/households.csv")
children   <- read.csv("data/children.csv")

# ---- 2 Attach each household's children ----------------------------------------
# Every household is kept; households without children get one row with
# missing child variables.
hh_children <- households %>%
  left_join(children %>% select(hh_id, child_no, child_age, diarrhea_2d, diarrhea_7d),
            by = "hh_id", relationship = "many-to-many")

# ---- 3 Household-level indicators -----------------------------------------------
household_level <- hh_children %>%
  group_by(key) %>%
  summarise(
    village_id   = first(village_id),
    # Children with diarrhoea in the past 7 days (G4)
    n_diarrhea   = sum(diarrhea_7d, na.rm = TRUE),
    # Days the household treated its water in the past 7 days (E1 + E2)
    treat_days   = first(rowSums(cbind(treat_chlorine, treat_boil), na.rm = TRUE)),
    # Hours since the stored water was collected (D6)
    storage_time = first(storage_time),
    .groups = "drop"
  ) %>%
  mutate(hh_diarrhea = as.numeric(n_diarrhea > 0))

# ---- 4 Village-level indicators ---------------------------------------------------
village_indicators <- household_level %>%
  group_by(village_id) %>%
  summarise(
    n_households    = n(),
    pct_hh_diarrhea = round(100 * mean(hh_diarrhea), 1),
    mean_treat_days = round(mean(treat_days), 1),
    mean_storage_hr = round(mean(storage_time, na.rm = TRUE), 1),
    .groups = "drop"
  )

print(village_indicators)

cat("\nAll villages: ", round(100 * mean(household_level$hh_diarrhea), 1),
    "% of households had a child with diarrhoea in the past 7 days\n", sep = "")

dir.create("output", showWarnings = FALSE)
write.csv(village_indicators, "output/village_indicators.csv", row.names = FALSE)
