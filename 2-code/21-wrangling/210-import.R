################################################################################
#  00-import.R  ·  Tidying exercise                         [COMPLETE - read it]
#-------------------------------------------------------------------------------
#  Summary:  From the raw SurveyCTO csv to a typed, documented table.
#            Nothing is fixed here: duplicates, odd ages and odd codes all
#            stay in. We only make the computer read the data correctly.
#
#  Reads:    02_data/01_raw/household_water_questionnaire__v1.csv
#  Writes:   02_data/00_pii/00_imported_with_pii.dta  (still has PII, so it
#            goes to the restricted folder, never to 02_clean)
################################################################################

# 1) Import everything as TEXT. Never let R guess types on a raw export:
#    long numbers lose digits, and a phone number like +25672458591 becomes
#    25672458591. Declare the encoding too, so accents survive.

hh <- read_csv(
  file.path(data_raw, raw_export),
  col_types = cols(.default = col_character()),
  locale    = locale(encoding = "UTF-8"),
  na        = ""
)

dim(hh)
names(hh) <- tolower(names(hh))

# 2) Declare the numeric variables. These are the form's integer and
#    select_one fields: SurveyCTO exports the CODES (1, 0, -666, -888, -999),
#    not the answer text. Labels come in 03.
#    Text fields (key, enumerator, deviceid, devicephonenum, the "other,
#    specify" answers, child names, comments) stay as text.

numeric_vars <- c(
  "duration_min", "hh_id", "village_id", "consent",
  "resp_age", "resp_sex", "resp_hh_head", "resp_educ", "hh_size", "hh_children",
  "hh_watersource", "stored_yn", "stored_container", "stored_covered", "stored_clean",
  "storage_time", "stored_chlorine", "treat_chlorine", "treat_boil", "treat_notablets",
  "water_safety", "water_satisfaction",
  grep("^(child_age|diarrhea_2d|diarrhea_7d)_[0-9]+$", names(hh), value = TRUE)
)

# as.numeric() turns anything it can't read into NA without stopping, so
# check that no value was lost on the way

for (v in numeric_vars) {
  converted <- suppressWarnings(as.numeric(hh[[v]]))
  stopifnot(!any(is.na(converted) & !is.na(hh[[v]])))
  hh[[v]] <- converted
}

# 3) Date-times. SurveyCTO writes them as text: "Jul 12, 2026 4:04:50 AM".
#    The format "%b %d, %Y %I:%M:%S %p" reads them (month name, day, year,
#    12-hour clock, AM/PM).

for (v in c("submissiondate", "starttime", "endtime")) {
  converted <- as.POSIXct(hh[[v]], format = "%b %d, %Y %I:%M:%S %p", tz = "UTC")
  stopifnot(!any(is.na(converted) & !is.na(hh[[v]])))
  hh[[v]] <- converted
}

hh <- hh %>% mutate(survey_date = as.Date(starttime))
attr(hh$survey_date, "label") <- "Date of interview (from starttime)"

# 4) GPS. A geopoint arrives as ONE text column with four numbers:
#    "latitude longitude altitude accuracy". Split it into four numeric
#    columns. (They are identifiers: 01 moves them to the crosswalk.)

hh <- hh %>%
  separate_wider_delim(
    gps, delim = " ",
    names = c("gps_latitude", "gps_longitude", "gps_altitude", "gps_accuracy"),
    too_few = "align_start"
  ) %>%
  mutate(across(starts_with("gps_"), as.numeric))

# 5) The row ID. You might expect hh_id to identify rows -- try it:

if (anyDuplicated(hh$hh_id) > 0) {
  message("hh_id is NOT unique -- look:")
  print(hh %>% count(hh_id, name = "copies") %>% count(copies, name = "households"))
}

#    Some households were submitted twice. That is a CONTENT question, and
#    tomorrow's HFC session will investigate which visit is real.
#    Today we drop nothing. We just need a row ID, and SurveyCTO already
#    gives us one: key, the unique ID of every submission.

stopifnot(!anyDuplicated(hh$key), !any(is.na(hh$key)))
attr(hh$key, "label")            <- "SurveyCTO submission ID (unique row ID)"
attr(hh$submissiondate, "label") <- "Date-time the form reached the server"

# 6) Document what arrived, inside the file itself

hh <- hh %>% relocate(key, hh_id, village_id, survey_date, enumerator)
#    The dataset label travels inside the .dta file. (Stata's notes have no
#    equivalent in R, so the source and date go in the label instead.)

nrow(hh)
write_dta(hh, file.path(data_pii, "00_imported_with_pii.dta"),
          label = paste("Household Water V1 - imported WITH PII -", today))
