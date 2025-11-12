test_that("The app's state is restored when bookmarking" %>%
  vdoc[["add_spec"]](specs$framework_specs$bookmarking), {
  app_bmk <- shinytest2::AppDriver$new(
    app_dir = testthat::test_path("apps/bookmarking"), 
    name = "test_bookmarking"
  )
  app_bmk$wait_for_idle()

  app_bmk$set_inputs(`mod_spider-x_var` = "ADY")
  app_bmk$set_inputs(`mod_spider-color_var` = "SEX")
  app_bmk$set_inputs(`mod_spider-hlines` = "-20, 20")
  app_bmk$set_inputs(`mod_spider-vlines` = "10, 20")

  app_bmk$run_js("document.getElementById('._bookmark_').click()")
  app_bmk$wait_for_idle()

  bmk_url <- app_bmk$get_js("document.querySelector('.modal-dialog textarea').value")
    
  app_rst <- shinytest2::AppDriver$new(
    app_dir = bmk_url, 
    name = "test_restoring"
  )
  app_rst$wait_for_idle()

  actual <- app_rst$get_values(
    input = c(
      "mod_spider-x_var", 
      "mod_spider-color_var",
      "mod_spider-hlines", 
      "mod_spider-vlines"
    )
  )
  expected <- list(
    input = list(
      `mod_spider-color_var` = "SEX",
      `mod_spider-hlines` = "-20, 20",
      `mod_spider-vlines` = "10, 20",
      `mod_spider-x_var` = "ADY"
    )
  )
  testthat::expect_identical(actual, expected)

  app_bmk$stop()
  app_rst$stop()
  })
