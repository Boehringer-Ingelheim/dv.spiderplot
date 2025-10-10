library(ggplot2)
library(ggiraph)
library(vdiffr)

test_datasets <- generate_test_data(seed = 1)
test_data <- test_datasets$adtr

test_that(
  vdoc[["add_spec"]]("spiderplot creates girafe object with required parameters", specs$spiderplot_creates_girafe_object),
  {
  plot <- spiderplot(
    data = test_data,
    x_var = "AVISIT",
    y_var = "PCHG",
    group_var = "USUBJID"
  )
  
  expect_s3_class(plot, "girafe")
})

test_that(
  vdoc[["add_spec"]]("spiderplot handles color_var parameter", specs$spiderplot_handles_color_var),
  {
  plot <- spiderplot(
    data = test_data,
    x_var = "AVISIT",
    y_var = "PCHG",
    group_var = "USUBJID",
    color_var = "ARM"
  )
  
  expect_s3_class(plot, "girafe")
})

test_that(
  vdoc[["add_spec"]]("spiderplot handles empty string color_var", specs$spiderplot_handles_empty_color_var),
  {
  plot <- spiderplot(
    data = test_data,
    x_var = "AVISIT",
    y_var = "PCHG",
    group_var = "USUBJID",
    color_var = ""
  )
  
  expect_s3_class(plot, "girafe")
})

test_that(
  vdoc[["add_spec"]]("spiderplot returns ggplot when interactive_plot=FALSE", specs$spiderplot_returns_ggplot_non_interactive),
  {
  plot <- spiderplot(
    data = test_data,
    x_var = "AVISIT",
    y_var = "PCHG",
    group_var = "USUBJID",
    interactive_plot = FALSE
  )
  
  expect_s3_class(plot, "ggplot")
  
  vdiffr::expect_doppelganger("spiderplot basic non-interactive", plot)
})

test_that(
  vdoc[["add_spec"]]("spiderplot with color variable returns ggplot when interactive_plot=FALSE", specs$spiderplot_color_var_non_interactive),
  {
  plot <- spiderplot(
    data = test_data,
    x_var = "AVISIT",
    y_var = "PCHG",
    group_var = "USUBJID",
    color_var = "ARM",
    interactive_plot = FALSE
  )
  
  expect_s3_class(plot, "ggplot")
  
  vdiffr::expect_doppelganger("spiderplot with color non-interactive", plot)
})

test_that(
  vdoc[["add_spec"]]("spiderplot with custom palette returns ggplot when interactive_plot=FALSE", specs$spiderplot_custom_palette_non_interactive),
  {
  custom_palette <- c("Placebo" = "#FF0000", "Xanomeline Low Dose" = "#00FF00", "Xanomeline High Dose" = "#0000FF")
  
  plot <- spiderplot(
    data = test_data,
    x_var = "AVISIT",
    y_var = "PCHG",
    group_var = "USUBJID",
    color_var = "ARM",
    color_palette = custom_palette,
    interactive_plot = FALSE
  )
  
  expect_s3_class(plot, "ggplot")
  
  vdiffr::expect_doppelganger("spiderplot with custom palette non-interactive", plot)
})

test_that(
  vdoc[["add_spec"]]("spiderplot with facets returns ggplot when interactive_plot=FALSE", specs$spiderplot_facets_non_interactive),
  {
  plot <- spiderplot(
    data = test_data,
    x_var = "AVISIT",
    y_var = "PCHG",
    group_var = "USUBJID",
    facet_rows = "SEX",
    facet_cols = "AGEGRP",
    interactive_plot = FALSE
  )
  
  expect_s3_class(plot, "ggplot")
  
  vdiffr::expect_doppelganger("spiderplot with facets non-interactive", plot)
})

test_that(
  vdoc[["add_spec"]]("spiderplot with reference lines returns ggplot when interactive_plot=FALSE", specs$spiderplot_reference_lines_non_interactive),
  {
  plot <- spiderplot(
    data = test_data,
    x_var = "AVISIT",
    y_var = "PCHG",
    group_var = "USUBJID",
    hlines = c(-20, -50),
    vlines = c("WEEK 3", "WEEK 6"),
    interactive_plot = FALSE
  )
  
  expect_s3_class(plot, "ggplot")
  
  vdiffr::expect_doppelganger("spiderplot with reference lines non-interactive", plot)
})

test_that(
  vdoc[["add_spec"]]("spiderplot with title and subtitle returns ggplot when interactive_plot=FALSE", specs$spiderplot_title_subtitle_non_interactive),
  {
  plot <- spiderplot(
    data = test_data,
    x_var = "AVISIT",
    y_var = "PCHG",
    group_var = "USUBJID",
    title = "Test Spider Plot",
    subtitle = "Test Subtitle",
    interactive_plot = FALSE
  )
  
  expect_s3_class(plot, "ggplot")
  
  vdiffr::expect_doppelganger("spiderplot title subtitle", plot)
})
