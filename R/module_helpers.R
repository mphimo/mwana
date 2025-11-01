# ==============================================================================
#                         IPC Acute Malnutrition Checker
# ==============================================================================

#' 
#' 
#' Invoke mwana's IPC Acute Malnutrition minimum sample size requirement checker 
#' from within the module server
#'
#'
#' @keywords internal
#'
#' 
mod_call_ipcamn_checker <- function(df, cluster, source = character(), area1, area2) {
  ## Conditionally include area2 ----
  if (all(nzchar(c(area2)))) {
    mw_check_ipcamn_ssreq(
      df = df,
      cluster = !!rlang::sym(cluster),
      .source = source,
      !!rlang::sym(area1), !!rlang::sym(area2)
    )
  } else {
    mw_check_ipcamn_ssreq(
      df = df,
      .source = source,
      cluster = !!rlang::sym(cluster),
      !!rlang::sym(area1)
    )
  }
}

# ==============================================================================
#                              Plausibility Checker
# ==============================================================================

#' 
#' 
#' Invoke mwana's plausibility checkers dynamically from within module server,
#' according to user specifications in the UI 
#'
#'
#' @keywords internal
#' 
#' 
#'
mod_call_plausibility_checkers <- function(
    df, age = NULL, sex, muac = NULL, weight = NULL,
    height = NULL, flags, area1, area2, area3, .for = c("wfhz", "muac", "mfaz")) {
  .for <- match.arg(.for)

  if (.for == "wfhz") {
    if (all(area2 != "", area3 != "")) {
      mw_neat_output_wfhz(
        mw_plausibility_check_wfhz(
          df = df,
          sex = !!rlang::sym(sex),
          age = !!rlang::sym(age),
          weight = !!rlang::sym(weight),
          height = !!rlang::sym(height),
          flags = !!rlang::sym(flags),
          !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
        )
      )
    } else if (area2 != "" && area3 == "") {
      mw_neat_output_wfhz(
        mw_plausibility_check_wfhz(
          df = df,
          sex = !!rlang::sym(sex),
          age = !!rlang::sym(age),
          weight = !!rlang::sym(weight),
          height = !!rlang::sym(height),
          flags = !!rlang::sym(flags),
          !!rlang::sym(area1), !!rlang::sym(area2)
        )
      )
    } else {
      mw_neat_output_wfhz(
        mw_plausibility_check_wfhz(
          df = df,
          sex = !!rlang::sym(sex),
          age = !!rlang::sym(age),
          weight = !!rlang::sym(weight),
          height = !!rlang::sym(height),
          flags = !!rlang::sym(flags),
          !!rlang::sym(area1)
        )
      )
    }
  } else if (.for == "mfaz") {
    if (all(c(area2, area3) != "")) {
      mw_neat_output_mfaz(
        mw_plausibility_check_mfaz(
          df = df,
          sex = !!rlang::sym(sex),
          muac = !!rlang::sym(muac),
          age = !!rlang::sym(age),
          flags = !!rlang::sym(flags),
          !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
        )
      )
    } else if (area2 != "" && area3 == "") {
      mw_neat_output_mfaz(
        mw_plausibility_check_mfaz(
          df = df,
          sex = !!rlang::sym(sex),
          muac = !!rlang::sym(muac),
          age = !!rlang::sym(age),
          flags = !!rlang::sym(flags),
          !!rlang::sym(area1), !!rlang::sym(area2)
        )
      )
    } else {
      mw_neat_output_mfaz(
        mw_plausibility_check_mfaz(
          df = df,
          sex = !!rlang::sym(sex),
          muac = !!rlang::sym(muac),
          age = !!rlang::sym(age),
          flags = !!rlang::sym(flags),
          !!rlang::sym(area1)
        )
      )
    }
  } else {
    if (all(c(area2, area3) != "")) {
      mw_neat_output_muac(
        mw_plausibility_check_muac(
          df = df,
          sex = !!rlang::sym(sex),
          muac = !!rlang::sym(muac),
          flags = !!rlang::sym(flags),
          !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
        )
      )
    } else if (area2 != "" && area3 == "") {
      mw_neat_output_muac(
        mw_plausibility_check_muac(
          df = df,
          sex = !!rlang::sym(sex),
          muac = !!rlang::sym(muac),
          flags = !!rlang::sym(flags),
          !!rlang::sym(area1), !!rlang::sym(area2)
        )
      )
    } else {
      mw_neat_output_muac(
        mw_plausibility_check_muac(
          df = df,
          sex = !!rlang::sym(sex),
          muac = !!rlang::sym(muac),
          flags = !!rlang::sym(flags),
          !!rlang::sym(area1)
        )
      )
    }
  }
}


