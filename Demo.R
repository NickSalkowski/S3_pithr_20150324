# Live Demo
library(magrittr)
library(dplyr)
library(pithr)

# Read Some Data
titanic <- read.csv(
  "train.csv",
  stringsAsFactors = FALSE,
  na.strings = c("NA", ""))

# Text Summary
summary(titanic)

# Pause Between Plots
devAskNewPage(TRUE)

# Graphical Summary
pith(titanic, las = 1)

# No Pause Between Plots
devAskNewPage(FALSE)

# Fare looks skewed.  What about a log-transform?
titanic %>%
  transmute(LogFare = log(Fare)) %>%
  pith

# Oops!
titanic %>%
  mutate(LogFareP1 = log(Fare + 1)) %>%
  select_pithy(LogFareP1) -> titanic

# Simple Debugging Example
set.seed(4321)
test_x <- rpois(5000, 2)
test_y <- rpois(5000, 2)

# Summarize the ratio: larger / smaller
mratio <- function(x, y) {
  rr <- ifelse(x >= y, x / y, y / x)
  mean(rr)
}

# Test!
mratio(test_x, test_y)

# Huh? Add pithy
mratio <- function(x, y) {
  rr <- ifelse(x >= y, x / y, y / x) %>%
    pithy
  mean(rr)
}

# Oh. I'm dividing by zero.
mratio(test_x, test_y)

# Set 0/0 == 1 and switch to median
mratio <- function(x, y) {
  rr <- ifelse(x >= y, x / y, y / x) 
  rr[is.nan(rr)] <- 1L
  median(rr)
}

# Test!
mratio(test_x, test_y)

