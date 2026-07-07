#' @importFrom ggplot2 .data
spiderplot <- function(
  data, 
  x_var, 
  y_var, 
  group_var, 
  color_var = NULL,
  color_palette = NULL,
  tooltip = NULL,
  facet_rows = NULL,
  facet_cols = NULL,
  hlines = NULL,
  vlines = NULL,
  title = NULL,
  subtitle = NULL,
  width_svg = NULL,
  height_svg = NULL,
  rescale = TRUE,
  interactive_plot = TRUE
) {
  spider_plot <- ggplot2::ggplot(
    data = data,
    mapping = ggplot2::aes(
      x = .data[[x_var]],
      y = .data[[y_var]],
      group = .data[[group_var]]
    )
  )
  if (is.null(tooltip)) tooltip <- group_var
  spider_plot <- spider_plot + ggiraph::geom_point_interactive(
    mapping = ggplot2::aes(
      tooltip = .data[[tooltip]],
      data_id = .data[[group_var]]
    )
  )
  spider_plot <- spider_plot + ggiraph::geom_line_interactive(
    mapping = ggplot2::aes(data_id = .data[[group_var]])
  )
  if (!is.null(hlines)) {
    spider_plot <- spider_plot +
      ggplot2::geom_hline(yintercept = hlines, color = "grey50", linetype = "dotted")
  }
  if (!is.null(vlines)) {
    spider_plot <- spider_plot +
      ggplot2::geom_vline(xintercept = vlines, color = "grey50", linetype = "dotted")
  }
  rows <- if (is.null(facet_rows)) "." else paste(facet_rows, collapse = "+")
  cols <- if (is.null(facet_cols)) "." else paste(facet_cols, collapse = "+")
  if (rows != "." || cols != ".") {
    spider_plot <- spider_plot + 
      ggplot2::facet_grid(stats::reformulate(cols, rows))
  }
  x_label <- attr(data[[x_var]], "label")
  y_label <- attr(data[[y_var]], "label")
  if (is.null(x_label)) x_label <- x_var
  if (is.null(y_label)) y_label <- y_var 
  spider_plot <- spider_plot + 
    ggplot2::labs(
      title = title,
      subtitle = subtitle,
      x = x_label,
      y = y_label
    ) +
    ggplot2::theme_minimal(base_family = "Liberation Sans", base_size = 9)
  if (!is.null(color_var) && color_var == "") color_var <- NULL
  if (!is.null(color_var)) {
    color_label <- attr(data[[color_var]], "label")
    if (is.null(color_label)) color_label <- color_var
    spider_plot <- spider_plot + 
      ggplot2::aes(color = .data[[color_var]]) +
      ggplot2::labs(color = color_label) +
      ggplot2::theme(legend.position = "bottom")
    # custom color palette
    if (!is.null(color_palette)) {
      color_levels <- levels(factor(data[[color_var]]))
      color_values <- stats::setNames(object = rep("grey50", length(color_levels)), nm = color_levels)
      color_values[names(color_palette)] <- color_palette
      if (any(color_levels %in% names(color_palette))) {
        spider_plot <- spider_plot +
          ggplot2::scale_color_manual(values = color_values)        
      }
    }
  }
  girafe_options <- list(
    ggiraph::opts_hover(css = ggiraph::girafe_css(css = NULL)),
    ggiraph::opts_selection(css = "r:2px;stroke-width:2px;", type = "single"),
    ggiraph::opts_selection_inv(css = "opacity:0.2;"),
    ggiraph::opts_sizing(rescale = rescale)
  )
  if (!is.null(width_svg) && is.na(width_svg)) width_svg <- NULL
  if (!is.null(height_svg) && is.na(height_svg)) height_svg <- NULL
  spider_plot_interactive <- ggiraph::girafe(
    ggobj = spider_plot,
    width_svg = width_svg,
    height_svg = height_svg,
    options = girafe_options
  )
  if (interactive_plot) {
    return(spider_plot_interactive)
  } else {
    return(spider_plot)
  }
}
