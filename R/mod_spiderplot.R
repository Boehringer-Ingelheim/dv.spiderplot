POC <- pack_of_constants( # nolint
  PLOT_OPTIONS_ID = "plot_options",
  PLOT_OPTIONS_LABEL = "Plot Options",
  X_VAR_ID = "x_var",
  X_VAR_LABEL = "X Variable",
  Y_VAR_ID = "y_var",
  Y_VAR_LABEL = "Y Variable",
  COLOR_VAR_ID = "color_var",
  COLOR_VAR_LABEL = "Color Variable",
  FACET_ROWS_ID = "facet_rows",
  FACET_ROWS_LABEL = "Facet Rows",
  FACET_COLS_ID = "facet_cols",
  FACET_COLS_LABEL = "Facet Columns",
  HLINES_ID = "hlines",
  HLINES_LABEL = "Horizontal Lines",
  VLINES_ID = "vlines",
  VLINES_LABEL = "Vertical Lines",
  HEIGHT_ID = "height",
  HEIGHT_LABEL = "Height",
  OUT_PLOT_ID = "girafe",
  SUBJ_ID = "girafe_selected",
  WIDTH_SVG = 10,
  HEIGHT_SVG = 5
)


#' @title Spider Plot Module UI
#'
#' @param id `[character(1)]`. 
#' Unique identifier for the module UI.
#' @param show_color_vars `[logical(1)]`. 
#' Whether to show the color variable selection.
#' @param show_facet_rows `[logical(1)]`. 
#' Whether to show the facet rows selection.
#' @param show_facet_cols `[logical(1)]`. 
#' Whether to show the facet columns selection.
#' 
#' @export
spiderplot_UI <- function( # nolint
  id,
  show_color_vars,
  show_facet_rows,
  show_facet_cols
) {
  ns <- shiny::NS(namespace = id)

  drop_menu <- shinyWidgets::dropMenu(
    tag = shiny::actionButton(
      inputId = ns(POC$PLOT_OPTIONS_ID), 
      label = POC$PLOT_OPTIONS_LABEL,
      icon = shiny::icon("gear")
    ),
    shiny::selectizeInput(
      inputId = ns(POC$X_VAR_ID),
      label = POC$X_VAR_LABEL,
      choices = NULL,
      multiple = FALSE
    ),
    shiny::selectizeInput(
      inputId = ns(POC$Y_VAR_ID),
      label = POC$Y_VAR_LABEL,
      choices = NULL,
      multiple = FALSE
    ),
    if (show_color_vars) {
      shiny::selectizeInput(
        inputId = ns(POC$COLOR_VAR_ID),
        label = POC$COLOR_VAR_LABEL,
        choices = NULL,
        selected = "None",
        multiple = FALSE,
        options = list(
          placeholder = "Select color variable",
          allowEmptyOption = TRUE,
          showEmptyOptionInDropdown = TRUE,
          emptyOptionLabel = "None"
        )
      )
    },
    if (show_facet_rows) {
      shiny::selectizeInput(
        inputId = ns(POC$FACET_ROWS_ID), 
        label = POC$FACET_ROWS_LABEL,
        choices = NULL,
        multiple = TRUE,
        options = list(placeholder = "Select facet rows")
      )
    },
    if (show_facet_cols) {
      shiny::selectizeInput(
        inputId = ns(POC$FACET_COLS_ID), 
        label = POC$FACET_COLS_LABEL,
        choices = NULL,
        multiple = TRUE,
        options = list(placeholder = "Select facet columns")
      )
    },
    shiny::textInput(
      inputId = ns(POC$HLINES_ID),
      label = POC$HLINES_LABEL,
      placeholder = "e.g. -10, 10 (seperated by comma or space)", 
    ),
    shiny::textInput(
      inputId = ns(POC$VLINES_ID),
      label = POC$VLINES_LABEL,
      placeholder = "e.g. 0, 10 (seperated by comma or space)",
    ),
    shiny::sliderInput(
      inputId = ns(POC$HEIGHT_ID),
      label = POC$HEIGHT_LABEL,
      min = 1,
      max = POC$HEIGHT_SVG * 2,
      value = POC$HEIGHT_SVG,
      step = 0.5
    )
  )

  shiny::tagList(
    drop_menu,
    ggiraph::girafeOutput(
      outputId = ns(POC$OUT_PLOT_ID),
      width = "100%",
      height = NULL
    )
  )
}


