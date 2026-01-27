#'
#'
#' @keywords internal
#'
#'
get_estimates <- function(df, muac, oedema = NULL, raw_muac = FALSE, ...) {
  ## Difuse arguments ----
  by <- rlang::enquos(...)
  muac <- rlang::eval_tidy(enquo(muac), df)
  oedema <- rlang::eval_tidy(enquo(oedema), df)


  ## Enforce class of `muac` ----
  if (!is.numeric(muac)) {
    stop(
      "`muac` should be of class numeric not ",
      class(muac), ". Try again!"
    )
  }

  ### Enforce measuring unit is in "mm" ----
  if (any(grepl("\\.", df$muac))) {
    stop("MUAC values must be in millimetres. Try again!")
  }

  ## Wasting definition including `oedema` ----
  if (!is.null(oedema)) {
    ### Enforce class of `oedema` ----
    if (!is.character(oedema)) {
      stop(
        "`oedema` should be of class character not ", class(oedema),
        ". Try again!"
      )
    }
    ### Enforce code values in `oedema` ----
    if (!all(levels(as.factor(oedema)) %in% c("y", "n"))) {
      stop('Code values in `oedema` must only be "y" and "n". Try again!')
    }
    ## Wasting definition including `oedema` ----
    x <- with(
      df,
      define_wasting(
        df,
        muac = muac,
        oedema = oedema,
        .by = "muac"
      )
    )
  } else {
    ## Wasting definition without `oedema` ----
    x <- with(
      df,
      define_wasting(
        df,
        muac = muac,
        .by = "muac"
      )
    )
  }

  ## Filter out flags ----
  flag <- if (raw_muac) "flag_muac" else "flag_mfaz"
  x <- dplyr::filter(x, .data[[flag]] == 0)

  ## Summarize results ----
  p <- dplyr::group_by(.data = x, !!!by) |>
    dplyr::summarise(
      dplyr::across(
        .data$gam:.data$mam,
        list(
          n = \(.) sum(., na.rm = TRUE),
          p = \(.) mean(., na.rm = TRUE)
        )
      ),
      N = n()
    )
  ## Return p ----
  p
}


#'
#' Estimate the prevalence of wasting based on MUAC for non-survey data
#'
#' @description
#' It is common to estimate prevalence of wasting from non-survey data, such
#' as screenings or any other data derived from community-based surveillance
#' systems. In such situations, the analysis usually consists only in estimating
#' the point prevalence and the counts of positive cases, without necessarily
#' estimating the uncertainty. This function serves this purpose.
#'
#' It first evaluates the quality of the data to determine the appropriate
#' prevalence-analysis flow to be employed. Quality is evaluated by estimating
#' the observed proportion of children aged 24-59 months of the total children in
#' the dataset, then it estimates the p-value for the difference between the
#' above-mentioned category against the expected (0.66) and rates it.
#'
#' If age ratio test is "problematic" and the proportion of children aged 24-59
#' months is < 0.66, age-weighting approach is applied to prevalence estimation,
#' to account for the over-representation of younger children in the sample;
#' otherwise, a non-age-weighted prevalence is estimated.
#'
#' @details
#' A typical user analysis workflow is expected to begin with data quality checks,
#' followed by a thorough review, and only thereafter proceed to prevalence
#' estimation. This sequence places the user in the strongest position to assess
#' whether the resulting prevalence estimates are reliable.
#'
#' In `mw_estimate_prevalence_screening()`, outliers are identified using SMART
#' flagging criteria applied to MFAZ, whereas in `mw_estimate_prevalence_screening2()`
#' are based on the raw MUAC values. In either functions, outliers are excluded
#' from the prevalence estimation.
#'
#' @param df A `tibble` object produced by [mw_wrangle_muac()] and
#' [mw_wrangle_age()] functions. Note that MUAC values in `df`
#' must be in millimetres unit after using [mw_wrangle_muac()]. Also, `df`
#' must have a variable called `cluster` wherein the primary sampling unit
#' identifiers are stored.
#'
#' @param age A vector of class `double` of child's age in months.
#'
#' @param age_cat A `character` vector of child's age in categories. Code values
#' should be "6-23" and "24-59".
#'
#' @param muac A `numeric` or `integer` vector of raw MUAC values. The
#' measurement unit should be millimetres.
#'
#' @param oedema A `character` vector for presence of nutritional oedema. Code
#' values should be "y" for presence and "n" for absence. Default is NULL.
#'
#' @param ... A vector of class `character`, specifying the categories for which
#' the analysis should be summarised for. Usually geographical areas. More than
#' one vector can be specified.
#'
#' @returns A summary `tibble` for the descriptive statistics about wasting based
#' on MUAC, with no confidence intervals.
#'
#' @references
#' SMART Initiative (no date). *Updated MUAC data collection tool*. Available at:
#' <https://smartmethodology.org/survey-planning-tools/updated-muac-tool/>
#'
#' @seealso [mw_estimate_prevalence_muac()], [mw_estimate_age_weighted_prev_muac()],
#' [flag_outliers()] and [remove_flags()].
#'
#'
#' @examples
#' mw_estimate_prevalence_screening(
#'   df = anthro.02,
#'   muac = muac,
#'   age = age,
#'   oedema = oedema,
#'   province
#' )
#'
#' ## With `oedema` set to `NULL` ----
#' mw_estimate_prevalence_screening(
#'   df = anthro.02,
#'   muac = muac,
#'   age = age,
#'   oedema = NULL,
#'   province
#' )
#'
#' ## Specifying the grouping variables ----
#' mw_estimate_prevalence_screening(
#'   df = anthro.02,
#'   muac = muac,
#'   age = age,
#'   oedema = NULL,
#'   province
#' )
#'
#' @rdname muac-screening
#'
#' @export
#'
mw_estimate_prevalence_screening <- function(df,
                                             muac,
                                             age,
                                             oedema = NULL,
                                             ...) {
  ## Difuse argument `.by` ----
  .by <- rlang::enquos(...)

  ## Empty vector type list to store results ----
  results <- list()

  ## Apply groupings if needed ----
  if (length(.by) > 0) df <- dplyr::group_by(df, !!!.by)

  ## Determine the analysis path that fits the data ----
  x <- dplyr::summarise(
    .data = df,
    age_ratio_prop = mw_stattest_ageratio({{ age }}, .expectedP = 0.66)$observedP,
    age_ratio_pval = rate_agesex_ratio(
      mw_stattest_ageratio({{ age }}, .expectedP = 0.66)$p
    ),
    .groups = "drop"
  )

  ## Iterate over a data frame and compute estimates as per analysis path ----
  for (i in seq_len(nrow(x))) {
    vals <- purrr::map(.by, ~ dplyr::pull(x, !!.x)[i])
    exprs <- purrr::map2(.by, vals, ~ rlang::expr(!!rlang::get_expr(.x) == !!.y))
    data_subset <- dplyr::filter(df, !!!exprs)

    if (x$age_ratio_pval[i] == "Problematic" && x$age_ratio_prop[i] < 0.66) {
      output <- mw_estimate_age_weighted_prev_muac(
        data_subset,
        muac = {{ muac }},
        has_age = TRUE,
        age = {{ age }},
        oedema = {{ oedema }},
        raw_muac = FALSE,
        !!!.by
      ) |>
        dplyr::select(!!!.by, .data$sam_p, .data$mam_p, .data$gam_p)
    } else {
      output <- get_estimates(
        df = data_subset,
        muac = {{ muac }},
        oedema = {{ oedema }},
        raw_muac = FALSE,
        !!!.by
      )
    }

    results[[i]] <- output
  }
  ## Relocate variables ----
  results <- dplyr::bind_rows(results)
  .df <- if (any(names(results) %in% c("gam_n"))) {
    results |>
      dplyr::relocate(.data$gam_p, .after = .data$gam_n) |>
      dplyr::relocate(.data$sam_p, .after = .data$sam_n) |>
      dplyr::relocate(.data$mam_p, .after = .data$mam_n)
  } else {
    results
  }
  .df
}


