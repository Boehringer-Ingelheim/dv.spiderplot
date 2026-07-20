# Spider Plot Module

Creates an interactive spider plot module for visualizing individual
patient trajectories over time in clinical trials.

## Usage

``` r
mod_spiderplot(
  module_id,
  subject_level_dataset_name,
  results_dataset_name,
  subjid_var,
  x_vars,
  y_vars,
  color_vars = NULL,
  color_palette = NULL,
  tooltip = NULL,
  facet_rows = NULL,
  facet_cols = NULL,
  height_default = NULL,
  height_range = NULL,
  title = NULL,
  subtitle = NULL,
  filter_var = NULL,
  filter_values = NULL,
  filter_default_vals = NULL,
  receiver_id = NULL
)
```

## Arguments

- module_id:

  `[character(1)]` Unique identifier for the module.

- subject_level_dataset_name:

  `[character(1)]` Name of the dataset containing the subject level
  information (e.g., "adsl").

- results_dataset_name:

  `[character(1)]` Name of the dataset containing the analysis results
  (e.g., "adtr").

- subjid_var:

  `[character(1)]` Variable name for subject identifier. (e.g.,
  "USUBJID").

- x_vars:

  `[character(1+)]` A character vector of variable names for the x-axis.
  Each element must be a valid column name in the results dataset.
  Supported types are numeric (e.g. "ADY") and character/factor (e.g.
  "AVISIT"). When multiple variables are supplied (e.g., c("ADY",
  "AVISIT")), the first element is used as default in the plot.

- y_vars:

  `[character(1+)]` A character vector of variable names for the y-axis.
  Each element must be a valid column name in the results dataset.
  Supported types are numeric (e.g. "PCHG", "CHG"). At least one valid
  variable is required.

- color_vars:

  `[character(1+) | NULL]` Variable name(s) for color grouping (e.g.,
  treatment arm).

- color_palette:

  `[named character(1+) | NULL]` Custom color palette mapping factor
  levels to (hex) colors.

- tooltip:

  `[named character vector | NULL]` Named character vector specifying
  tooltip content. Names are labels, values are column names. If NULL,
  defaults to using the subject ID variable for tooltips.

- facet_rows:

  `[character(1+) | NULL]` Variable names for row faceting. (Splitting
  plot into subplots by rows)

- facet_cols:

  `[character(1+) | NULL]` Variable names for column faceting.
  (Splitting plot into subplots by columns)

- height_default:

  `[numeric(1) | NULL]` Default plot height in inches. If NULL, defaults
  to 5 inches.

- height_range:

  `[numeric(2) | NULL]` Range of allowable plot heights in inches. If
  NULL, defaults to c(1, height_default \* 2).

- title:

  `[character(1) | NULL]` Main plot title.

- subtitle:

  `[character(1) | NULL]` Plot subtitle for additional context.

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

- receiver_id:

  `[character(1) | NULL]` Module ID that will receive patient selection
  events from this module.
