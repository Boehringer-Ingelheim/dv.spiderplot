# Automatically generated module API check functions. Think twice before editing them manually.
({
# styler: off

# dv.spiderplot::mod_spiderplot
check_mod_spiderplot_auto <- function(afmm, datasets, module_id, subject_level_dataset_name, results_dataset_name,
    subjid_var, x_vars, y_vars, color_vars, color_palette, tooltip, facet_rows, facet_cols, height_default,
    height_range, title, subtitle, filter_var, filter_values, filter_default_vals, receiver_id, err) {
    OK <- logical(0)
    used_dataset_names <- new.env(parent = emptyenv())
    OK[["module_id"]] <- CM$check_module_id("module_id", module_id, err)
    flags <- list(subject_level_dataset_name = TRUE)
    OK[["subject_level_dataset_name"]] <- CM$check_dataset_name("subject_level_dataset_name", subject_level_dataset_name,
        flags, datasets, used_dataset_names, err)
    flags <- structure(list(), names = character(0))
    OK[["results_dataset_name"]] <- CM$check_dataset_name("results_dataset_name", results_dataset_name,
        flags, datasets, used_dataset_names, err)
    subkind <- list(kind = "or", options = list(list(kind = "character"), list(kind = "factor")))
    flags <- list(subjid_var = TRUE)
    OK[["subjid_var"]] <- OK[["subject_level_dataset_name"]] && CM$check_dataset_colum_name("subjid_var",
        subjid_var, subkind, flags, subject_level_dataset_name, datasets[[subject_level_dataset_name]],
        err)
    subkind <- list(kind = "or", options = list(list(kind = "numeric", min = NA, max = NA), list(kind = "character"),
        list(kind = "factor")))
    flags <- list(one_or_more = TRUE)
    OK[["x_vars"]] <- OK[["results_dataset_name"]] && CM$check_dataset_colum_name("x_vars", x_vars, subkind,
        flags, results_dataset_name, datasets[[results_dataset_name]], err)
    subkind <- list(kind = "numeric", min = NA, max = NA)
    flags <- list(one_or_more = TRUE)
    OK[["y_vars"]] <- OK[["results_dataset_name"]] && CM$check_dataset_colum_name("y_vars", y_vars, subkind,
        flags, results_dataset_name, datasets[[results_dataset_name]], err)
    subkind <- list(kind = "anything")
    flags <- list(one_or_more = TRUE, optional = TRUE)
    OK[["color_vars"]] <- OK[["subject_level_dataset_name"]] && CM$check_dataset_colum_name("color_vars",
        color_vars, subkind, flags, subject_level_dataset_name, datasets[[subject_level_dataset_name]],
        err)
    flags <- list(one_or_more = TRUE, optional = TRUE, named = TRUE)
    OK[["color_palette"]] <- CM$check_type("color_palette", color_palette, "character", flags, err)
    flags <- list(one_or_more = TRUE, optional = TRUE, named = TRUE)
    OK[["tooltip"]] <- CM$check_type("tooltip", tooltip, "character", flags, err)
    subkind <- list(kind = "anything")
    flags <- list(one_or_more = TRUE, optional = TRUE)
    OK[["facet_rows"]] <- OK[["subject_level_dataset_name"]] && CM$check_dataset_colum_name("facet_rows",
        facet_rows, subkind, flags, subject_level_dataset_name, datasets[[subject_level_dataset_name]],
        err)
    subkind <- list(kind = "anything")
    flags <- list(one_or_more = TRUE, optional = TRUE)
    OK[["facet_cols"]] <- OK[["subject_level_dataset_name"]] && CM$check_dataset_colum_name("facet_cols",
        facet_cols, subkind, flags, subject_level_dataset_name, datasets[[subject_level_dataset_name]],
        err)
    "NOTE: height_default (numeric) tagged as \"manual_check\""
    "      The expectation is that it either does not require automated checks or that"
    "      the caller of this function has written manual checks near the call site."
    "NOTE: height_range (numeric) tagged as \"manual_check\""
    "      The expectation is that it either does not require automated checks or that"
    "      the caller of this function has written manual checks near the call site."
    flags <- list(optional = TRUE)
    OK[["title"]] <- CM$check_type("title", title, "character", flags, err)
    flags <- list(optional = TRUE)
    OK[["subtitle"]] <- CM$check_type("subtitle", subtitle, "character", flags, err)
    flags <- list(optional = TRUE)
    OK[["filter_var"]] <- CM$check_type("filter_var", filter_var, "character", flags, err)
    flags <- list(one_or_more = TRUE, optional = TRUE)
    OK[["filter_values"]] <- CM$check_type("filter_values", filter_values, "character", flags, err)
    flags <- list(one_or_more = TRUE, optional = TRUE)
    OK[["filter_default_vals"]] <- CM$check_type("filter_default_vals", filter_default_vals, "character",
        flags, err)
    flags <- list(optional = TRUE)
    OK[["receiver_id"]] <- CM$check_type("receiver_id", receiver_id, "character", flags, err)
    for (ds_name in names(used_dataset_names)) {
        OK[["subjid_var"]] <- OK[["subjid_var"]] && CM$check_subjid_col(datasets, ds_name, get(ds_name),
            "subjid_var", subjid_var, err)
    }
    return(OK)
}

})
# styler: on
