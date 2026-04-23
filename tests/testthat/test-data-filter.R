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

  filter_json <- paste0(
    '{',
    '"filters":{',
    '"datasets_filter":{"children":[]},',
    '"subject_filter":{"children":[{',
    '"kind":"row_operation",',
    '"operation":"and",',
    '"children":[{',
    '"kind":"filter",',
    '"dataset":"adsl",',
    '"operation":"select_subset",',
    '"variable":"SEX",',
    '"values":["M"],',
    '"include_NA":true',
    '}]',
    '}]}},',
    '"dataset_list_name":"Demo"',
    '}'
  )

  app$set_inputs(
    `filter-filter_state_json_input` = filter_json,
    allow_no_input_binding_ = TRUE,
    priority_ = "event"
  )
  app$wait_for_idle(duration = 1000)
  app$expect_screenshot()

  app$stop()
})
