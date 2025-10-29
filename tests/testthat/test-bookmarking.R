test_that("The app's state is restored when bookmarking" %>%
  vdoc[["add_spec"]](specs$framework_specs$bookmarking), {
    app_bmk <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("apps/bookmarking"), name = "test_bookmarking"
    )
    app_bmk$wait_for_idle()
  
    app_bmk$set_inputs(`mod_spider-x_var` = "AVISIT")
    app_bmk$set_inputs(`mod_spider-y_var` = "CHG")
    app_bmk$set_inputs(`mod_spider-color_var` = "AGEGR1")
    app_bmk$set_inputs(`mod_spider-facet_rows` = "ETHNIC")
    app_bmk$set_inputs(`mod_spider-facet_cols` = "AGEGR1")
    app_bmk$set_inputs(`mod_spider-hlines` = "-20, -30")
    app_bmk$set_inputs(`mod_spider-vlines` = "21, 42")
  
    app_bmk$run_js("document.getElementById('._bookmark_').click()")
    app_bmk$wait_for_idle()
  
    bmk_url <- app_bmk$get_js("document.querySelector('.modal-dialog textarea').value")
      
    app_rst <- shinytest2::AppDriver$new(app_dir = bmk_url, name = "test_restoring")
    app_rst$wait_for_idle()
  
    actual <- app_rst$get_values(
      input = c(
        "mod_spider-x_var", 
        "mod_spider-y_var", 
        "mod_spider-color_var",
        "mod_spider-facet_rows", 
        "mod_spider-facet_cols", 
        "mod_spider-hlines", 
        "mod_spider-vlines"
      )
    )
    expected <- list(
      input = list(
        `mod_spider-color_var` = "AGEGR1",
        `mod_spider-facet_cols` = "AGEGR1",
        `mod_spider-facet_rows` = "ETHNIC",
        `mod_spider-hlines` = "-20, -30",
        `mod_spider-vlines` = "21, 42",
        `mod_spider-x_var` = "AVISIT",
        `mod_spider-y_var` = "CHG"
      )
    )
    testthat::expect_identical(actual, expected)
    
    app_bmk$stop()
    app_rst$stop()
  }
)
