################################################################################
#  02-tidy-reshape.R  ·  Tidying exercise                  [ANSWER KEY]
#-------------------------------------------------------------------------------
#  Summary:  Section G (children under 5) is a repeat group. SurveyCTO
#            exported it WIDE, one set of columns per child:
#                child_age_1   diarrhea_2d_1   diarrhea_7d_1
#                child_age_2   diarrhea_2d_2   diarrhea_7d_2
#                child_age_3   diarrhea_2d_3   diarrhea_7d_3
#            Tidy rule: 1 table = 1 unit of observation. Children get their
#            own table, one row per child.
#
#  The three checks that make a reshape safe (from the session):
#    1. unique IDs, before and after
#    2. the number of rows you expect
#    3. a note saying what one row is now
#
#  Reads:    02_data/02_clean/01_deidentified.dta
#  Writes:   02_data/02_clean/children.dta     1 row = 1 child
#            02_data/02_clean/households.dta   1 row = 1 submission
################################################################################

hh <- read_dta(file.path(data_clean, "01_deidentified.dta"))

# Before you reshape: how many child rows do you EXPECT?
# Count the filled roster slots in each submission, then add them up.

hh <- hh %>%
  mutate(n_rostered = rowSums(!is.na(across(starts_with("child_age_")))))
table(hh$n_rostered)
expected <- sum(hh$n_rostered)
cat("Expecting", expected, "child rows after the reshape\n")

#   (Compare n_rostered with hh_children (C6) if you are curious: they do not
#    always match. That is a CONTENT question for the HFCs. Leave it.)

# --- YOUR TURN 1: reshape the roster long ------------------------------------

children <- hh %>%
  select(key, hh_id, village_id, enumerator,
         starts_with("child_age_"), starts_with("diarrhea_2d_"), starts_with("diarrhea_7d_")) %>%
  pivot_longer(
    cols          = c(starts_with("child_age_"), starts_with("diarrhea_2d_"), starts_with("diarrhea_7d_")),
    names_to      = c(".value", "child_no"),
    names_pattern = "(.*)_([0-9]+)$"
  ) %>%
  mutate(child_no = as.integer(child_no))

# --- YOUR TURN 2: drop the empty slots, then run the safety checks -----------

children <- children %>%
  filter(!(is.na(child_age) & is.na(diarrhea_2d) & is.na(diarrhea_7d)))
stopifnot(!anyDuplicated(children[c("key", "child_no")]))
nrow(children)
stopifnot(nrow(children) == expected)

# --- YOUR TURN 3: document and save the children table -----------------------

write_dta(children, file.path(data_clean, "children.dta"),
          label = "Children under 5 (Section G): 1 row = 1 child. ID: key + child_no")

# And rebuild the household table WITHOUT the wide roster columns:

households <- read_dta(file.path(data_clean, "01_deidentified.dta")) %>%
  select(-starts_with("child_age_"), -starts_with("diarrhea_2d_"), -starts_with("diarrhea_7d_"))
stopifnot(!anyDuplicated(households$key))
write_dta(households, file.path(data_clean, "households.dta"),
          label = "Households: 1 row = 1 submission. ID: key")
nrow(households)