#' @title Spider Plot Module Server
#'
#' @param id `[character(1)]`. 
#' Unique identifier for the module server. 
#' @param datasets `[list(2)]`. 
#' A list containing subject level and analysis results datasets.
#' @param switch_func `[function | NULL]`. 
#' Function to switch to a different module when a patient is selected.
#' @inheritParams mod_spiderplot
#' 
#' @importFrom dplyr .data
#' 
#' @export
spiderplot_server <- function(
  id, 
  datasets,
  subjid_var,
  x_vars,
  y_vars,
  color_vars,
  color_palette = NULL,
  tooltip = NULL,
  facet_rows = NULL,
  facet_cols = NULL,  
  title = NULL,
  subtitle = NULL,
  switch_func = NULL,
  receiver_id = NULL
) {
  module <- function(input, output, session) {
    dataset_validated <- shiny::reactive({
      subject_level_dataset <- datasets()[["subject_level"]]
      results_dataset <- datasets()[["results"]]
      if (is.null(results_dataset) || nrow(results_dataset) == 0) {
        return(NULL)
      }

      vars <- c(color_vars, facet_rows, facet_cols)
      vars_to_add <- vars[!vars %in% names(results_dataset)]

      if (length(vars_to_add) > 0) {
        cols_to_join <- c(subjid_var, vars_to_add)
        results_dataset <- dplyr::left_join(
          x = results_dataset,
          y = subject_level_dataset[, cols_to_join, drop = FALSE],
          by = subjid_var
        )
      }

      col_names <- colnames(results_dataset)
      
      checkmate::assert_subset(subjid_var, choices = col_names)
      checkmate::assert_subset(x_vars, choices = col_names)
      checkmate::assert_subset(y_vars, choices = col_names)
      if (!is.null(color_vars)) {
        checkmate::assert_subset(color_vars, choices = col_names)
      }
      if (!is.null(facet_rows)) {
        checkmate::assert_subset(facet_rows, choices = col_names)
      }
      if (!is.null(facet_cols)) {
        checkmate::assert_subset(facet_cols, choices = col_names)
      }     

      return(results_dataset)
    })
    
    output[[POC$OUT_PLOT_ID]] <- ggiraph::renderGirafe({
      results_dataset <- dataset_validated() 
      if (input[[POC$X_VAR_ID]] == "" || input[[POC$Y_VAR_ID]] == "") {
        return(NULL)
      }
      data <- dplyr::filter(results_dataset, !is.na(.data[[input[[POC$Y_VAR_ID]]]]))
      hlines <- strsplit(input[[POC$HLINES_ID]], split = "[, ]+")[[1]]
      vlines <- strsplit(input[[POC$VLINES_ID]], split = "[, ]+")[[1]]

      if (!is.null(tooltip)) {
        if (!is.character(tooltip) || is.null(names(tooltip)) || length(tooltip) == 0) {
          stop("tooltip must be a named character vector specifying label-column pairs")
        }
        
        tooltip_vec <- character(nrow(data))
        for (i in seq_along(tooltip)) {
          label <- names(tooltip)[i]
          var_name <- tooltip[i]          
          if (!var_name %in% colnames(data)) {
            warning(paste("Column", var_name, "not found in data. Skipping tooltip entry:", label))
            next
          }          
          if (i == 1) {
            tooltip_vec <- paste0("<b>", label, "</b> ", data[[var_name]])
          } else {
            tooltip_vec <- paste0(tooltip_vec, "<br><b>", label, "</b> ", data[[var_name]])
          }
        }        
        tooltip_var <- "spiderplot_tooltip"
        data[[tooltip_var]] <- tooltip_vec
      } else {
        tooltip_var <- subjid_var
      }

      spiderplot(
        data = data,
        x_var = input[[POC$X_VAR_ID]],
        y_var = input[[POC$Y_VAR_ID]],
        group_var = subjid_var,
        color_var = input[[POC$COLOR_VAR_ID]],
        color_palette = color_palette,
        tooltip = tooltip_var,
        facet_rows = input[[POC$FACET_ROWS_ID]],
        facet_cols = input[[POC$FACET_COLS_ID]],
        hlines = as.numeric(hlines),
        vlines = as.numeric(vlines),
        title = title,
        subtitle = subtitle,
        width_svg = POC$WIDTH_SVG,
        height_svg = input[[POC$HEIGHT_ID]]
      )
    })

    # Switch to the receiver module when a subject is selected
    shiny::observeEvent(input[[POC$SUBJ_ID]], {
      switch_func(selected = receiver_id)
    })

    shiny::onBookmark(function(state) {
      state$values$x_var <- input[[POC$X_VAR_ID]]
      state$values$y_var <- input[[POC$Y_VAR_ID]]
      state$values$color_var <- input[[POC$COLOR_VAR_ID]]
      state$values$facet_rows <- input[[POC$FACET_ROWS_ID]]
      state$values$facet_cols <- input[[POC$FACET_COLS_ID]]
    })
    
    shiny::onRestore(function(state) {
      session$userData$is_restoring <- TRUE
      session$userData$restored_values <- state$values
      shiny::invalidateLater(100)
    })
    
    update_variable <- function(input_id, base_choices, restored_var, is_multi = FALSE) {
      choices <- base_choices
      
      if (!is.null(restored_var)) {
        vars_to_add <- if (is_multi) restored_var else restored_var
        for (var in vars_to_add) {
          if (!var %in% choices && var %in% vars) {
            var_name <- names(vars)[vars == var][1]
            choices <- c(choices, setNames(var, var_name))
          }
        }
      }
      
      is_restored_valid <- !is.null(restored_var) && 
        if (is_multi) all(restored_var %in% choices) else restored_var %in% choices
      
      selected <- if (is_restored_valid) restored_var else choices[1]
      
      shiny::updateSelectizeInput(
        session = session,
        inputId = input_id,
        choices = choices,
        selected = selected
      )
    }

    shiny::observe({
      results_dataset <- dataset_validated()
      if (is.null(results_dataset)) {
        return(NULL)
      }
      vars <- colnames(results_dataset)
      labels <- sapply(results_dataset, FUN = attr, "label")
      names(vars) <- paste0(vars, " [", labels, "]")
      
      if (isTRUE(session$userData$is_restoring)) {
        restored <- session$userData$restored_values
        
        update_variable(
          input_id = POC$X_VAR_ID, 
          base_choices = vars[match(x_vars, vars)], 
          restored_var = restored$x_var
        )
        update_variable(
          input_id = POC$Y_VAR_ID, 
          base_choices = vars[match(y_vars, vars)], 
          restored_var = restored$y_var
        )
        if (!is.null(color_vars)) {
          update_variable(
            input_id = POC$COLOR_VAR_ID, 
            base_choices = vars[match(color_vars, vars)], 
            restored_var = restored$color_var
          )
        }        
        if (!is.null(facet_rows)) {
          update_variable(
            input_id = POC$FACET_ROWS_ID, 
            base_choices = vars[match(facet_rows, vars)], 
            restored_var = restored$facet_rows, 
            is_multi = TRUE)
        }
        if (!is.null(facet_cols)) {
          update_variable(
            input_id = POC$FACET_COLS_ID, 
            base_choices = vars[match(facet_cols, vars)], 
            restored_var = restored$facet_cols, 
            is_multi = TRUE
          )
        }
        
        session$userData$is_restoring <- FALSE
        
      } else {
        x_choices <- vars[match(x_vars, vars)]
        shiny::updateSelectizeInput(
          session = session,
          inputId = POC$X_VAR_ID,
          choices = x_choices
        )

        y_choices <- vars[match(y_vars, vars)]
        shiny::updateSelectizeInput(
          session = session,
          inputId = POC$Y_VAR_ID,
          choices = y_choices
        )

        if (!is.null(color_vars)) {
          color_vars_choices <- vars[match(color_vars, vars)]
          shiny::updateSelectizeInput(
            session = session,
            inputId = POC$COLOR_VAR_ID,
            choices = color_vars_choices,
            selected = color_vars_choices[1]
          )
        }
        
        if (!is.null(facet_rows)) {
          facet_rows_choices <- vars[match(facet_rows, vars)]
          shiny::updateSelectizeInput(
            session = session,
            inputId = POC$FACET_ROWS_ID,
            choices = facet_rows_choices,
            selected = facet_rows_choices[1]
          )
        }
        
        if (!is.null(facet_cols)) {
          facet_cols_choices <- vars[match(facet_cols, vars)]
          shiny::updateSelectizeInput(
            session = session,
            inputId = POC$FACET_COLS_ID,
            choices = facet_cols_choices,
            selected = facet_cols_choices[1]
          )
        }
      }
    })

    list(subj_id = shiny::reactive(input[[POC$SUBJ_ID]]))
  }
  
  shiny::moduleServer(id = id, module = module)
}


