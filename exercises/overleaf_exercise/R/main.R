# ==============================================================================
#         Publication: Reports & Replicability - DIL Welcome Week Session 5
#             EXERCISE · Results that update themselves in Overleaf
#                                   main.R
# ------------------------------------------------------------------------------
#  Author(s): DIL Data Team · Nandita Gupta (nanditag@uchicago.edu)
#  Updated:   October 2026
#
#  Summary:   R version of the Session 5 Overleaf exercise (the Stata version
#             is stata/main.do; both write the same files). Reads the clean
#             data in data/ and writes every result the PI update quotes -- a table (.tex), a figure (.png)
#             and the numbers in the text (numbers.tex) -- into your Overleaf
#             project's local GitHub clone. Instructions: README.txt in the
#             exercise folder.
#
#  You need:  install.packages(c("dplyr", "tidyr", "ggplot2"))
#
#  Outline:   1. Settings: the switch
#             2. Your two paths
#             3. Run: 2-export-outputs.R
# ==============================================================================

# ---- 1 Settings ---------------------------------------------------------------

# THE SWITCH. FALSE = all fieldwork days; TRUE = the last 7 days of fieldwork.
# Run once with FALSE, then change it to TRUE (step 5 of README.txt).
last_week_only <- FALSE

# Optional: TRUE commits and pushes the three output files to GitHub from R.
# Leave FALSE to push with GitHub Desktop.
push_to_github <- FALSE

# ---- 2 Your two paths -----------------------------------------------------------
#   exercise_dir : this exercise folder (overleaf_exercise/), wherever you saved it
#   overleaf_dir : your local clone of the GitHub repository synced with your
#                  Overleaf project
# Sys.info()[["user"]] shows your username. Copy Nandita's block for yourself.

user <- Sys.info()[["user"]]

if (user == "admin") {                                   # Nandita
  exercise_dir <- "/Users/admin/Desktop/DIL/a-ww-datatrack2026/exercises/overleaf_exercise"
  overleaf_dir <- "/Users/admin/Desktop/DIL/ww-datatrack-gitoverleaf"
} else if (user == "") {                                 # YOU
  exercise_dir <- ""
  overleaf_dir <- ""
} else {
  stop("Add a block for your username (", user, ") in section 2 of main.R")
}

stopifnot(
  "exercise_dir is wrong: it must be the folder that contains R/, stata/ and data/" =
    file.exists(file.path(exercise_dir, "data", "households_clean.csv")),
  "overleaf_dir is wrong: it must be your Overleaf clone (the folder with main.tex)" =
    file.exists(file.path(overleaf_dir, "main.tex"))
)

# ---- 3 Run ----------------------------------------------------------------------
source(file.path(exercise_dir, "R", "2-export-outputs.R")) # writes the 3 files
