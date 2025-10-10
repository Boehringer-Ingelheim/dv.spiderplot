#' Mock Application for Spider Plot Module
#'
#' @description Creates a mock application demonstrating the spider plot module functionality.
#' 
#' @return Launches a Shiny application with the spider plot module
#' 
#' @export
mock_spiderplot_mm <- function() {  
  test_data <- generate_test_data()
  adtr <- test_data$adtr
  adsl <- test_data$adsl
  
  spiderplot_mod <- mod_spiderplot(
    module_id = "mock_spiderplot",
    results_dataset_name = "adtr",
    subjid_var = "USUBJID",
    x_vars = c("AVISIT", "ADY"),
    y_vars = c("PCHG"),
    color_vars = c("ARM", "SEX"),
    tooltip = c(
      "Unique Subject ID: " = "USUBJID", 
      "Planned Arm: " = "ARM",
      "Sex: " = "SEX",
      "Age Group: " = "AGEGRP",
      "Country: " = "COUNTRY"
    ),
    facet_rows = c("SEX", "COUNTRY"),
    facet_cols = c("ARM", "AGEGRP"),
    title = "Mock Spider Plot Demo",
    subtitle = "Example with Test Data"
  )
  
  dv.manager::run_app(
    data = list("Mock Demo" = list(adsl = adsl, adtr = adtr)), 
    module_list = list("Spider Plot" = spiderplot_mod),
    title = "Mock Spider Plot Application",
    filter_data = "adsl",
    filter_key = "USUBJID",
    filter_type = "datasets"
  )
}


#' Generate Test Data for Spider Plot Module
#' 
#' @param n_subjects `[integer(1)]`
#' Number of subjects to generate (default: 10)
#' @param seed `[integer(1) | NULL]`
#' Random seed for reproducibility (default: NULL)
#' 
#' @keywords internal
generate_test_data <- function(n_subjects = 10, seed = NULL) {
  set.seed(seed = seed)

  subject_ids <- sprintf("AB-XYZ-%04d", 1000 + 1:n_subjects)

  adsl <- data.frame(
    USUBJID = subject_ids,
    ARM = sample(c("Arm A", "Arm B"), size = n_subjects, replace = TRUE),
    SEX = sample(c("F", "M"), size = n_subjects, replace = TRUE),
    AGEGRP = sample(c("18-64", ">64"), size = n_subjects, replace = TRUE),
    COUNTRY = sample(c("China", "Germany", "USA"), size = n_subjects, replace = TRUE)
  )
  attr(adsl$USUBJID, "label") <- "Unique Subject Identifier"
  attr(adsl$ARM, "label") <- "Planned Arm"
  attr(adsl$SEX, "label") <- "Sex"
  attr(adsl$AGEGRP, "label") <- "Age Group"
  attr(adsl$COUNTRY, "label") <- "Country"
  
  adtr <- data.frame(
    USUBJID = rep(subject_ids, each = 4),
    AVISIT = rep(c("BASELINE", "WEEK 3", "WEEK 6", "WEEK 9"), n_subjects),
    AVISITN = rep(0:3, n_subjects),
    ADY = rep(0:3 * 7 + 1, n_subjects)
  )
  adtr$PCHG <- ifelse(adtr$AVISITN == 0, 0, 
    round(stats::runif(nrow(adtr), min = -0.5, max = 0.5) * 100, 2)
  )
  adtr <- dplyr::left_join(adtr, adsl, by = "USUBJID")
  attr(adtr$USUBJID, "label") <- "Unique Subject Identifier"
  attr(adtr$AVISIT, "label") <- "Analysis Visit"
  attr(adtr$AVISITN, "label") <- "Analysis Visit Number"
  attr(adtr$ADY, "label") <- "Analysis Relative Day"
  attr(adtr$PCHG, "label") <- "Percent Change from Baseline"
      
  list(adsl = adsl, adtr = adtr)
}