#'
#'
#'
#' @examples
#'
#' anthro.01 |>
#'   mw_wrangle_muac(
#'     sex = sex,
#'     .recode_sex = TRUE,
#'     muac = muac
#'   ) |>
#'   transform(
#'     age_cat = ifelse(age < 24, "6-23", "24-59")
#'   ) |>
#'   mw_estimate_prevalence_screening2(
#'     age_cat = age_cat,
#'     muac = muac,
#'     oedema = oedema,
#'     area
#'   )
#'
#' @rdname muac-screening
#'
#'
#' @export
#'
#'
mw_estimate_prevalence_screening2 <- function(
    df, age_cat, muac, oedema = NULL, ...) {
  ## Difuse argument `.by` ----
  .by <- rlang::enquos(...)

  ## Empty vector of type list ----
  results <- list()

  ## Apply grouping if needed ----
  if (length(.by) > 0) df <- dplyr::group_by(df, !!!.by)

  ## Determine the analysis path that fits the data ----
  x <- df |>
    dplyr::summarise(
      age_ratio_prop = mw_stattest_ageratio2({{ age_cat }}, 0.66)$observedP,
      age_ratio_pval = rate_agesex_ratio(
        mw_stattest_ageratio2({{ age_cat }}, 0.66)$p
      ),
      .groups = "drop"
    )
  ## Loop over groups ----
  for (i in seq_len(nrow(x))) {
    if (length(.by) > 0) {
      vals <- purrr::map(.by, ~ dplyr::pull(x, !!.x)[i])
      exprs <- purrr::map2(.by, vals, ~ rlang::expr(!!rlang::get_expr(.x) == !!.y))
      data_subset <- dplyr::filter(df, !!!exprs)
    } else {
      data_subset <- df
    }

    if (x$age_ratio_pval[i] == "Problematic" && x$age_ratio_prop[i] < 0.66) {
      r <- mw_estimate_age_weighted_prev_muac(
        data_subset,
        muac = {{ muac }},
        has_age = FALSE,
        age_cat = {{ age_cat }},
        oedema = {{ oedema }},
        raw_muac = TRUE,
        !!!.by
      ) |>
        dplyr::select(!!!.by, .data$sam_p, .data$mam_p, .data$gam_p)
    } else {
      r <- get_estimates(
        df = data_subset,
        muac = {{ muac }},
        oedema = {{ oedema }},
        raw_muac = TRUE,
        !!!.by
      )
    }
    results[[i]] <- r
  }

  ### Relocate variables ----
  results <- dplyr::bind_rows(results)
  .df <- if (any(names(results) %in% c("gam_n"))) {
    results |>
      dplyr::relocate(.data$gam_p, .after = .data$gam_n) |>
      dplyr::relocate(.data$sam_p, .after = .data$sam_n) |>
      dplyr::relocate(.data$mam_p, .after = .data$mam_n)
  } else {
    results
  }
  .df
}
