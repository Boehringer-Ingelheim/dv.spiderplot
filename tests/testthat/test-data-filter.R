test_that("data filter functionality works as expected in the app", {
  app <- shinytest2::AppDriver$new(
    app_dir = testthat::test_path("apps/data-filter"),
    name = "data-filter",
    variant = NULL,    
    height = 500, 
    width = 1000
  )

  app$wait_for_idle(duration = 1000)
  app$expect_screenshot()
  
  app$set_inputs(`global_filter-vars_open` = TRUE, allow_no_input_binding_ = TRUE)
  app$set_inputs(`global_filter-vars` = "SEX")
  app$set_inputs(`global_filter-vars_open` = FALSE, allow_no_input_binding_ = TRUE)
  app$set_inputs(`global_filter-SEX_open` = TRUE, allow_no_input_binding_ = TRUE)  
  app$set_inputs(`global_filter-SEX` = "M")
  app$set_inputs(`global_filter-SEX_open` = FALSE, allow_no_input_binding_ = TRUE)
  app$wait_for_idle(duration = 1000)
  app$expect_screenshot()

  app$stop()
})