#' @title Spider Plot Module
#' 
#' @description Creates an interactive spider plot module for visualizing 
#' individual patient trajectories over time in clinical trials. 
#'
#' @param module_id `[character(1)]`. 
#' Unique identifier for the module. 
#' @param subject_level_dataset_name `[character(1)]`. 
#' Name of the dataset containing the subject level information (e.g., "adsl").
#' @param results_dataset_name `[character(1)]`. 
#' Name of the dataset containing the analysis results (e.g., "adtr").
#' @param subjid_var `[character(1)]`. 
#' Variable name for subject identifier. (e.g., "USUBJID"). 
#' @param x_vars `[character(1+)]`. 
#' A character vector of variable names for the x-axis. Each element must be a 
#' valid column name in the results dataset. Supported types are numeric 
#' (e.g. "ADY") and character/factor (e.g. "AVISIT"). When multiple variables are 
#' supplied (e.g., c("ADY", "AVISIT")), the first element is used as default in the plot.
#' @param y_vars `[character(1+)]`. 
#' A character vector of variable names for the y-axis. Each element must be a 
#' valid column name in the results dataset. Supported types are numeric 
#' (e.g. "PCHG", "CHG"). At least one valid variable is required.
#' @param color_vars `[character(1+) | NULL]`. 
#' Variable name(s) for color grouping (e.g., treatment arm).
#' @param color_palette `[named character(1+) | NULL]`. 
#' Custom color palette mapping factor levels to (hex) colors.
#' @param tooltip `[named character vector | NULL]`. 
#' Named character vector specifying tooltip content. Names are labels, values are column names.
#' If NULL, defaults to using the subject ID variable for tooltips.
#' @param facet_rows `[character(1+) | NULL]`. 
#' Variable names for row faceting. (Splitting plot into subplots by rows)
#' @param facet_cols `[character(1+) | NULL]`. 
#' Variable names for column faceting. (Splitting plot into subplots by columns)
#' @param title `[character(1) | NULL]`. 
#' Main plot title.
#' @param subtitle `[character(1) | NULL]`. 
#' Plot subtitle for additional context.
#' @param receiver_id `[character(1) | NULL]`. 
#' Module ID that will receive patient selection events from this module.
#' 
#' @export
mod_spiderplot <- function(
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
  title = NULL,
  subtitle = NULL,
  receiver_id = NULL
) {
  checkmate::assert_string(module_id, min.chars = 1)
  checkmate::assert_string(subject_level_dataset_name, min.chars = 1)
  checkmate::assert_string(results_dataset_name, min.chars = 1)
  checkmate::assert_string(subjid_var, min.chars = 1)
  checkmate::assert_character(x_vars, min.len = 1, min.chars = 1)
  checkmate::assert_character(y_vars, min.len = 1, min.chars = 1)
  checkmate::assert_character(color_vars, min.len = 1, min.chars = 1, null.ok = TRUE)
  checkmate::assert_character(color_palette, names = "named", min.chars = 1, null.ok = TRUE)
  checkmate::assert_character(tooltip, min.len = 1, min.chars = 1, names = "named", null.ok = TRUE)
  checkmate::assert_character(facet_rows, min.len = 1, min.chars = 1, null.ok = TRUE)
  checkmate::assert_character(facet_cols, min.len = 1, min.chars = 1, null.ok = TRUE)
  checkmate::assert_string(title, min.chars = 1, null.ok = TRUE)
  checkmate::assert_string(subtitle, min.chars = 1, null.ok = TRUE)
  checkmate::assert_string(receiver_id, min.chars = 1, null.ok = TRUE)
  
  ui <- function(id) {
    spiderplot_UI(
      id = id,
      show_color_vars = !is.null(color_vars),
      show_facet_rows = !is.null(facet_rows),
      show_facet_cols = !is.null(facet_cols)
    )
  }

  server <- function(afmm) {
    spiderplot_server(
      id = module_id,
      datasets = shiny::reactive({
        filtered_datasets <- afmm[["filtered_dataset"]]()
        checkmate::assert_subset(
          c(subject_level_dataset_name, results_dataset_name), 
          choices = names(filtered_datasets)
        )
        list(
          subject_level = filtered_datasets[[subject_level_dataset_name]],
          results = filtered_datasets[[results_dataset_name]]
        )
      }),
      subjid_var = subjid_var,
      x_vars = x_vars,
      y_vars = y_vars,
      color_vars = color_vars,
      color_palette = color_palette,
      tooltip = tooltip,
      facet_rows = facet_rows,
      facet_cols = facet_cols,
      title = title,
      subtitle = subtitle,
      switch_func = afmm[["utils"]][["switch2mod"]],
      receiver_id = receiver_id
    )
  }

  dataset_names <- c(subject_level_dataset_name, results_dataset_name)
  meta <- list(dataset_info = list(all = dataset_names))
  
  list(ui = ui, server = server, module_id = module_id, meta = meta)
}
