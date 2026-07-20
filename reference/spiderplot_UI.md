# Spider Plot Module UI

Spider Plot Module UI

## Usage

``` r
spiderplot_UI(
  id,
  show_color_vars,
  show_facet_rows,
  show_facet_cols,
  height_default = NULL,
  height_range = NULL,
  filter_var,
  filter_values,
  filter_default_vals
)
```

## Arguments

- id:

  `[character(1)]` Unique identifier for the module UI.

- show_color_vars:

  `[logical(1)]` Whether to show the color variable selection.

- show_facet_rows:

  `[logical(1)]` Whether to show the facet rows selection.

- show_facet_cols:

  `[logical(1)]` Whether to show the facet columns selection.

- height_default:

  `[numeric(1) | NULL]` Default plot height in inches. If NULL, defaults
  to 5 inches.

- height_range:

  `[numeric(2) | NULL]` Range of allowable plot heights in inches. If
  NULL, defaults to c(1, height_default \* 2).

- filter_var:

  `[character(1) | NULL]` Name of variable to use for local filtering.
  This variable must exist on the dataset specified by
  `subject_level_dataset_name` or `results_dataset_name`.

- filter_values:

  `[character(1+) | NULL]` Character vector restricting the available
  filter choices.

- filter_default_vals:

  `[character(1+) | NULL]` Default selected values for the filter
  variable upon initialization.
