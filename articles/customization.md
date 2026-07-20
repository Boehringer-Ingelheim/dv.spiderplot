# Module Customization

``` r
library(dv.spiderplot)
```

This vignette explains the customization options available in the
[`mod_spiderplot()`](https://boehringer-ingelheim.github.io/dv.spiderplot/reference/mod_spiderplot.md)
function. Each section focuses on a specific parameter (or group of
related parameters) and shows how it affects the plot and the
interactive controls available to end users.

For a general introduction to the module — including data preparation
and how to launch the application — see
[`vignette("dv-spiderplot")`](https://boehringer-ingelheim.github.io/dv.spiderplot/articles/dv-spiderplot.md).

## Data Setup

The examples below use CDISC ADaM-compliant datasets from the
`pharmaverseadam` package.

``` r
adsl <- pharmaverseadam::adsl
adtr <- pharmaverseadam::adtr_onco |>
  dplyr::mutate(
    ARM    = factor(ARM, levels = c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose")),
    SEX    = factor(SEX, levels = c("F", "M"), labels = c("Female", "Male")),
    AVISIT = forcats::fct_reorder(AVISIT, AVISITN)
  )

attr(adtr[["ARM"]], "label") <- "Planned Arm"
attr(adtr[["SEX"]], "label") <- "Sex"
attr(adtr[["AVISIT"]], "label") <- "Analysis Visit"

attr(adsl, "meta") <- list(mtime = Sys.time())
attr(adtr, "meta") <- list(mtime = Sys.time())
```

## Variable Selection

**Parameters:** `x_vars`, `y_vars`

Supply a character vector to `x_vars` and `y_vars` to define which
variables end users can select for the x- and y-axes.

``` r
spiderplot_mod <- mod_spiderplot(
  module_id = "mod_spider",
  subject_level_dataset_name = "adsl",
  results_dataset_name = "adtr",
  subjid_var = "USUBJID",
  x_vars = c("ADY", "AVISIT"),
  y_vars = c("PCHG", "CHG")
)
```

``` r
dv.manager::run_app(
  data = list("Demo" = list(adsl = adsl, adtr = adtr)), 
  module_list = list("Spider Plot" = spiderplot_mod),
  title = "Spider Plot Demo",
  filter_data = "adsl",
  filter_key = "USUBJID"
)
```

## Color Grouping

**Parameters:** `color_vars`, `color_palette`

Set `color_vars` to expose a **Color Variable** dropdown in the Plot
Options panel. The variables listed in `color_vars` must exist in the
**subject-level** dataset.

``` r
spiderplot_mod <- mod_spiderplot(
  module_id = "mod_spider",
  subject_level_dataset_name = "adsl",
  results_dataset_name = "adtr",
  subjid_var = "USUBJID",
  x_vars = c("ADY", "AVISIT"),
  y_vars = c("PCHG", "CHG"),
  color_vars = c("ARM", "SEX")
)
```

Use `color_palette` to map specific factor levels to colors. The palette
must be a **named character vector** where names are factor level values
and values are color strings.

``` r
spiderplot_mod <- mod_spiderplot(
  module_id = "mod_spider",
  subject_level_dataset_name = "adsl",
  results_dataset_name = "adtr",
  subjid_var = "USUBJID",
  x_vars = c("ADY", "AVISIT"),
  y_vars = c("PCHG", "CHG"),
  color_vars = c("ARM", "SEX"),
  color_palette = c(
    "Placebo" = "#E41A1C",
    "Xanomeline Low Dose" = "#377EB8",
    "Xanomeline High Dose" = "#4DAF4A"
  )
)
```

## Faceting

**Parameters:** `facet_rows`, `facet_cols`

Faceting splits the spider plot into a grid of sub-plots. Set
`facet_rows` to define the row dimension and `facet_cols` for the column
dimension.

``` r
spiderplot_mod <- mod_spiderplot(
  module_id  = "mod_spider",
  subject_level_dataset_name = "adsl",
  results_dataset_name = "adtr",
  subjid_var = "USUBJID",
  x_vars = c("ADY", "AVISIT"),
  y_vars = c("PCHG", "CHG"),
  facet_rows = c("SEX"),
  facet_cols = c("AGEGR1", "ARM")
)
```

## Plot Dimensions

**Parameters:** `height_default`, `height_range`

The plot height is exposed to users via a **Height** slider in the Plot
Options panel. Two parameters control it:

- `height_default` sets the initial slider value in inches
- `height_range` sets the `c(min, max)` bounds of the slider

``` r
spiderplot_mod <- mod_spiderplot(
  module_id = "mod_spider",
  subject_level_dataset_name = "adsl",
  results_dataset_name = "adtr",
  subjid_var = "USUBJID",
  x_vars = c("ADY", "AVISIT"),
  y_vars = c("PCHG", "CHG"),
  height_default = 6,
  height_range = c(4, 8)
)
```

## Plot Title and Subtitle

**Parameters:** `title`, `subtitle`

A static title and subtitle can be set for the plot. These are fixed at
module configuration time and cannot be changed by the user at runtime.

``` r
spiderplot_mod <- mod_spiderplot(
  module_id = "mod_spider",
  subject_level_dataset_name = "adsl",
  results_dataset_name = "adtr",
  subjid_var = "USUBJID",
  x_vars = c("ADY", "AVISIT"),
  y_vars = c("PCHG", "CHG"),
  title = "Tumor Size Change Over Time",
  subtitle = "Study CDISC-PILOT-01"
)
```
