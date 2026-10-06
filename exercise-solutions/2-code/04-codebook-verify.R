################################################################################
#  04-codebook-verify.R  ·  Tidying exercise               [COMPLETE - run it]
#-------------------------------------------------------------------------------
#  Summary:  The archivist's job, automated: a codebook in excel, one sheet
#            per table, one row per variable. Then the HFC-READINESS CHECK.
#            If every check passes, your tables are the input for
#            tomorrow's High-Frequency Checks (Data Session 3).
################################################################################

# --- Codebook: name, type, labels and share missing, one row per variable ---

codebook_sheet <- function(data) {
  data.frame(
    variable       = names(data),
    storage_type   = sapply(data, function(x) class(zap_labels(x))[1]),
    value_label    = sapply(data, function(x) {
      labs <- attr(x, "labels")
      if (is.null(labs)) return("")
      shown <- ifelse(is_tagged_na(labs), paste0(".", na_tag(labs)), as.character(labs))
      paste(paste0(shown, " ", names(labs)), collapse = "; ")
    }),
    variable_label = sapply(data, function(x) {
      lab <- attr(x, "label")
      if (is.null(lab)) "" else lab
    }),
    pct_missing    = sapply(data, function(x) round(100 * mean(is.na(x)), 1)),
    row.names = NULL
  )
}

households <- read_dta(file.path(data_clean, "households.dta"))
children   <- if (file.exists(file.path(data_clean, "children.dta"))) {
  read_dta(file.path(data_clean, "children.dta"))
} else NULL

sheets <- list(households = codebook_sheet(households))
if (!is.null(children)) sheets$children <- codebook_sheet(children)
write_xlsx(sheets, codebook_excel)

# --- HFC-READINESS CHECK ---

pass <- TRUE
fail <- function(msg) {
  message("FAIL: ", msg)
  pass <<- FALSE
}

# 1) Every submission is still there (yes, the duplicates too)
if (nrow(households) != 1293) {
  fail(paste0("expected 1,293 household rows, found ", nrow(households)))
}

# 2) One row per submission
if (anyDuplicated(households$key) > 0) fail("key no longer identifies rows")

# 3) No PII left behind
for (v in c("child_name_1", "child_name_2", "child_name_3", "devicephonenum",
            "gps", "gps_latitude", "gps_longitude")) {
  if (v %in% names(households)) fail(paste(v, "is still in the household file"))
}

# 4) Dates are dates
if (!inherits(households$starttime, "POSIXct")) fail("starttime is not a date-time")

# 5) No -999 / -888 codes left in numeric variables
for (v in names(households)[sapply(households, is.numeric)]) {
  if (any(households[[v]] %in% c(-999, -888))) {
    fail(paste(v, "still has -999 or -888 codes"))
  }
}

# 6) Value labels attached
for (v in c("consent", "resp_sex", "resp_hh_head", "resp_educ", "hh_watersource",
            "stored_yn", "stored_container", "storage_time", "water_safety",
            "water_satisfaction")) {
  if (is.null(attr(households[[v]], "labels"))) fail(paste(v, "has no value label"))
}

# 7) Variable labels for Sections D, E and F
for (v in c("stored_yn", "stored_container", "stored_covered", "stored_clean",
            "storage_time", "stored_chlorine", "treat_chlorine", "treat_boil",
            "treat_notablets", "water_safety", "water_satisfaction")) {
  lab <- attr(households[[v]], "label")
  if (is.null(lab) || lab == "" || grepl("___", lab, fixed = TRUE)) {
    fail(paste(v, "has no variable label"))
  }
}

# 8) The children table exists, has one row per child, and is labeled
if (is.null(children)) {
  fail("children.dta not found -- did 02 run?")
} else {
  if (anyDuplicated(children[c("key", "child_no")]) > 0) {
    fail("children.dta is not unique on key + child_no")
  }
  if (nrow(children) != 1587) {
    fail(paste0("expected 1,587 child rows, found ", nrow(children)))
  }
}

# Verdict

if (pass) {
  cat("\n  ==============================================\n")
  cat("   ALL CHECKS PASSED -- READY FOR TOMORROW'S HFCs\n")
  cat("   (yes, the duplicates and outliers are still in\n")
  cat("    there. That's the point. See you tomorrow.)    \n")
  cat("  ==============================================\n")
  cat("  Codebook:", codebook_excel, "\n")
} else {
  message("\n  Some checks failed -- fix the script that owns them and re-run MASTER.R.")
}
