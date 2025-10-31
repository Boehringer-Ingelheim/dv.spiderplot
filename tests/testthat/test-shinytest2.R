test_that("spiderplot app initializes with correct default input values", {
  app_path <- testthat::test_path("apps", "dv-spiderplot")
  app <- shinytest2::AppDriver$new(app_dir = app_path, name = "dv-spiderplot")

  app_values <- app$get_values()

  expect_equal(app_values$input[["mod_spider-x_var"]], "ADY")
  expect_equal(app_values$input[["mod_spider-y_var"]], "PCHG")
  expect_equal(app_values$input[["mod_spider-color_var"]], "ARM")
  expect_equal(app_values$input[["mod_spider-facet_cols"]], "ARM")
  expect_equal(app_values$input[["mod_spider-facet_rows"]], "SEX")
  expect_equal(app_values$input[["mod_spider-hlines"]], "")
  expect_equal(app_values$input[["mod_spider-vlines"]], "")
})
