# Coursera's assignment on "Building R Packages" course

![Travis-CI Build Status](https://travis-ci.org/nobuhiro-kikuchi/fars.svg?branch=master)


Cousera FARS is a package that lets you:

- Read
- Summaries
- Visualize

data from the [Fatality Analysis Reporting System][FARS]. 
This package is the final assignment for the  course [Building R Packages][course],
part of the [Mastering Software Development in R Specialization][specialization].


## Data


FARS data needs to be in your working directory. It is located under "inst/extdata". You can access them with the `system.file` function.

```{r, eval=FALSE }
system.file("extdata", "accident_2013.csv.bz2", package = "fars")
```

## Reading data

 You can use
The `fars_read` function to import a dataset, with filename parameter. 
See vignette for examples.


## Summarizing data

The `fars_summarize_years` function will return wide format tibble with
months on rows, years on columns and number of observations as values.


## Visualizing data

The `fars_map_state` function will draw a map with one point per accident.

[FARS]: https://www.nhtsa.gov/research-data/fatality-analysis-reporting-system-fars
[course]: https://www.coursera.org/learn/r-packages
[specialization]: https://www.coursera.org/specializations/r

