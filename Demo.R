# Live Demol
library(magrittr)
library(dplyr)
library(pithr)

titanic <- read.csv(
  "train.csv",
  stringsAsFactors = FALSE,
  na.strings = c("NA", ""))

summary(titanic)

devAskNewPage(TRUE)

pith(titanic, las = 1)

devAskNextPage(FALSE)

titanic %>%
  transmute(LogFare = log(Fare)) %>%
  pith

titanic %>%
  mutate(LogFareP1 = log(Fare + 1)) %>%
  select_pithy(LogFareP1) -> titanic

set.seed(4321)
test_x <- rpois(5000, 2)
test_y <- rpois(5000, 2)

mratio <- function(x, y) {
  rr <- ifelse(x >= y, x / y, y / x)
  mean(rr)
}

mratio(test_x, test_y)

mratio <- function(x, y) {
  rr <- ifelse(x >= y, x / y, y / x) %>%
    pithy
  mean(rr)
}

mratio(test_x, test_y)

mratio <- function(x, y) {
  rr <- ifelse(x >= y, x / y, y / x) 
  rr[is.nan(rr)] <- 1L
  median(rr)
}

mratio(test_x, test_y)

