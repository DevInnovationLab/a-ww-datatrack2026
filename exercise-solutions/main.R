################################################################################
#        Data Ingestion, Cleaning & Tidying - DIL Welcome Week India 2026
#                               MASTER.R
################################################################################
#
#  Authors:   DIL Data Team
#             David Torres Leon (dtorresleon@uchicago.edu)
#
#  Updated:   October 2026
#  Version:   R 4.1 or later
#
#  Summary:   R version of MASTER.do. Same exercise, same steps, same output
#             files: pick the language you prefer, you only need ONE of them.
#
#             TEACHING version of an ingestion / tidying / cleaning pipeline.
#             It starts from the raw SurveyCTO export of the Household Water
#             Questionnaire V1 (form household_water_v1, the form from Data
#             Session 1) and ends with tidy, labeled, de-identified tables
#             ready for tomorrow's High-Frequency Checks session (Data Session 3).
#
#             THE ONE RULE: these scripts change the SHAPE and FORMAT of the
#             data, never its CONTENT. You will meet duplicate households,
#             out-of-range ages and an impossible storage time. LEAVE THEM IN.
#             Finding and acting on them is tomorrow's job.
#
#             Files 00 and 04 are COMPLETE, as a model of the style we use.
#             Files 01-03 contain "YOUR TURN" blocks for you to complete during
#             the exercise. Completed versions are in
#             02_code/_answer_key_R.zip (facilitators only).
#
#             The tables are saved as .dta files with the SAME names the Stata
#             do-files use (households.dta, children.dta), so tomorrow's
#             session works the same whichever language you used today.
#
#  Outline:   I.  Initial setup
#             II. Run scripts
#                00. Import the SurveyCTO export        [COMPLETE - read it]
#                01. De-identify                        [YOUR TURN]
#                02. Tidy: the children roster          [YOUR TURN]
#                03. Clean: missing codes and labels    [YOUR TURN]
#                04. Codebook + HFC-readiness check     [COMPLETE - run it]
################################################################################


################################################################################
#  I. Initial setup
################################################################################

# Start clean

rm(list = ls())

# Packages: installs any that are missing, then loads them

packages <- c("readr", "dplyr", "tidyr", "haven", "writexl")
missing_pkgs <- packages[!packages %in% rownames(installed.packages())]
if (length(missing_pkgs) > 0) install.packages(missing_pkgs)
invisible(lapply(packages, library, character.only = TRUE))

# SurveyCTO writes dates in English ("Jul 12, 2026 4:04:50 AM").
# This makes R read month names in English whatever your computer's language.

invisible(Sys.setlocale("LC_TIME", "C"))

# Set the project's main folder (one line per user)

user <- Sys.info()[["user"]]

if (user == "dtorresleon") {
  # David (DIL)
  maindir <- "~/Library/CloudStorage/.../Tidying_exercise"
} else if (user == "") {
  # YOU: run  Sys.info()[["user"]]  in the console, put the result between
  # the quotes above, and write the path to YOUR copy of Tidying_exercise
  maindir <- ""
} else {
  # Fallback: assume R's working directory is already Tidying_exercise
  # (in RStudio: Session > Set Working Directory > Choose Directory...)
  maindir <- getwd()
}

# Subfolders (the same structure as a Box project folder)

doc        <- file.path(maindir, "01_documentation")
code       <- file.path(maindir, "02_code")
data_pii   <- file.path(maindir, "02_data", "00_pii")
data_raw   <- file.path(maindir, "02_data", "01_raw")
data_clean <- file.path(maindir, "02_data", "02_clean")
output     <- file.path(maindir, "03_output")

for (d in c(data_pii, data_clean, output)) dir.create(d, showWarnings = FALSE)

if (!file.exists(file.path(code, "00-import.R"))) {
  stop("Can't find 02_code/00-import.R -- set maindir to your Tidying_exercise folder")
}

# Today's date, for file names

today <- format(Sys.Date(), "%Y-%m-%d")

# File names

raw_export     <- "household_water_questionnaire__v1.csv"
codebook_excel <- file.path(output, paste0(today, "_Codebook_Household_Water.xlsx"))


################################################################################
#  II. Run scripts
################################################################################

# Switch each step on or off with if (TRUE) / if (FALSE)

#-------------------------------------------------------------------------------
#  00-import.R                                           [COMPLETE - read it]
#-------------------------------------------------------------------------------
#  Imports the csv as text, declares the type of every variable, converts the
#  SurveyCTO date-times, splits the GPS column, and shows why hh_id cannot be
#  the row ID (SurveyCTO's key can).
#-------------------------------------------------------------------------------

if (TRUE) source(file.path(code, "00-import.R"), echo = TRUE, max.deparse.length = Inf)

#-------------------------------------------------------------------------------
#  01-deidentify.R                                                 [YOUR TURN]
#-------------------------------------------------------------------------------
#  Saves the crosswalk (key + identifiers) to 00_pii, then drops the
#  identifiers: children's names, the device phone number and the GPS point.
#-------------------------------------------------------------------------------

if (TRUE) source(file.path(code, "01-deidentify.R"), echo = TRUE, max.deparse.length = Inf)

#-------------------------------------------------------------------------------
#  02-tidy-reshape.R                                               [YOUR TURN]
#-------------------------------------------------------------------------------
#  The children roster (Section G) arrived wide: child_age_1..3,
#  diarrhea_2d_1..3, diarrhea_7d_1..3. Reshape it into its own table, one row
#  per child, and check IDs and counts before and after.
#-------------------------------------------------------------------------------

if (TRUE) source(file.path(code, "02-tidy-reshape.R"), echo = TRUE, max.deparse.length = Inf)

#-------------------------------------------------------------------------------
#  03-clean-label.R                                                [YOUR TURN]
#-------------------------------------------------------------------------------
#  Turns the special codes (-999 Don't know, -888 Declined) into labeled
#  missing values, attaches value labels from the form's choices, and adds
#  variable labels from the questionnaire.
#-------------------------------------------------------------------------------

if (TRUE) source(file.path(code, "03-clean-label.R"), echo = TRUE, max.deparse.length = Inf)

#-------------------------------------------------------------------------------
#  04-codebook-verify.R                                  [COMPLETE - run it]
#-------------------------------------------------------------------------------
#  Exports a codebook to excel and runs the HFC-readiness check. If every
#  check passes, it says so: your tables are tomorrow's input.
#-------------------------------------------------------------------------------

if (TRUE) source(file.path(code, "04-codebook-verify.R"), echo = TRUE, max.deparse.length = Inf)
