EXERCISE 2 - DESCRIPTIVES IN A LITERATE REPORT
DIL Welcome Week - Data Session 4 - Data analysis: construction & exploration
In pairs - 10 minutes - R

You'll complete a short exploratory report in R Markdown in which no number
is typed: every number is computed when the file renders. The code is written
for you; your job is to find the right variables and fill them in.

Keep your file: in Session 5 the same results go to your PI through Overleaf
(the Overleaf exercise uses the same data and the same indicators).


WHAT'S IN THIS FOLDER
---------------------
  README.txt                   these instructions
  hello.Rmd                    pre-work: render it once to check your setup
  report.Rmd                   the exercise: instructions at the top, fill in the ___
  household_water_clean.csv    the clean data: one row per consenting household

Keep these files together in one folder: report.Rmd reads the data from the
folder it sits in, so there are no paths to set.


YOU NEED
--------
  R and RStudio, with these packages. Run once in the R console:
    install.packages(c("dplyr", "ggplot2", "rmarkdown"))

  Before the session, open hello.Rmd in RStudio and click Knit.


STEPS
-----
Open report.Rmd in RStudio. The code is already written: you fill in the
variable names where you see ___ . The variables are listed at the top of the
file, with what each one means. The same steps are written at the top of
report.Rmd.

  1. RENDER. Click Knit. The template renders as is: the code shows, but no
     table or figure yet, and "NA%" in the sentence. If it doesn't render,
     fix that first.

  2. DESCRIBE. In the "descriptives" chunk, replace each ___ with a variable
     name, then change eval = FALSE to eval = TRUE in the chunk header. Knit.

  3. LOOK. Same in the "figure" chunk. Knit.

  4. SAY IT. Under "Summary", replace the ___ in the inline code (keep the
     quotes) with the variable for "chlorinated on 1+ of the past 7 days".
     Knit: "NA%" becomes a number.

  5. SWITCH IT. Uncomment the two params lines in the header and the STEP 5
     line in the setup chunk, and fill its ___. Then render with the switch
     on, from the R console:
       rmarkdown::render("report.Rmd", params = list(last_week_only = TRUE))
     Did the sentence change, without you typing a number?

Rule: never type a number into the text.
Stuck on syntax? Ask your AI assistant, as you would at work, then read what
it wrote and check the output.


CHECK YOURSELF
--------------
  All fieldwork days:       1,254 households, 69.3% chlorinated their drinking
                            water at least once in the past week.
  last_week_only switched on: 445 households, 69.9%.


IF SOMETHING DOESN'T WORK
-------------------------
  - The table or figure doesn't appear: the chunk header still says
    eval = FALSE. Change it to eval = TRUE.
  - "object 'village_id' not found" in the figure: the first ___ in the
    figure chunk is the village, not the water source.
  - "there is no package called ...": run install.packages("dplyr") (or
    whichever package is named) in the R console.
  - "cannot open file 'household_water_clean.csv'": the data file isn't in
    the same folder as report.Rmd. Keep the files together.
