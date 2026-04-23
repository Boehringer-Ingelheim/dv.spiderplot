data_list <- dv.spiderplot:::generate_test_data(seed = 1)

mod <- dv.spiderplot::mod_spiderplot(
  module_id = "mod",
  subject_level_dataset_name = "adsl",
  results_dataset_name = "adtr",
  subjid_var = "USUBJID",
  x_vars = c("AVISIT", "ADY"),
  y_vars = c("PCHG"),
  receiver_id = "papo"
)

trigger_input_id <- "mod-girafe_selected"
test_communication_with_papo(mod, data_list, trigger_input_id, 
                             "framework_specs$jumping_feature", specs$framework_specs$jumping_feature)
