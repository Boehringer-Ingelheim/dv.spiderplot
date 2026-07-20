adsl <- data.frame(
  USUBJID = c("001", "002", "003", "004"),
  ARM = factor(c("A", "B", "C", "A")),
  AGE = c(20, 30, 40, 50)
)

# Ensure random numbers are consistent between test runs
set.seed(42)

adtr = rbind(
  data.frame(
    USUBJID = "001",
    ADY = c(1, 7, 14, 21),
    PCHG = c(0, runif(n = 3, min = -50, max = 50))
  ),
  data.frame(
    USUBJID = "002",
    ADY = c(1, 7),
    PCHG = c(0, runif(n = 1, min = -50, max = 50))
  ),
  data.frame(
    USUBJID = "003",
    ADY = c(1, 7, 14, 21),
    PCHG = c(0, runif(n = 3, min = -50, max = 50))
  ),
  data.frame(
    USUBJID = "004",
    ADY = c(1, 7, 14),
    PCHG = c(0, runif(n = 2, min = -50, max = 50))
  )
)

test_that(vdoc[["add_spec"]](
  "spiderplot filters on values of a specified variable",
  specs$spiderplot_local_filter
), {

  shiny::testServer(
    dv.spiderplot::spiderplot_server,
    args = list(
      id = "test_mod",
      datasets = shiny::reactive(list(subject_level = adsl, results = adtr)),
      subjid_var = "USUBJID",
      x_vars = c("ADY"),
      y_vars = c("PCHG"),
      filter_var = "ARM"
    ), {
      # Filter on arms A and B (dropping arm C)
      session$setInputs(!!POC$FILTER_ID := c("A", "B"))
      actual <- dataset_filtered()

      expected <- adtr |>
        dplyr::left_join(adsl, by = "USUBJID") |>
        dplyr::filter(.data[["ARM"]] %in% c("A", "B")) |>
        dplyr::select(-"AGE")

      expect_equal(actual, expected, ignore_attr = "row.names")
    }
  )

})
