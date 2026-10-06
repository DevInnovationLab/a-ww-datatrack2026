################################################################################
#  01-deidentify.R  ·  Tidying exercise                    [ANSWER KEY]
#-------------------------------------------------------------------------------
#  Summary:  Three kinds of direct identifier came with the export:
#              - the children's names        child_name_1, _2, _3   (G1)
#              - the device's phone number    devicephonenum
#              - the GPS point                gps_latitude ... gps_accuracy
#            They must not travel with the data you clean and share.
#
#  The rule: CROSSWALK FIRST, THEN DROP. If you drop first, the link between
#  a household and its identifiers is gone for good.
#
#  Reads:    02_data/00_pii/00_imported_with_pii.dta
#  Writes:   02_data/00_pii/crosswalk_pii.dta        (restricted folder)
#            02_data/02_clean/01_deidentified.dta    (no PII)
################################################################################

hh <- read_dta(file.path(data_pii, "00_imported_with_pii.dta"))

# --- YOUR TURN 1: save the crosswalk -----------------------------------------

crosswalk <- hh %>%
  select(key, hh_id, starts_with("child_name_"), devicephonenum, starts_with("gps_"))
write_dta(crosswalk, file.path(data_pii, "crosswalk_pii.dta"))

# --- YOUR TURN 2: drop the identifiers from the working data -----------------

hh <- hh %>%
  select(-starts_with("child_name_"), -devicephonenum, -starts_with("gps_"))

# Save the de-identified working file. From here on, nothing has PII.

write_dta(hh, file.path(data_clean, "01_deidentified.dta"),
          label = "Household Water Questionnaire V1 - de-identified")
