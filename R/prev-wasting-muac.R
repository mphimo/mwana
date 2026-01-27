#'
#'
#' @keywords internal
#'
#'
set_analysis_path <- function(ageratio_class, sd_class) {
  ## Enforce class of both arguments ----
  ageratio_class <- as.character(ageratio_class)
  sd_class <- as.character(sd_class)

  ## Set the analysis path ----
  dplyr::case_when(
    ageratio_class == "Problematic" & sd_class != "Problematic" ~ "weighted",
    ageratio_class != "Problematic" & sd_class == "Problematic" ~ "missing",
    ageratio_class == "Problematic" & sd_class == "Problematic" ~ "missing",
    .default = "unweighted"
  )
}


#'
#'
#' @keywords internal
#'
#'
complex_survey_estimates_muac <- function(df,
                                          wt = NULL,
                                          oedema = NULL,
                                          ...) {
  ## Difuse arguments ----
  wt <- rlang::enquo(wt)
  oedema <- rlang::enquo(oedema)
  .by <- rlang::enquos(...)

  ## Define acute malnutrition ----
  df <- define_wasting(
    df = df,
    muac = .data$muac,
    oedema = !!oedema,
    .by = "muac"
  )

  ## Filter out flags ----
  df <- dplyr::filter(.data = df, .data$flag_mfaz == 0)

  ## Create a survey object for a weighted analysis ----
  srvy <- srvyr::group_by(df, !!!.by) |>
    srvyr::as_survey_design(
      ids = .data$cluster,
      pps = "brewer",
      variance = "YG",
      weights = !!wt
    )

  #### Summarise prevalence ----
  p <- srvyr::summarise(
    .data = srvy,
    srvyr::across(
      .data$gam:.data$mam,
      list(
        n = \(.) sum(., na.rm = TRUE),
        p = \(.) srvyr::survey_mean(
          .,
          vartype = "ci",
          level = 0.95,
          deff = TRUE,
          na.rm = TRUE
        )
      )
    ),
    wt_pop = sum(srvyr::cur_svy_wts())
  )
  p
}


#'
#' Estimate the prevalence of wasting based on MUAC for survey data
#'
#' @description
#'
#' Estimate the prevalence of wasting based on MUAC and/or nutritional oedema.
#' The function allows users to estimate prevalence in accordance with complex
#' sample design properties, such as accounting for survey sample weights when
#' needed or applicable.
#'
#' It first evaluates the quality of the data to determine the appropriate 
#' prevalence-analysis flow to be employed. Quality is evaluated by estimating 
#' the observed proportion of children aged 24-59 months of the total children in 
#' the dataset, then it estimates the p-value of the difference between the 
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
#' Outliers are identified using SMART flagging criteria applied to MFAZ, and are
#' excluded from the prevalence estimation.
#'
#' @param df A `tibble` object produced by [mw_wrangle_muac()] and
#' [mw_wrangle_age()] functions. Note that MUAC values in `df`
#' must be in millimetres after using [mw_wrangle_muac()]. Also, `df`
#' must have a variable called `cluster` wherein the primary sampling unit
#' identifiers are stored.
#'
#' @param muac A `numeric` or `integer` vector of raw MUAC values. The
#' measurement unit should be millimetres.
#'
#' @param age A vector of class `double` of child's age in months.
#'
#' @param wt A vector of class `double` of the survey sampling weights. Default
#' is NULL, which assumes a self-weighted survey, the case of SMART surveys.
#' Otherwise, a weighted analysis is implemented.
#'
#' @param oedema A `character` vector for presence of nutritional oedema Code
#' values should be "y" for presence and "n" for absence. Default is NULL.
#'
#' @param ... A vector of class `character`, specifying the categories for which
#' the analysis should be summarised for. Usually geographical areas. More than
#' one vector can be specified.
#'
#' @returns A summary `tibble` for the descriptive statistics about wasting based
#' on MUAC, with confidence intervals.
#'
#' @references
#' SMART Initiative (no date). *Updated MUAC data collection tool*. Available at:
#' <https://smartmethodology.org/survey-planning-tools/updated-muac-tool/>
#'
#'
#' @seealso [mw_estimate_age_weighted_prev_muac()] [mw_estimate_prevalence_mfaz()]
#' [mw_estimate_prevalence_screening()]
#'
#' @examples
#' ## Ungrouped analysis ----
#' mw_estimate_prevalence_muac(
#'   df = anthro.04,
#'   muac = muac,
#'   age = age,
#'   wt = NULL,
#'   oedema = oedema
#' )
#'
#' ## Grouped analysis ----
#' mw_estimate_prevalence_muac(
#'   df = anthro.04,
#'   muac = muac,
#'   age = age,
#'   wt = NULL,
#'   oedema = oedema,
#'   province
#' )
#'
#' @export
#'
mw_estimate_prevalence_muac <- function(df,
                                        age,
                                        muac,
                                        wt = NULL,
                                        oedema = NULL,
                                        ...) {
  ## Difuse argument `.by` ----
  .by <- rlang::enquos(...)


  ## Enforce measuring unit is in "mm" ----
  if (any(grepl("\\.", df$muac))) {
    stop("MUAC values must be in millimetres. Please try again.")
  }

  ## Empty vector type list to store results ----
  results <- list()

  if (length(.by) > 0) df <- dplyr::group_by(df, !!!.by)
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
      ### Estimate age-weighted prevalence as per SMART MUAC tool ----
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
      ## Estimate PPS-based prevalence ----
      output <- complex_survey_estimates_muac(
        data_subset, {{ wt }}, {{ oedema }}, !!!.by
      )
    }
    results[[i]] <- output
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
