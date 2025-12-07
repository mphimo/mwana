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
    stop("MUAC values must be in millimeters. Try again!")
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
#' The quality of the data is first evaluated by calculating and rating the
#' standard deviation (SD) of MFAZ (in `mw_estimate_prevalence_screening()`)
#' or SD of the raw MUAC values (in `mw_estimate_prevalence_screening2()`),
#' and the p-value of the age ratio test in either functions. 
#' Thereafter, if the latter test is problematic, age-weighting approach is 
#' applied to the prevalence estimation, to account for the over-representation 
#' of younger children in the sample; otherwise, a non-age-weighted prevalence
#' is estimated. This means that even if the SD in either functions is 
#' problematic, the prevalence is estimated, with no adjustments, and returned.
#' 
#' @details
#' A typical user analysis workflow is expected to begin with data quality checks,
#' followed by a thorough review, and only thereafter proceed to prevalence 
#' estimation. This sequence places the user in the strongest position to assess
#' whether the resulting prevalence estimates are reliable.
#'
#' In `mw_estimate_prevalence_screening()`, outliers are identified using SMART 
#' flagging criteria applied to MFAZ, whereas `mw_estimate_prevalence_screening2()`
#' are based on the raw MUAC values. In either functions, outliers are excluded 
#' from the prevalence estimation.
#'
#' @param df A `tibble` object produced by [mw_wrangle_muac()] and
#' [mw_wrangle_age()] functions. Note that MUAC values in `df`
#' must be in millimeters unit after using [mw_wrangle_muac()]. Also, `df`
#' must have a variable called `cluster` wherein the primary sampling unit 
#' identifiers are stored.
#'
#' @param age_cat A `character` vector of child's age in categories. Code values
#' should be "6-23" and "24-59".
#'
#' @param muac A `numeric` or `integer` vector of raw MUAC values. The
#' measurement unit should be millimeters.
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
#'   oedema = oedema,
#'   province
#' )
#'
#' ## With `oedema` set to `NULL` ----
#' mw_estimate_prevalence_screening(
#'   df = anthro.02,
#'   muac = muac,
#'   oedema = NULL,
#'   province
#' )
#'
#' ## Specifying the grouping variables ----
#' mw_estimate_prevalence_screening(
#'   df = anthro.02,
#'   muac = muac,
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
                                             oedema = NULL,
                                             ...) {
  ## Difuse argument `.by` ----
  .by <- rlang::enquos(...)

  ## Empty vector type list to store results ----
  results <- list()

  ## Apply groupings if needed ----
  if (length(.by) > 0) df <- dplyr::group_by(df, !!!.by)

  ## Determine the analysis path that fits the data ----
  path <- dplyr::summarise(
    .data = df,
    age_ratio = rate_agesex_ratio(
      mw_stattest_ageratio(.data$age, .expectedP = 0.66)$p
    ),
    std = rate_std(
      stats::sd(
        remove_flags(as.numeric(.data$mfaz), "zscores"),
        na.rm = TRUE
      )
    ),
    analysis_approach = set_analysis_path(.data$age_ratio, .data$std),
    .groups = "drop"
  )

  ## Iterate over a data frame and compute estimates as per analysis path ----
  for (i in seq_len(nrow(path))) {
    if (length(.by) > 0) {
      vals <- purrr::map(.by, ~ dplyr::pull(path, !!.x)[i])
      exprs <- purrr::map2(.by, vals, ~ rlang::expr(!!rlang::get_expr(.x) == !!.y))
      data_subset <- dplyr::filter(df, !!!exprs)
    } else {
      data_subset <- df
    }

    analysis_approach <- path$analysis_approach[i]
    if (analysis_approach %in% c("unweighted", "missing")) {
      if (length(.by) > 0) {
        output <- get_estimates(
          df = data_subset,
          muac = {{ muac }},
          oedema = {{ oedema }},
          raw_muac = FALSE,
          !!!.by
        )
      } else {
        output <- get_estimates(
          df = data_subset,
          muac = {{ muac }},
          oedema = {{ oedema }},
          raw_muac = FALSE
        )
      }
    } else {
      if (length(.by) > 0) {
        output <- mw_estimate_age_weighted_prev_muac(
          data_subset,
          muac = .data$muac,
          has_age = TRUE,
          age = .data$age,
          oedema = {{ oedema }},
          raw_muac = FALSE,
          !!!.by
        ) |>  
          dplyr::select(!!!.by, sam_p = .data$sam, mam_p = .data$mam, gam_p = .data$gam)
      } else {
        output <- mw_estimate_age_weighted_prev_muac(
          data_subset,
          muac = .data$muac,
          has_age = TRUE,
          age = .data$age,
          oedema = {{ oedema }}, 
          raw_muac = FALSE
        ) |> 
          dplyr::select(sam_p = .data$sam, mam_p = .data$mam, gam_p = .data$gam)
      }
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
  path <- df |>
    dplyr::summarise(
      age_ratio = rate_agesex_ratio(
        mw_stattest_ageratio2(
          {{ age_cat }}, 0.66
        )$p
      ),
      std = rate_std(
        stats::sd(
          remove_flags(
            as.numeric(.data$muac),
            .from = "raw_muac"
          ),
          na.rm = TRUE
        ),
        .of = "raw_muac"
      ),
      analysis_approach = set_analysis_path(
        ageratio_class = .data$age_ratio,
        sd_class = .data$std
      ),
      .groups = "drop"
    )

  ## Loop over groups ----
  for (i in seq_len(nrow(path))) {
    if (length(.by) > 0) {
      vals <- purrr::map(.by, ~ dplyr::pull(path, !!.x)[i])
      exprs <- purrr::map2(.by, vals, ~ rlang::expr(!!rlang::get_expr(.x) == !!.y))
      data_subset <- dplyr::filter(df, !!!exprs)
    } else {
      data_subset <- df
    }

    analysis_approach <- path$analysis_approach[i]

    if (analysis_approach %in% c("unweighted", "missing")) {
      if (length(.by) > 0) {
        r <- get_estimates(
          df = data_subset,
          muac = {{ muac }},
          oedema = {{ oedema }},
          raw_muac = TRUE,
          !!!.by
        )
      } else {
        r <- get_estimates(
          df = data_subset,
          muac = {{ muac }},
          oedema = {{ oedema }},
          raw_muac = TRUE
        )
      }
    } else {
      if (length(.by) > 0) {
        r <- mw_estimate_age_weighted_prev_muac(
          data_subset,
          muac = .data$muac,
          has_age = FALSE,
          oedema = {{ oedema }},
          raw_muac = TRUE,
          !!!.by
        )|>  
          dplyr::select(!!!.by, sam_p = .data$sam, mam_p = .data$mam, gam_p = .data$gam)
      } else {
        r <- mw_estimate_age_weighted_prev_muac(
          df = data_subset,
          has_age = FALSE,
          oedema = {{ oedema }},
          raw_muac = TRUE
        )|>  
          dplyr::select(sam_p = .data$sam, mam_p = .data$mam, gam_p = .data$gam)
      }
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
