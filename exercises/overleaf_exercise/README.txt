EXERCISE - RESULTS THAT UPDATE THEMSELVES IN OVERLEAF
DIL Welcome Week - Data Session 5 - Publication: Reports & Replicability
About 20 minutes - Stata or R

Your PI reads fieldwork updates in Overleaf. In this exercise the update's
numbers never get typed: your code writes them to files, GitHub carries the
files to Overleaf, and the report only points at them.

You will:
  1. connect your own Overleaf project to GitHub,
  2. point the code at your local copy of that GitHub repository,
  3. run it, push, and see your results in Overleaf,
  4. change one flag to switch the report to the last week of fieldwork, run
     again, and watch every number update.

Use EITHER Stata OR R: both write exactly the same files.


WHAT'S IN THIS FOLDER
---------------------
  README.txt                these instructions
  overleaf.zip              the PI update, ready to upload to Overleaf
  overleaf/                 the same files, unzipped:
      main.tex                  the report (it never contains a typed number)
      tables/numbers.tex        every number quoted in the text  (written by the code)
      tables/tab1-water-practices.tex   Table 1                  (written by the code)
      figures/fig1-chlorination-village.png   Figure 1          (written by the code)
  data/                     the clean data (already prepared, nothing to do)
      households_clean.csv      one row per household visited
      children_clean.csv        one row per child under 5
  stata/                    Stata version: run stata/main.do
      main.do                   the only file you edit
      code/2-export-outputs.do  writes the three files (no need to open it)
      ado/                      ieboilstart, so nothing to install
  R/                        R version: run R/main.R
      main.R                    the only file you edit
      2-export-outputs.R        writes the three files (no need to open it)


YOU NEED
--------
  - A GitHub account and GitHub Desktop (desktop.github.com)
  - An Overleaf account with GitHub sync (a premium feature: use the licence
    the course gives you)
  - Stata 15 or later, OR R with these packages (run once in the R console):
      install.packages(c("dplyr", "tidyr", "ggplot2"))


STEPS
-----
1. CREATE YOUR OVERLEAF PROJECT (2 min)
   In Overleaf: New Project > Upload Project, and choose overleaf.zip.
   Click Recompile: you should see a two-page fieldwork update.

2. CONNECT IT TO GITHUB (2 min)
   In your Overleaf project: Menu > Sync > GitHub > Create a GitHub repository
   (any name, e.g. ww2026-overleaf-yourname). Overleaf copies the project into
   that new repository.

3. CLONE IT TO YOUR COMPUTER (2 min)
   In GitHub Desktop: File > Clone repository, pick the repository you just
   created, and note the local path it shows
   (e.g. /Users/you/Documents/GitHub/ww2026-overleaf-yourname).
   This folder is your "Overleaf clone".

4. POINT THE CODE AT YOUR CLONE, RUN, PUSH, PULL (6 min)

   Stata: open stata/main.do. In section "2 Set file paths", copy Nandita's
   block and change it for yourself:

     // YOU
     else if "`c(username)'" == "yourusername" {         // di c(username) shows it
         global ex           "/path/to/overleaf_exercise"  // this folder
         global report_clone "/path/to/your/overleaf/clone"
     }

   R: open R/main.R. In section "2 Your two paths", do the same:

     } else if (user == "yourusername") {                # Sys.info()[["user"]] shows it
       exercise_dir <- "/path/to/overleaf_exercise"      # this folder
       overleaf_dir <- "/path/to/your/overleaf/clone"
     }

   Windows: use forward slashes in paths (C:/Users/...).

   Then:
     a. RUN main.do (Do) or main.R (Source). It writes tables/numbers.tex,
        tables/tab1-water-practices.tex and figures/fig1-chlorination-village.png
        into your clone. Open numbers.tex to see what the report will quote.
     b. PUSH: in GitHub Desktop, commit the changed files (message: "Update
        outputs") and click Push origin.
        (R users can instead set push_to_github <- TRUE in main.R and run again.)
     c. PULL IN OVERLEAF: Menu > Sync > GitHub > Pull GitHub changes into
        Overleaf, then Recompile.

   The PDF looks the same as before, but its numbers now come from your run.

5. CHANGE THE FLAG AND RUN AGAIN (4 min)
   Your PI asks: "Does this hold if you only look at the last week of
   fieldwork?"
     Stata: in main.do, section 1, set   global last_week_only 1
     R:     in main.R, section 1, set    last_week_only <- TRUE
   Run, push, pull in Overleaf, recompile.

   Check the PDF: the dates, the number of households, every percentage in the
   text, Table 1, Figure 1 and the notes should all have changed, and you
   didn't type any of them. With all fieldwork the report covers 1,293
   households visited; with the last week only, 452.


THREE RULES
-----------
  1. Nobody types a number into main.tex. Numbers come from tables/numbers.tex.
  2. Files in tables/ and figures/ are only ever changed by the code.
  3. main.tex is only ever edited in Overleaf.


IF YOU GET STUCK
----------------
  - Stata: "file .../main.tex not found"
      global report_clone doesn't point to your clone. Check the path in
      GitHub Desktop (Repository > Show in Finder / Show in Explorer).
  - Stata: "command ieboilstart is unrecognized", or "file ...
    households_clean.csv not found"
      global ex doesn't point to this folder.
  - R: "Add a block for your username"
      Your username isn't in section 2 of main.R yet.
  - R: "exercise_dir is wrong" / "overleaf_dir is wrong"
      The path doesn't point to this folder / to your clone.
  - R: "there is no package called ..."
      install.packages("dplyr") (or whichever package is named).
  - GitHub Desktop shows no changes
      The code wrote somewhere else: check the path to your clone.
  - Overleaf: the PDF didn't change
      You recompiled without pulling, or didn't push. GitHub Desktop should
      say "No local changes" after pushing.
  - Overleaf: merge conflict when pulling
      Someone edited tables/ or figures/ in Overleaf. Rule 2: keep the GitHub
      version.
  - No GitHub option in Overleaf's menu
      Your Overleaf account doesn't have GitHub sync. Skip steps 2-3: leave
      your clone path empty (Stata) or point overleaf_dir to overleaf/ in
      this folder (R), run, and upload the three files to Overleaf by hand
      (Upload, replace existing).
