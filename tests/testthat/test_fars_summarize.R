old.dir <- getwd()
test.dir <- system.file("extdata", package = "fars")

setwd(test.dir)

test_that('fars_summarize_years function: read files in the working directory and summarize it', {
  # Check for inheritance
  expect_is(fars_summarize_years(2013), "tbl")

  # Check for functionality
  expect_equal(nrow(fars_summarize_years(2013)), 12)
  expect_equal(ncol(fars_summarize_years(2013)), 2)
  expect_equal(nrow(fars_summarize_years(2013:2014)), 12)
  expect_equal(ncol(fars_summarize_years(2013:2014)), 3)

  # All values in the output are expected to be integers
  expect_equal(typeof(data.matrix(fars_summarize_years(2013))), "integer")

  # Check for warnings
  expect_warning(fars_summarize_years(2013:2017))
})

setwd(old.dir)
