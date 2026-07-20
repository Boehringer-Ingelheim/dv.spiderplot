test_that("data selection functionality works as expected in the app", {
  app <- shinytest2::AppDriver$new(
    app_dir = testthat::test_path("apps/data-selection"),
    name = "data-selection",
    variant = NULL,
    height = 500,
    width = 1000
  )

  app$wait_for_idle(duration = 1000)

  demo1_output <- app$get_value(output = "mod1-girafe")
  expect_true(grepl("<circle", demo1_output, fixed = TRUE))

  app$set_inputs(selector = "Demo 2")
  app$wait_for_idle(duration = 1000)

  expect_equal(app$get_value(input = "selector"), "Demo 2")

  app$stop()
})
