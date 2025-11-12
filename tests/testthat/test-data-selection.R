test_that("data selection functionality works as expected in the app", {
  app <- shinytest2::AppDriver$new(
    app_dir = testthat::test_path("apps/data-selection"),
    name = "data-selection", 
    variant = NULL,
    height = 500, 
    width = 1000
  )

  app$wait_for_idle(duration = 1000)
  app$expect_screenshot()
  
  app$set_inputs(selector = "Demo 2")
  app$wait_for_idle(duration = 1000)
  app$expect_screenshot()

  app$stop()
})