# ==============================================================================
#                              Prevalence Estimators
# ==============================================================================

#' 
#' 
#' Display input variables dynamically, according to UI for screening
#'
#' @keywords internal
#'
#'
mod_display_input_variables_survey <- function(vars, ns) {
  ### Capture namespacing ----
  list(
    shiny::selectInput(
      inputId = ns("area1"),
      label = shiny::tagList(
        "Area 1",
        htmltools::tags$div(
          style = "font-size: 0.85em; color: #6c7574;", "(Primary area)"
        )
      ),
      choices = c("", vars)
    ),
    shiny::selectInput(ns("area2"),
      label = shiny::tagList("Area 2", htmltools::tags$div(
        style = "font-size: 0.85em; color: #6c7574;", "(Sub-area)"
      )),
      choices = c("", vars)
    ),
    shiny::selectInput(
      inputId = ns("area3"),
      label = shiny::tagList("Area 3", htmltools::tags$div(
        style = "font-size: 0.85em; color: #6c7574;", "Sub-area)"
      )),
      choices = c("", vars)
    ),
    shiny::selectInput(
      inputId = ns("wts"),
      label = "Survey weights",
      htmltools::tags$div(
        style = "font-size: 0.85em; color: #6c7574;",
        "Final survey weights for weighted analysis"
      ),
      choices = c("", vars)
    ),
    shiny::selectInput(
      inputId = ns("oedema"),
      label = "Oedema",
      choices = c("", vars)
    )
  )
}

#' 
#' 
#' 
#' Display input variables dynamically, according to UI for screening
#'
#'
#' @keywords internal
#'
#'
mod_display_input_variables_screening <- function(vars, ns) {
  ### Capture namespacing ----
  list(
    shiny::selectInput(
      inputId = ns("area1"),
      label = shiny::tagList(
        "Area 1",
        htmltools::tags$div(
          style = "font-size: 0.85em; color: #6c7574;", "Primary area"
        )
      ),
      choices = c("", vars)
    ),
    shiny::selectInput(ns("area2"),
      label = shiny::tagList("Area 2", htmltools::tags$div(
        style = "font-size: 0.85em; color: #6c7574;", "Sub-area"
      )),
      choices = c("", vars)
    ),
    shiny::selectInput(
      inputId = ns("area3"),
      label = shiny::tagList("Area 3", htmltools::tags$div(
        style = "font-size: 0.85em; color: #6c7574;", "Sub-area"
      )),
      choices = c("", vars)
    ),
    shiny::selectInput(
      inputId = ns("age_cat"),
      label = shiny::tagList(
        "Age categories (6-23 and 24-59)",
        htmltools::tags$div(
          style = "font-size: 0.85em; color: #6c7574;",
          "Only sapply in the absence of age in months"
        )
      ),
      choices = c("", vars)
    ),
    shiny::selectInput(
      inputId = ns("muac"),
      label = shiny::tagList("MUAC", htmltools::tags$span("*", style = "color: red;")),
      choices = c("", vars)
    ),
    shiny::selectInput(
      inputId = ns("oedema"),
      label = "Oedema",
      choices = c("", vars)
    )
  )
}

