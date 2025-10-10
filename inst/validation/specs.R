# Use a list to declare the specs

specs_list <- list

specs_list(
  spiderplot_creates_girafe_object = "spiderplot creates girafe object with required parameters",
  spiderplot_handles_color_var = "spiderplot handles color_var parameter", 
  spiderplot_handles_empty_color_var = "spiderplot handles empty string color_var",
  spiderplot_returns_ggplot_non_interactive = "spiderplot returns ggplot when interactive_plot=FALSE",
  spiderplot_color_var_non_interactive = "spiderplot with color variable returns ggplot when interactive_plot=FALSE",
  spiderplot_custom_palette_non_interactive = "spiderplot with custom palette returns ggplot when interactive_plot=FALSE",
  spiderplot_facets_non_interactive = "spiderplot with facets returns ggplot when interactive_plot=FALSE",
  spiderplot_reference_lines_non_interactive = "spiderplot with reference lines returns ggplot when interactive_plot=FALSE",
  spiderplot_title_subtitle_non_interactive = "spiderplot with title and subtitle returns ggplot when interactive_plot=FALSE"
)
