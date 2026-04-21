test_data <- dv.spiderplot:::generate_test_data(seed = 1)
adsl <- test_data$adsl
adtr <- test_data$adtr

spiderplot_mod <- dv.spiderplot::mod_spiderplot(
  module_id = "mod_spider",
  subject_level_dataset_name = "adsl",
  results_dataset_name = "adtr",
  subjid_var = "USUBJID",
  x_vars = c("AVISIT", "ADY"),
  y_vars = c("PCHG"),
  color_vars = c("ARM", "SEX"),
  facet_rows = c("AGEGRP"),
  facet_cols = c("COUNTRY"),
  title = "Interactive Spider Plot",
  subtitle = "Test Data Demo"
)

dv.manager::run_app(
  data = list("Demo" = list(adsl = adsl, adtr = adtr)), 
  module_list = list("Spider Plot" = spiderplot_mod),
  title = "Spider Plot Demo - Bookmarking Test",
  filter_data = "adsl",
  filter_key = "USUBJID",
  enableBookmarking = "url"  # Enable bookmarking for testing
)
