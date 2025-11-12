adsl <- pharmaverseadam::adsl
adtr <- pharmaverseadam::adtr_onco |>
  dplyr::mutate(
    ARM = factor(ARM, levels = c("Placebo", "Xanomeline Low Dose", "Xanomeline High Dose")),
    SEX = factor(SEX, levels = c("F", "M"), labels = c("Female", "Male")),
    AVISIT = forcats::fct_reorder(AVISIT, AVISITN)
  )

attr(adtr[["ARM"]], "label") <- "Planned Arm"
attr(adtr[["SEX"]], "label") <- "Sex"
attr(adtr[["AVISIT"]], "label") <- "Analysis Visit"

spiderplot_mod <- dv.spiderplot::mod_spiderplot(
  module_id = "mod_spider",
  subject_level_dataset_name = "adsl",
  results_dataset_name = "adtr",
  subjid_var = "USUBJID",
  x_vars = c("ADY", "AVISIT"),
  y_vars = c("PCHG", "CHG"),
  color_vars = c("ARM", "AGEGR1"),
  color_palette = c(
    "Placebo" = "red",
    "Xanomeline Low Dose" = "green",
    "Xanomeline High Dose" = "blue"
  ),
  tooltip = c(
    "Unique Subject Identifier: " = "USUBJID",
    "Planned Arm: " = "ARM",
    "Analysis Visit: " = "AVISIT",
    "Days Since Randomization: " = "ADY",
    "Change from Baseline: " = "CHG",
    "Percent Change from Baseline: " = "PCHG"
  ),
  facet_rows = c("SEX", "ETHNIC"),
  facet_cols = c("ARM", "AGEGR1"),
  title = "Interactive Spider Plot",
  subtitle = "CDISC-PILOT-01"
)

# launch shiny app
dv.manager::run_app(
  data = list("Demo" = list(adsl = adsl, adtr = adtr)), 
  module_list = list("Spider Plot" = spiderplot_mod),
  title = "Spider Plot Demo",
  filter_data = "adsl",
  filter_key = "USUBJID",
  filter_type = "datasets"
)
