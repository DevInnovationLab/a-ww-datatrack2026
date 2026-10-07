EXERCISE 1 - CONSTRUCTION BUG HUNT
DIL Welcome Week - Data Session 4 - Data analysis: construction & exploration
In pairs - 12 minutes - Stata or R


Your AI assistant wrote a construction script for the PI's fieldwork update.
It runs without errors and the numbers look reasonable.

It is wrong in five places.

Your job is not to rewrite it. Your job is to find the bugs and add the
checks (assertions) that would have stopped the script before anyone saw
the wrong numbers.


WHAT'S IN THIS FOLDER
---------------------
  README.txt            these instructions
  codebook.txt          every variable, its question, codes and skip patterns
  data/households.csv   the clean household data: one row per submission
  data/children.csv     the clean child data: one row per child under 5
  01_construct.do       the script, Stata version
  01_construct.R        the same script, R version
  exercise1.Rproj       R users: open this first (R then starts in this folder)

Use EITHER Stata OR R: the two scripts do exactly the same thing.


HOW TO RUN IT
-------------
  Stata: double-click 01_construct.do (Stata starts in this folder), or in
         Stata type  cd "/path/to/exercise1"  then run the file (Do).
  R:     double-click exercise1.Rproj, open 01_construct.R and click Source.
         You need the dplyr package: install.packages("dplyr")

It writes output/village_indicators.csv: one row per village with three
indicators for the PI.


STEPS
-----
  1. RUN IT. Read the output. Does anything look wrong? (It may not.)

  2. FIND AT LEAST TWO BUGS. Read the script next to codebook.txt. For every
     step, ask: what do I expect this step to do to the data, and is that
     true? Look at the data before and after each step:
       Stata: count, isid, tab ..., missing, summarize, list in 1/10
       R:     nrow(), anyDuplicated(), table(..., useNA = "ifany"), summary()

  3. ADD ONE ASSERTION PER BUG, at the point where it would have stopped the
     script. An assertion states what must be true and stops the script if
     it isn't:
       Stata: assert <condition>        isid <id variables>
       R:     stopifnot(<condition>)    (or assertthat::assert_that())
     Run the script again: your assertion should now stop it.

Success = writing the checks, not finding all five.


WHERE TO LOOK
-------------
The dangerous steps in construction: joining data, changing the unit of
observation, aggregating, and reading missing values. Every bug here comes
from a real feature of this data that the script ignored, and the codebook
tells you about each one.


IF YOU FINISH EARLY
-------------------
  - Ask your AI assistant to review the script. Compare what it found with
    what you found. Which bugs did it miss? Did it flag anything that wasn't
    a bug?
  - Write the data-dictionary entry for one corrected indicator: name,
    definition, unit, and the decisions you made.
