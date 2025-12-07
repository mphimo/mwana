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
                                          edema = NULL,
                                          ...) {
  ## Difuse arguments ----
  wt <- rlang::enquo(wt)
  edema <- rlang::enquo(edema)
  .by <- rlang::enquos(...)

  ## Define acute malnutrition ----
  df <- define_wasting(
    df = df,
    muac = .data$muac,
    edema = !!edema,
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
#' The quality of the data is first evaluated by calculating and rating the
#' standard deviation (SD) of MFAZ and the p-value of the age ratio test. 
#' Thereafter, if the latter test is problematic, age-weighting approach is 
#' applied to prevalence estimation, to account for the over-representation 
#' of younger children in the sample; otherwise, a non-age-weighted prevalence
#' is estimated. This means that even if the SD of MFAZ is problematic, the 
#' prevalence is estimated, with no adjustments, and returned.
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
#' must be in millimeters after using [mw_wrangle_muac()]. Also, `df`
#' must have a variable called `cluster` wherein the primary sampling unit 
#' identifiers are stored.
#'
#' @param wt A vector of class `double` of the survey sampling weights. Default
#' is NULL, which assumes a self-weighted survey, the case of SMART surveys.
#' Otherwise, a weighted analysis is implemented.
#'
#' @param edema A `character` vector for presence of nutritional oedema Code 
#' values should be "y" for presence and "n" for absence. Default is NULL.
#'
#' @param raw_muac Logical. Whether outliers should be excluded based on the raw
#' MUAC values or MFAZ.
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
#'   wt = NULL,
#'   edema = edema
#' )
#'
#' ## Grouped analysis ----
#' mw_estimate_prevalence_muac(
#'   df = anthro.04,
#'   wt = NULL,
#'   edema = edema,
#'   province
#' )
#'
#' @rdname prev_muac
#'
#' @export
#'
mw_estimate_prevalence_muac <- function(df,
                                        wt = NULL,
                                        edema = NULL,
                                        ...) {
  ## Difuse argument `.by` ----
  .by <- rlang::enquos(...)


  ## Enforce measuring unit is in "mm" ----
  if (any(grepl("\\.", df$muac))) {
    stop("MUAC values must be in millimeters. Please try again.")
  }

  ## Empty vector type list to store results ----
  results <- list()

  if (length(.by) > 0) df <- dplyr::group_by(df, !!!.by)
  x <- dplyr::summarise(
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
    .groups = "keep"
  )

  ## Iterate over a data frame and compute estimates as per analysis path ----
  for (i in seq_len(nrow(x))) {
    if (length(.by) > 0) {
      vals <- purrr::map(.by, ~ dplyr::pull(x, !!.x)[i])
      exprs <- purrr::map2(.by, vals, ~ rlang::expr(!!rlang::get_expr(.x) == !!.y))
      data_subset <- dplyr::filter(df, !!!exprs)
    } else {
      data_subset <- df
    }

    analysis_approach <- x$analysis_approach[i]
    if (analysis_approach %in% c("unweighted", "missing")) {
      ## Estimate PPS-based prevalence ----
      output <- complex_survey_estimates_muac(
        data_subset, {{ wt }}, {{ edema }}, !!!.by
      )
    } else {
      ### Estimate age-weighted prevalence as per SMART MUAC tool ----
      if (length(.by) > 0) {
        output <- mw_estimate_age_weighted_prev_muac(
          data_subset,
          muac = .data$muac,
          has_age = TRUE,
          age = .data$age,
          edema = {{ edema }},
          raw_muac = FALSE,
          !!!.by
        ) |>  
          dplyr::select(!!!.by, sam_p = .data$sam, mam_p =.data$ mam, gam_p = .data$gam)
      } else {
        ### Estimate age-weighted prevalence as per SMART MUAC tool ----
        output <- mw_estimate_age_weighted_prev_muac(
          data_subset,
          muac = .data$muac,
          has_age = TRUE,
          age = .data$age,
          edema = {{ edema }}, 
          raw_muac = FALSE
        ) |> 
          dplyr::select(sam_p = .data$sam, mam_p = .data$mam, gam_p = .data$gam)
      }
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

#'
#' @examples
#' ## An application of `mw_estimate_age_weighted_prev_muac()` ----
#' mw_estimate_age_weighted_prev_muac(
#'   df = anthro.04,
#' age = age, 
#' edema = edema, 
#' raw_muac = FALSE, 
#' province
#' )
#'
#' @rdname prev_muac
#' @export
#'

mw_estimate_age_weighted_prev_muac <- function(
  df,
   muac, 
   has_age = TRUE,
   age = NULL, 
   age_cat = NULL,
   edema = NULL, 
   raw_muac = FALSE, 
   ...
) {
  ## Defuse argument `.by` ----
  .by <- rlang::enquos(...)

  ## Enforce measuring unit is in "mm" ----
  if (any(grepl("\\.", df$muac))) {
    stop("MUAC values must be in millimeters. Please try again.")
  }

  flag_var <- if (raw_muac) "flag_muac" else "flag_mfaz"
  df <- dplyr::filter(df, .data[[flag_var]] == 0)

  ## Apply grouping if needed ----
  if (length(.by) > 0) df <- dplyr::group_by(df, !!!.by)

  ## Summarise when age is months is given ----
  if (has_age) {
  u2 <- df |> 
     dplyr::filter(.data$age < 24) |> 
      dplyr::summarise(
        oedema_u2 = mean(ifelse(.data$edema == "y", 1, 0), na.rm = TRUE),
        u2sam = mean(ifelse(.data$muac < 115 & .data$edema == "n", 1, 0), na.rm = TRUE),
        u2mam = mean(ifelse(.data$muac >= 115 & .data$muac < 125 & .data$edema == "n", 1, 0), na.rm = TRUE),
        u2gam = .data$oedema_u2 + .data$u2sam + .data$u2mam
      )
  
  o2 <- df |> 
     dplyr::filter(.data$age >= 24) |> 
      dplyr::summarise(
        oedema_o2 = mean(ifelse(.data$edema == "y", 1, 0), na.rm = TRUE),
        o2sam = mean(ifelse(.data$muac < 115 & .data$edema == "n", 1, 0), na.rm = TRUE),
        o2mam = mean(ifelse(.data$muac >= 115 & .data$muac < 125 & .data$edema == "n", 1, 0), na.rm = TRUE),
        o2gam = .data$o2sam + .data$o2mam + .data$oedema_o2
      )
  } 

  ## Summarise when age is given in age categories instead ----
  if (has_age == FALSE) {
    u2 <- df |> 
     dplyr::filter(.data$age_cat == "6-23") |> 
      dplyr::summarise(
        oedema_u2 = mean(ifelse(.data$edema == "y", 1, 0), na.rm = TRUE),
        u2sam = mean(ifelse(.data$muac < 115 & .data$edema == "n", 1, 0), na.rm = TRUE),
        u2mam = mean(ifelse(.data$muac >= 115 & .data$muac < 125 & .data$edema == "n", 1, 0), na.rm = TRUE),
        u2gam = .data$oedema_u2 + .data$u2sam + .data$u2mam
      )
  
  o2 <- df |> 
     dplyr::filter(.data$age_cat == "24-59") |> 
      dplyr::summarise(
        oedema_o2 = mean(ifelse(.data$edema == "y", 1, 0), na.rm = TRUE),
        o2sam = mean(ifelse(.data$muac < 115 & .data$edema == "n", 1, 0), na.rm = TRUE),
        o2mam = mean(ifelse(.data$muac >= 115 & .data$muac < 125 & .data$edema == "n", 1, 0), na.rm = TRUE),
        o2gam = .data$o2sam + .data$o2mam + .data$oedema_o2
      )
  }

  ## Check the number of grouping variables to then exclude them from over twos before binding ----
  if (length(dplyr::group_vars(o2)) > 0) o2 <- dplyr::select(o2, -length(dplyr::group_vars(o2)))
 
  ## Bind cols and apply age-weighting formulae ----
  x <- dplyr::left_join(u2, o2, by = dplyr::group_vars(df)) |> 
    dplyr::mutate(
      sam = ((.data$oedema_u2 + .data$u2sam) + (2 * (.data$oedema_o2 + .data$o2sam))) / 3,
      mam = (.data$u2mam + (2 * .data$o2mam)) / 3,
      gam = (.data$u2gam + (2 * .data$o2gam)) / 3
    )
  x
  }