#'
#' 
#' Invoke mwana's prevalence functions from within module server according to 
#' user specifications in the UI 
#'
#'
#' @keywords internal
#'
#'
mod_call_prevalence_function_wfhz <- function(
    df, wts = NULL, oedema = NULL,
    area1, area2, area3) {
  if (all(nzchar(c(area1, area2, area3)))) {
    if ((nzchar(wts) && nzchar(oedema))) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = !!rlang::sym(wts),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else if (!nzchar(wts) && nzchar(oedema)) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = NULL,
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else if (nzchar(wts) && !nzchar(oedema)) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = !!rlang::sym(wts),
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = NULL,
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    }
  } else if (nzchar(area2) && !nzchar(area3)) {
    if (all(nzchar(c(wts, oedema)))) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = !!rlang::sym(wts),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else if (!nzchar(wts) && nzchar(oedema)) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = NULL,
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else if (nzchar(wts) && !nzchar(oedema)) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = !!rlang::sym(wts),
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = NULL,
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    }
  } else {
    if (all(nzchar(c(wts, oedema)))) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = !!rlang::sym(wts),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1)
      )
    } else if (!nzchar(wts) && nzchar(oedema)) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = NULL,
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1)
      )
    } else if (nzchar(wts) && !nzchar(oedema)) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = !!rlang::sym(wts),
        edema = NULL,
        !!rlang::sym(area1)
      )
    } else {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = NULL,
        edema = NULL,
        !!rlang::sym(area1)
      )
    }
  }
}


