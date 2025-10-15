dv.manager::run_app(
  data = list(
    "Demo" = dv.spiderplot:::generate_test_data(seed = 1)
  ),
  module_list = list(
    "Spider Plot" = dv.spiderplot::mod_spiderplot(
      module_id = "mod1",
      results_dataset_name = "adtr",
      subjid_var = "USUBJID",
      x_vars = c("AVISIT", "ADY"),
      y_vars = c("PCHG")
    )
  ),
  filter_data = "adsl",
  filter_key = "USUBJID"
)
