old.dir <- getwd()
test.dir <- system.file("extdata", package = "fars")

setwd(test.dir)

test_that('fars_read_years function: read files in the working directory', {
  # Check for inheritance
  expect_is(fars_read_years(2013:2014), "list")

  # Check for functionality
  expect_equal(length(fars_read_years(2013:2014)), 2)

  # Check for warnings
  expect_warning(fars_read_years(0))
})

setwd(old.dir)