#'
#' 
#' 
#' Invoke mwana's prevalence functions from within module server according to 
#' user specifications in the UI 
#'
#' @keywords internal
#'
#'
mod_call_prevalence_function_muac <- function(
    df, wts = NULL, oedema = NULL,
    area1, area2, area3) {
  if (all(nzchar(c(area1, area2, area3)))) {
    if ((nzchar(wts) && nzchar(oedema))) {
      mw_estimate_prevalence_muac(
        df = df,
        wt = !!rlang::sym(wts),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else if (!nzchar(wts) && nzchar(oedema)) {
      mw_estimate_prevalence_muac(
        df = df,
        wt = NULL,
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else if (nzchar(wts) && !nzchar(oedema)) {
      mw_estimate_prevalence_muac(
        df = df,
        wt = !!rlang::sym(wts),
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else {
      mw_estimate_prevalence_muac(
        df = df,
        wt = NULL,
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    }
  } else if (nzchar(area2) && !nzchar(area3)) {
    if (all(nzchar(c(wts, oedema)))) {
      mw_estimate_prevalence_muac(
        df = df,
        wt = !!rlang::sym(wts),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else if (!nzchar(wts) && nzchar(oedema)) {
      mw_estimate_prevalence_muac(
        df = df,
        wt = NULL,
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else if (nzchar(wts) && !nzchar(oedema)) {
      mw_estimate_prevalence_muac(
        df = df,
        wt = !!rlang::sym(wts),
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else {
      mw_estimate_prevalence_muac(
        df = df,
        wt = NULL,
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    }
  } else {
    if (all(nzchar(c(wts, oedema)))) {
      mw_estimate_prevalence_muac(
        df = df,
        wt = !!rlang::sym(wts),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1)
      )
    } else if (!nzchar(wts) && nzchar(oedema)) {
      mw_estimate_prevalence_muac(
        df = df,
        wt = NULL,
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1)
      )
    } else if (nzchar(wts) && !nzchar(oedema)) {
      mw_estimate_prevalence_muac(
        df = df,
        wt = !!rlang::sym(wts),
        edema = NULL,
        !!rlang::sym(area1)
      )
    } else {
      mw_estimate_prevalence_muac(
        df = df,
        wt = NULL,
        edema = NULL,
        !!rlang::sym(area1)
      )
    }
  }
}


#'
#' 
#' 
#' Invoke mwana's prevalence functions from within module server according to 
#' user specifications in the UI 
#'
#' @keywords internal
#'
#'
mod_call_prevalence_function_combined <- function(
    df, wts = NULL, oedema = NULL,
    area1, area2, area3) {
  if (all(nzchar(c(area1, area2, area3)))) {
    if ((nzchar(wts) && nzchar(oedema))) {
      mw_estimate_prevalence_combined(
        df = df,
        wt = !!rlang::sym(wts),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else if (!nzchar(wts) && nzchar(oedema)) {
      mw_estimate_prevalence_combined(
        df = df,
        wt = NULL,
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else if (nzchar(wts) && !nzchar(oedema)) {
      mw_estimate_prevalence_combined(
        df = df,
        wt = !!rlang::sym(wts),
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else {
      mw_estimate_prevalence_combined(
        df = df,
        wt = NULL,
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    }
  } else if (nzchar(area2) && !nzchar(area3)) {
    if (all(nzchar(c(wts, oedema)))) {
      mw_estimate_prevalence_combined(
        df = df,
        wt = !!rlang::sym(wts),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else if (!nzchar(wts) && nzchar(oedema)) {
      mw_estimate_prevalence_combined(
        df = df,
        wt = NULL,
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else if (nzchar(wts) && !nzchar(oedema)) {
      mw_estimate_prevalence_combined(
        df = df,
        wt = !!rlang::sym(wts),
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else {
      mw_estimate_prevalence_combined(
        df = df,
        wt = NULL,
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    }
  } else {
    if (all(nzchar(c(wts, oedema)))) {
      mw_estimate_prevalence_combined(
        df = df,
        wt = !!rlang::sym(wts),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1)
      )
    } else if (!nzchar(wts) && nzchar(oedema)) {
      mw_estimate_prevalence_combined(
        df = df,
        wt = NULL,
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1)
      )
    } else if (nzchar(wts) && !nzchar(oedema)) {
      mw_estimate_prevalence_combined(
        df = df,
        wt = !!rlang::sym(wts),
        edema = NULL,
        !!rlang::sym(area1)
      )
    } else {
      mw_estimate_prevalence_combined(
        df = df,
        wt = NULL,
        edema = NULL,
        !!rlang::sym(area1)
      )
    }
  }
}


#'
#' 
#' 
#' Invoke mwana's prevalence functions from within module server according to 
#' user specifications in the UI 
#'
#' @keywords internal
#'
#'
#'
mod_call_prevalence_function_screening <- function(
    df, muac, oedema = NULL,
    area1, area2, area3) {
  if (all(nzchar(c(area1, area2, area3)))) {
    if (nzchar(oedema)) {
      mw_estimate_prevalence_screening(
        df = df,
        muac = !!rlang::sym(muac),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else {
      mw_estimate_prevalence_screening(
        df = df,
        muac = !!rlang::sym(muac),
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    }
  } else if (nzchar(area2) && !nzchar(area3)) {
    if (nzchar(oedema)) {
      mw_estimate_prevalence_screening(
        df = df,
        muac = !!rlang::sym(muac),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else {
      mw_estimate_prevalence_screening(
        df = df,
        muac = !!rlang::sym(muac),
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    }
  } else {
    if (nzchar(oedema)) {
      mw_estimate_prevalence_screening(
        df = df,
        muac = !!rlang::sym(muac),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1)
      )
    } else {
      mw_estimate_prevalence_screening(
        df = df,
        muac = !!rlang::sym(muac),
        edema = NULL,
        !!rlang::sym(area1)
      )
    }
  }
}

#'
#' 
#' 
#' Invoke mwana's prevalence functions from within module server according to 
#' user specifications in the UI 
#' 
#' 
#' @keywords internal
#' 
#' 
mod_call_prevalence_function_screening2 <- function(
    df, age_cat, muac, oedema = NULL,
    area1, area2, area3) {
  if (all(nzchar(c(area1, area2, area3)))) {
    if (nzchar(oedema)) {
      mw_estimate_prevalence_screening2(
        df = df,
        age_cat = !!rlang::sym(age_cat),
        muac = !!rlang::sym(muac),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else {
      mw_estimate_prevalence_screening2(
        df = df,
        age_cat = !!rlang::sym(age_cat),
        muac = !!rlang::sym(muac),
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    }
  } else if (nzchar(area2) && !nzchar(area3)) {
    if (nzchar(oedema)) {
      mw_estimate_prevalence_screening2(
        df = df,
        age_cat = !!rlang::sym(age_cat),
        muac = !!rlang::sym(muac),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else {
      mw_estimate_prevalence_screening2(
        df = df,
        age_cat = !!rlang::sym(age_cat),
        muac = !!rlang::sym(muac),
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    }
  } else {
    if (nzchar(oedema)) {
      mw_estimate_prevalence_screening2(
        df = df,
        age_cat = !!rlang::sym(age_cat),
        muac = !!rlang::sym(muac),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1)
      )
    } else {
      mw_estimate_prevalence_screening2(
        df = df,
        age_cat = !!rlang::sym(age_cat),
        muac = !!rlang::sym(muac),
        edema = NULL,
        !!rlang::sym(area1)
      )
    }
  }
}


#'
#' 
#' @keywords internal
#' 
#' 
mod_neat_prevalence_output_survey <- function(df, .type = c("wfhz", "muac", "combined")) {
  
  df <- dplyr::mutate(
    .data = df, 
    dplyr::across(
      .cols = -dplyr::contains(c("_n", "_deff", "_pop")), 
      .fns = scales::label_percent(
        accuracy = 0.1, suffix = "%", decimal.mark = "."
      )
    )
  ) 

  if (.type %in% c("wfhz", "muac")) {
    df |> 
      dplyr::relocate(.data$wt_pop, .before = .data$gam_n) |> 
    dplyr::rename(
      "children (N)" = .data$wt_pop,
      "gam #" = .data$gam_n,
      "gam %" = .data$gam_p,
      "gam lcl" = .data$gam_p_low,
      "gam ucl" = .data$gam_p_upp,
      "gam deff" = .data$gam_p_deff,
      "sam #" = .data$sam_n,
      "sam %" = .data$sam_p,
      "sam lcl" = .data$sam_p_low,
      "sam ucl" = .data$sam_p_upp,
      "sam deff" = .data$sam_p_deff,
      "mam #" = .data$mam_n,
      "mam %" = .data$mam_p,
      "mam lcl" = .data$mam_p_low,
      "mam ucl" = .data$mam_p_upp,
      "mam deff" = .data$mam_p_deff
    )
  } else {
    df |> 
      dplyr::relocate(.data$wt_pop, .before = .data$cgam_n) |> 
    dplyr::rename(
      "children (N)" = .data$wt_pop,
      "cgam #" = .data$cgam_n,
      "cgam %" = .data$cgam_p,
      "cgam lcl" = .data$cgam_p_low,
      "cgam ucl" = .data$cgam_p_upp,
      "cgam deff" = .data$cgam_p_deff,
      "csam #" = .data$csam_n,
      "csam %" = .data$csam_p,
      "csam lcl" = .data$csam_p_low,
      "csam ucl" = .data$csam_p_upp,
      "csam deff" = .data$csam_p_deff,
      "cmam #" = .data$cmam_n,
      "cmam %" = .data$cmam_p,
      "cmam lcl" = .data$cmam_p_low,
      "cmam ucl" = .data$cmam_p_upp,
      "cmam deff" = .data$cmam_p_deff
    )
  }
    
}


#'
#' 
#' @keywords internal
#' 
#' 
mod_neat_prevalence_output_screening <- function(df) {
  
  df <- dplyr::mutate(
    .data = df, 
    dplyr::across(
      .cols = -dplyr::contains(c("_n", "_deff", "_pop")), 
      .fns = scales::label_percent(
        accuracy = 0.1, suffix = "%", decimal.mark = "."
      )
    )
  ) 
    dplyr::rename(
      .data = df,
      "gam #" = .data$gam_n,
      "gam %" = .data$gam_p,
      "sam #" = .data$sam_n,
      "sam %" = .data$sam_p,
      "mam #" = .data$mam_n,
      "mam %" = .data$mam_p
    )
    
}