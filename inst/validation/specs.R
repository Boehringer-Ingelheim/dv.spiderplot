# Use a list to declare the specs

specs_list <- list

specs_list(
  spiderplot_creates_girafe_object =
    "Spider plot displays interactive charts with hover and click features",
  spiderplot_handles_color_var =
    "Spider plot can color data points based on different categories",
  spiderplot_handles_empty_color_var =
    "Spider plot works properly when no color grouping is specified",
  spiderplot_returns_ggplot_non_interactive =
    "Spider plot creates static charts when interactivity is turned off",
  spiderplot_color_var_non_interactive =
    "Spider plot shows colored data groups in static chart format",
  spiderplot_custom_palette_non_interactive =
    "Spider plot allows users to choose their own color schemes for static charts",
  spiderplot_facets_non_interactive =
    "Spider plot can split data into multiple panels in static format",
  spiderplot_reference_lines_non_interactive =
    "Spider plot can display reference lines for comparison in static charts",
  spiderplot_title_subtitle_non_interactive =
    "Spider plot can display custom titles and subtitles on static charts",
  spiderplot_local_filter =
    "Spider plot can filter on values of a variable specified by the user",
  framework_specs = specs_list(
    bookmarking = "Users can save and return to their current view of the application.",
    jumping_feature = "Users can navigate from the spider plot to detailed patient information."
  )
)
