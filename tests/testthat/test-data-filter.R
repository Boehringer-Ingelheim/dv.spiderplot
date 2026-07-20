test_that("data filter functionality works as expected in the app", {
  app <- shinytest2::AppDriver$new(
    app_dir = testthat::test_path("apps/data-filter"),
    name = "data-filter",
    variant = NULL,
    height = 500,
    width = 1000
  )

  app$wait_for_idle(duration = 1000)

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

  filtered_output <- app$get_value(output = "mod1-girafe")
  plot_points <- function(output) {
    matches <- gregexpr("<circle", output, fixed = TRUE)[[1]]
    if (matches[1] == -1L) 0L else length(matches)
  }
  test_data <- dv.spiderplot:::generate_test_data(seed = 1)
  expected_points <- nrow(test_data$adtr[test_data$adtr$SEX == "M", , drop = FALSE])

  expect_equal(plot_points(filtered_output), expected_points)

  app$stop()
})
