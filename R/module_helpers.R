# ==============================================================================
#                                  Data Wrangling
# ==============================================================================

#'
#'
#' Display input variables dynamically, according to UI for screening
#'
#'
#' @keywords internal
#'
#'
mod_data_wrangling_display_input_variables <- function(vars, method, ns) {
  ### Base inputs always shown ----
  base_list <- list(
    #### Date of data collection: optional ----
    shiny::selectInput(
      inputId = ns("dos"),
      label = htmltools::tags$span("Date of data collection",
        style = "font-size: 14px; font-weight: bold;"
      ),
      choices = c("", vars)
    ),

    #### Date of birth: optional ----
    shiny::selectInput(
      inputId = ns("dob"),
      label = htmltools::tags$span("Date of birth",
        style = "font-size: 14px; font-weight: bold;"
      ),
      choices = c("", vars)
    ),
    #### Age: optional ----
    shiny::selectInput(
      inputId = ns("age"),
      label = htmltools::tags$span("Age (months)",
        style = "font-size: 14px; font-weight: bold;"
      ),
      choices = c("", vars)
    ),

    #### Sex: mandatory ----
    shiny::selectInput(
      inputId = ns("sex"),
      label = shiny::tagList(
        htmltools::tags$span("Sex",
          style = "font-size: 14px; font-weight: bold;"
        ),
        htmltools::tags$span("*", style = "color: red;")
      ),
      choices = c("", vars)
    )
  )

  ### Conditional inputs depending on method ----
  #### WFHZ ----
  if (method == "wfhz") {
    input_vars <- c(base_list, list(
      shiny::selectInput(
        inputId = ns("weight"),
        label = shiny::tagList(
          htmltools::tags$span("Weight (kg)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      ),

      ###### Height: mandatory ----
      shiny::selectInput(
        inputId = ns("height"),
        label = shiny::tagList(
          htmltools::tags$span("Height (cm)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      )
    ))
  }

  #### MFAZ ----
  if (method == "mfaz") {
    input_vars <- c(base_list, list(
      shiny::selectInput(
        inputId = ns("muac"),
        label = shiny::tagList(
          htmltools::tags$span("MUAC (mm)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      )
    ))
  }

  #### MUAC ----
  if (method == "muac") {
    input_vars <- list(
      shiny::selectInput(
        inputId = ns("sex"),
        label = shiny::tagList(
          htmltools::tags$span("Sex",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      ),
      shiny::selectInput(
        inputId = ns("muac"),
        label = shiny::tagList(
          htmltools::tags$span("MUAC (mm)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      )
    )
  }

  #### Combined ----
  if (method == "combined") {
    input_vars <- c(base_list, list(
      shiny::selectInput(
        inputId = ns("weight"),
        label = shiny::tagList(
          htmltools::tags$span("Weight (kg)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      ),

      ###### Height: mandatory ----
      shiny::selectInput(
        inputId = ns("height"),
        label = shiny::tagList(
          htmltools::tags$span("Height (cm)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      ),
      shiny::selectInput(
        inputId = ns("muac"),
        label = shiny::tagList(
          htmltools::tags$span("MUAC (mm)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      )
    ))
  }

  input_vars
}

# ==============================================================================
#                              Plausibility Checker
# ==============================================================================


#'
#' Display input variables dynamically, according to UI for screening
#'
#' @keywords internal
#'
mod_plausibility_display_input_variables <- function(vars, method, ns) {
  ### Base inputs always shown
  inputs <- list(
    shiny::selectInput(
      inputId = ns("area1"),
      label = shiny::tagList(
        htmltools::tags$span("Area 1", style = "font-size: 14px; font-weight: bold;"),
        htmltools::tags$div(style = "font-size: 0.85em; color: #6c7574;", "(Primary area)")
      ),
      choices = c("", vars)
    ),
    shiny::selectInput(
      inputId = ns("area2"),
      label = shiny::tagList(
        htmltools::tags$span("Area 2", style = "font-size: 14px; font-weight: bold;"),
        htmltools::tags$div(style = "font-size: 0.85em; color: #6c7574;", "(Sub-area)")
      ),
      choices = c("", vars)
    ),
    shiny::selectInput(
      inputId = ns("area3"),
      label = shiny::tagList(
        htmltools::tags$span("Area 3", style = "font-size: 14px; font-weight: bold;"),
        htmltools::tags$div(style = "font-size: 0.85em; color: #6c7574;", "(Sub-area)")
      ),
      choices = c("", vars)
    ),
    shiny::selectInput(
      inputId = ns("sex"),
      label = shiny::tagList(
        htmltools::tags$span("Sex", style = "font-size: 14px; font-weight: bold;"),
        htmltools::tags$span("*", style = "color: red;")
      ),
      choices = c("", vars)
    )
  )

  ### Conditional inputs depending on method
  if (method == "wfhz") {
    inputs <- c(inputs, list(
      shiny::selectInput(
        inputId = ns("age"),
        label = shiny::tagList(
          htmltools::tags$span("Age (months)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      ),
      shiny::selectInput(
        inputId = ns("weight"),
        label = shiny::tagList(
          htmltools::tags$span("Weight (kg)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      ),
      shiny::selectInput(
        inputId = ns("height"),
        label = shiny::tagList(
          htmltools::tags$span("Height (cm)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      )
    ))
  } else if (method == "mfaz") {
    inputs <- c(inputs, list(
      shiny::selectInput(
        inputId = ns("age"),
        label = shiny::tagList(
          htmltools::tags$span("Age (months)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      ),
      shiny::selectInput(
        inputId = ns("muac"),
        label = shiny::tagList(
          htmltools::tags$span("MUAC (cm)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      )
    ))
  } else {
    inputs <- c(inputs, list(
      shiny::selectInput(
        inputId = ns("muac"),
        label = shiny::tagList(
          htmltools::tags$span("MUAC (cm)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      )
    ))
  }

  # Always add flags at the end
  inputs_vars <- c(inputs, list(
    shiny::selectInput(
      inputId = ns("flags"),
      label = shiny::tagList(
        htmltools::tags$span("Flags", style = "font-size: 14px; font-weight: bold;"),
        htmltools::tags$span("*", style = "color: red;")
      ),
      choices = c("", vars)
    )
  ))

  inputs_vars
}

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
mod_plausibility_call_checker <- function(
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
mod_prevalence_display_input_variables <- function(vars, source, ns) {
  ### Capture namespacing ----
  inputs <- list(
    shiny::selectInput(
      inputId = ns("area1"),
      label = shiny::tagList(
        htmltools::tags$span("Area 1",
          style = "font-size: 14px; font-weight: bold;"
        ),
        htmltools::tags$div(
          style = "font-size: 0.85em; color: #6c7574;", "(Primary area)"
        )
      ),
      choices = c("", vars)
    ),
    shiny::selectInput(ns("area2"),
      label = shiny::tagList(
        htmltools::tags$span("Area 2",
          style = "font-size: 14px; font-weight: bold;"
        ),
        htmltools::tags$div(
          style = "font-size: 0.85em; color: #6c7574;", "(Sub-area)"
        )
      ),
      choices = c("", vars)
    ),
    shiny::selectInput(
      inputId = ns("area3"),
      label = shiny::tagList(
        htmltools::tags$span("Area 3",
          style = "font-size: 14px; font-weight: bold;"
        ),
        htmltools::tags$div(
          style = "font-size: 0.85em; color: #6c7574;", "Sub-area)"
        )
      ),
      choices = c("", vars)
    )
  )

  #### Conditional inputs depending on source of data ----
  if (source == "survey") {
    inputs <- c(inputs, list(shiny::selectInput(
      inputId = ns("wts"),
      label = shiny::tagList(
        htmltools::tags$span("Survey weights",
          style = "font-size: 14px; font-weight: bold;"
        ),
        htmltools::tags$div(
          style = "font-size: 0.85em; color: #6c7574;",
          "Final survey weights for weighted analysis"
        )
      ),
      choices = c("", vars)
    )))
  }

  if (source == "screening") {
    inputs <- c(inputs, list(
      shiny::selectInput(
        inputId = ns("age_cat"),
        label = shiny::tagList(
          htmltools::tags$span("Age categories (6-23 and 24-59)",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$div(
            style = "font-size: 0.85em; color: #6c7574;",
            "Only supply in the absence of age in months"
          )
        ),
        choices = c("", vars)
      ),
      shiny::selectInput(
        inputId = ns("muac"),
        label = shiny::tagList(
          htmltools::tags$span("MUAC",
            style = "font-size: 14px; font-weight: bold;"
          ),
          htmltools::tags$span("*", style = "color: red;")
        ),
        choices = c("", vars)
      )
    ))
  }

  # Always add flags at the end
  inputs_vars <- c(inputs, list(
    shiny::selectInput(
      inputId = ns("flags"),
      label = shiny::tagList(
        htmltools::tags$span("Flags", style = "font-size: 14px; font-weight: bold;"),
        htmltools::tags$span("*", style = "color: red;")
      ),
      choices = c("", vars)
    )
  ))

  inputs_vars
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
mod_ipccheck_display_input_variables <- function(vars, ns) {
  list(
    shiny::selectInput(ns("area1"),
      label = shiny::tagList(
        htmltools::tags$span("Area 1",
          style = "font-size: 14px; font-weight: bold;"
        ),
        htmltools::tags$span("*", style = "color: red;"),
        htmltools::tags$div(
          style = "font-size: 0.85em; color: #6c7574;", "(Primary area)"
        )
      ),
      choices = c("", vars)
    ),

    ##### Secondary grouping area: optional ----
    shiny::selectInput(ns("area2"),
      label = shiny::tagList(
        htmltools::tags$span("Area 2",
          style = "font-size: 14px; font-weight: bold;"
        ),
        htmltools::tags$div(
          style = "font-size: 0.85em; color: #6c7574;", "(Sub-area)"
        )
      ),
      choices = c("", vars)
    ),

    ##### Survey clusters: mandatory ----
    shiny::selectInput(
      inputId = ns("psu"),
      label = shiny::tagList(
        htmltools::tags$span("Survey clusters",
          style = "font-size: 14px; font-weight: bold;"
        ),
        htmltools::tags$span("*", style = "color: red;"),
      ),
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
mod_prevalence_call_wfhz_prev_estimator <- function(
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
mod_prevalence_call_muac_prev_estimator <- function(
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
mod_prevalence_call_combined_prev_estimator <- function(
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
mod_prevalence_call_prev_estimator_screening <- function(
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
mod_prevalence_call_prev_estimator_screening2 <- function(
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
mod_prevalence_neat_output_survey <- function(
    df,
    .type = c("wfhz", "muac", "combined")) {
  df <- dplyr::mutate(
    .data = df,
    dplyr::across(
      .cols = dplyr::ends_with(c("am_p", "am_p_low", "am_p_upp")),
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
mod_prevalence_neat_output_screening <- function(df) {
  df <- dplyr::mutate(
    .data = df,
    dplyr::across(
      .cols = dplyr::contains("am_p"),
      .fns = scales::label_percent(
        accuracy = 0.1, suffix = "%", decimal.mark = "."
      )
    )
  )

  ### Rename based on the existance of column "gam_n" ----
  if ("gam_n" %in% names(df)) {
    dplyr::rename(
      .data = df,
      "children (N)" = .data$N,
      "gam #" = .data$gam_n,
      "gam %" = .data$gam_p,
      "sam #" = .data$sam_n,
      "sam %" = .data$sam_p,
      "mam #" = .data$mam_n,
      "mam %" = .data$mam_p
    )
  } else {
    dplyr::rename(
      .data = df,
      "children (N)" = .data$N,
      "gam %" = .data$gam_p,
      "sam %" = .data$sam_p,
      "mam %" = .data$mam_p
    )
  }
}





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
mod_ipccheck_call_checher <- function(df, cluster, source = character(), area1, area2) {
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
