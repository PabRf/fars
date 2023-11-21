test_that("Read_data", {
  data = get0("data2013", envir = asNamespace("fars"))
  data = tibble::as_tibble(data)
  expect_equal(data$YEAR[[1]], 2013)
})


test_that("Make_filename", {
  data = get0("data2013", envir = asNamespace("fars"))
  year = data$YEAR[[1]]
  filename = sprintf("data%d", year)
  expect_equal(filename, "data2013")
})
