dv.manager::run_app(
  data = list(
    "Demo 1" = dv.spiderplot:::generate_test_data(seed = 1),
    "Demo 2" = dv.spiderplot:::generate_test_data(seed = 2)
  ),
  module_list = list(
    "Spider Plot" = dv.spiderplot::mod_spiderplot(
      module_id = "mod1",
      subject_level_dataset_name = "adsl",
      results_dataset_name = "adtr",
      subjid_var = "USUBJID",
      x_vars = c("AVISIT", "ADY"),
      y_vars = c("PCHG")
    )
  ),
  filter_data = "adsl",
  filter_key = "USUBJID"
)
