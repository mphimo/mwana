#'
#' Estimate age-weighted prevalence of wasting by MUAC
#'
#' @description
#'
#' Estimates age‑weighted prevalence of wasting using MUAC.
#' Accepts age in months or in categories ('6–23', '24–59').
#' The default is age in months.
#'
#' The prevalence is weighted as:
#' \deqn{( prevalence_{6-23} + 2 \times prevalence_{24-59} ) / 3}
#'
#' Whilst the function is exported to users as a standalone, it is embedded into
#' the following major MUAC prevalence functions of this package:
#' [mw_estimate_prevalence_muac()], [mw_estimate_prevalence_screening()], and
#' [mw_estimate_prevalence_screening2()].
#'
#' @param df A `tibble` object produced by `mwana` data wranglers.
#'
#' @param muac A `numeric` or `integer` vector of raw MUAC values. The
#' measurement unit should be millimeters.
#'
#' @param has_age Logical. Specifies whether the input dataset provides age in
#' months or in categories ('6–23', '24–59'). Defaults to `TRUE` when age is
#' given in months.
#'
#' @param age A vector of class `double` of child's age in months. Defaults to
#' NULL. Only use if `has_age = TRUE`, otherwise set it to `NULL`.
#'
#' @param age_cat A `character` vector of child's age in categories. Code values
#' should be "6-23" and "24-59". Defaults to `NULL`. Only use it if `has_age = FALSE`.
#'
#' @param oedema A `character` vector for presence of nutritional oedema. Code
#' values should be "y" for presence and "n" for absence. Defaults to NULL.
#'
#' @param raw_muac Logical. Whether outliers should be excluded based on the raw
#' MUAC values or MFAZ. For the former, set it to `TRUE`, otherwise `FALSE`.
#' Defaults to MFAZ.
#'
#' @param ... A vector of class `character`, specifying the categories for which
#' the analysis should be summarised for. Usually geographical areas. More than
#' one vector can be specified.
#'
#' @returns A summary `tibble` with wasting prevalence estimates, as given by the
#' SMART updated MUAC tool (see references below).
#'
#' @details
#' As a standalone function, the user must check data quality before calling the function.
#'
#' @references
#' SMART Initiative (no date). *Updated MUAC data collection tool*. Available at:
#' <https://smartmethodology.org/survey-planning-tools/updated-muac-tool/>
#'
#' @examples
#' ## Example application when age is given in months ----
#' mw_estimate_age_weighted_prev_muac(
#'   df = anthro.04,
#'   muac = muac,
#'   has_age = TRUE,
#'   age = age,
#'   age_cat = FALSE,
#'   oedema = oedema,
#'   raw_muac = FALSE,
#'   province
#' )
#'
#' ## Example application when age is given in categories ----
#' anthro.04 |>
#'   transform(age_cat = ifelse(age < 24, "6-23", "24-59")) |>
#'   mw_wrangle_muac(
#'     muac = muac,
#'     .recode_muac = FALSE,
#'     .to = "none",
#'     sex = sex,
#'     .recode_sex = FALSE
#'   ) |>
#'   mw_estimate_age_weighted_prev_muac(
#'     has_age = FALSE,
#'     age = NULL,
#'     age_cat = age_cat,
#'     oedema = oedema,
#'     raw_muac = FALSE
#'   )
#'
#' @export
#'
mw_estimate_age_weighted_prev_muac <- function(
    df,
    muac,
    has_age = TRUE,
    age = NULL,
    age_cat = NULL,
    oedema = NULL,
    raw_muac = FALSE,
    ...) {
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
        oedema_u2 = mean(ifelse(.data$oedema == "y", 1, 0), na.rm = TRUE),
        u2sam = mean(ifelse(.data$muac < 115 & .data$oedema == "n", 1, 0), na.rm = TRUE),
        u2mam = mean(ifelse(.data$muac >= 115 & .data$muac < 125 & .data$oedema == "n", 1, 0), na.rm = TRUE),
        u2gam = .data$oedema_u2 + .data$u2sam + .data$u2mam
      )

    o2 <- df |>
      dplyr::filter(.data$age >= 24) |>
      dplyr::summarise(
        oedema_o2 = mean(ifelse(.data$oedema == "y", 1, 0), na.rm = TRUE),
        o2sam = mean(ifelse(.data$muac < 115 & .data$oedema == "n", 1, 0), na.rm = TRUE),
        o2mam = mean(ifelse(.data$muac >= 115 & .data$muac < 125 & .data$oedema == "n", 1, 0), na.rm = TRUE),
        o2gam = .data$o2sam + .data$o2mam + .data$oedema_o2
      )
  }

  ## Summarise when age is given in age categories instead ----
  if (has_age == FALSE) {
    u2 <- df |>
      dplyr::filter(.data$age_cat == "6-23") |>
      dplyr::summarise(
        oedema_u2 = mean(ifelse(.data$oedema == "y", 1, 0), na.rm = TRUE),
        u2sam = mean(ifelse(.data$muac < 115 & .data$oedema == "n", 1, 0), na.rm = TRUE),
        u2mam = mean(ifelse(.data$muac >= 115 & .data$muac < 125 & .data$oedema == "n", 1, 0), na.rm = TRUE),
        u2gam = .data$oedema_u2 + .data$u2sam + .data$u2mam
      )

    o2 <- df |>
      dplyr::filter(.data$age_cat == "24-59") |>
      dplyr::summarise(
        oedema_o2 = mean(ifelse(.data$oedema == "y", 1, 0), na.rm = TRUE),
        o2sam = mean(ifelse(.data$muac < 115 & .data$oedema == "n", 1, 0), na.rm = TRUE),
        o2mam = mean(ifelse(.data$muac >= 115 & .data$muac < 125 & .data$oedema == "n", 1, 0), na.rm = TRUE),
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
