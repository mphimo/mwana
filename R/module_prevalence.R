#'
#'
#'
#' @export
#'
#'
module_ui_prevalence <- function(id) {
  ## Namespace ID ----
  ns <- shiny::NS(id)

  bslib::layout_sidebar(
    sidebar = bslib::sidebar(
      width = 400,
      position = "left",

      ### Left side of the navbar ----
      bslib::card(
        style = "width: 350px;",
        bslib::card_header(
          htmltools::tags$span(
            "Define Analysis Parameters",
            style = "font-weight: 600;"
          )
        ),

        #### Select the source of data for prevalence analysis ----
        shiny::radioButtons(
          inputId = ns("source"),
          label = "Select Data Source",
          choices = list(
            "Survey" = "survey",
            "Screening" = "screening"
          ),
          selected = "survey",
          inline = TRUE
        ),

        #### Display method through which prevalence should be estimated ----
        shiny::uiOutput(outputId = ns("amnby")),

        #### Display variables corresponding to user-defined method ----
        shiny::uiOutput(outputId = ns("amn_vars")),

        #### Add a blank space ----
        htmltools::tags$br(),

        #### Add action button ----
        shiny::actionButton(
          inputId = ns("estimprev"),
          label = "Estimate Prevalence",
          class = "btn-primary"
        )
      )
    ),

    ### Right side of the nav panel: Prevalence results ----
    bslib::card(
      bslib::card_header(
        htmltools::tags$span(
          "Prevalence Analysis Results",
          style = "font-weight: 600;"
        )
      ),

      #### Inform user when analysis is running ----
      shinycssloaders::withSpinner(
        ui_element = DT::DTOutput(outputId = ns("results")),
        type = 8,
        color.background = "#004225",
        image = "logo.png",
        image.height = "50px",
        color = "#004225",
        caption = htmltools::tags$div(
          htmltools::tags$h6("Estimating prevalence"),
          htmltools::tags$h6("Please wait...")
        )
      ),

      #### Download results ----
      shiny::uiOutput(outputId = ns("download_results"))
    )
  )
}



#'
#'
#'
#'
#'
#'
module_server_prevalence <- function(id, data) {
  shiny::moduleServer(
    id,
    module = function(input, output, session) {
      ### Capture namespacing ----
      ns <- session$ns

      ### Capture reactivity ----
      prevalence <- shiny::reactiveValues(estimated = NULL, estimating = NULL)

      ### Render the method through which GAM should be estimated ----
      output$amnby <- shiny::renderUI({
        #### Display method options ----
        switch(input$source,

          ##### Options for survey data ----
          "survey" = {
            shiny::radioButtons(
              inputId = ns("amn_method_survey"),
              label = "Acute Malnutrition Based on:",
              choices = list(
                "WFHZ" = "wfhz",
                "MUAC" = "muac",
                "Combined" = "combined"
              ),
              selected = "wfhz",
              inline = TRUE
            )
          },

          ##### Options for screening data: check if age is available ----
          "screening" = {
            shiny::radioButtons(
              inputId = ns("amn_method_screening"),
              label = "Age variable is available?",
              choices = list("Yes" = "yes", "No" = "no"),
              selected = "yes",
              inline = TRUE
            )
          }
        )
      })

      shiny::observeEvent(input$source, {
        ### Ensure input data exists ----
        shiny::req(data())

        ### Render input variables ----
        output$amn_vars <- shiny::renderUI({
          vars <- names(data())
          shiny::req(data())
          if (input$source == "survey") {
            display_input_variables_survey(vars = vars, ns = ns)
          } else {
            display_input_variables_screening(vars = vars, ns = ns)
          }
        })
      })

      ### Always observe Action button, but branch inside ----
      shiny::observeEvent(input$estimprev, {
        ### Ensure input data exists ----
        shiny::req(data())
        prevalence$estimating <- TRUE

        tryCatch(
          {
            p <- if (input$source == "survey") {
              switch(input$amn_method_survey,
                "wfhz" = {
                  run_mwana_prevalence_functions_wfhz(
                    df = data(),
                    wts = input$wts,
                    oedema = input$oedema,
                    area1 = input$area1,
                    area2 = input$area2,
                    area3 = input$area3
                  )
                },
                "muac" = {
                  data() |>
                    dplyr::mutate(muac = recode_muac(muac, "mm")) |>
                    mw_estimate_prevalence_muac()
                },
                "combined" = {
                  data() |>
                    dplyr::mutate(muac = recode_muac(muac, "mm")) |>
                    mw_estimate_prevalence_combined()
                }
              )
            } else {
              switch(input$amn_method_screening,
                "yes" = {
                  data() |>
                    dplyr::mutate(muac = recode_muac(muac, "mm")) |>
                    mw_estimate_prevalence_screening(
                      muac = !!rlang::sym(input$muac)
                    )
                },
                "no" = {
                  data() |>
                    dplyr::mutate(muac = recode_muac(muac, "mm")) |>
                    mw_estimate_prevalence_screening2(
                      age_cat = !!rlang::sym(input$age_cat),
                      muac = !!rlang::sym(input$muac)
                    )
                }
              )
            }
            
            # Store the result
            prevalence$estimated <- p
          },
          error = function(e) {
            shiny::showNotification(
              ui = paste("Error while estimating:", e$message), type = "error"
            )
          }
        )

        prevalence$estimating <- FALSE
      })

      ### Render results into UI ----
      output$results <- DT::renderDT({
        #### Ensure checked output is available ----
        shiny::req(prevalence$estimated)
        DT::datatable(
          prevalence$estimated,
          options = list(
            pageLength = 10,
            scrollX = TRUE,
            scrollY = "800px",
            columnDefs = list(list(className = "dt-center", targets = "_all"))
          ),
          caption = if (nrow(prevalence$estimated) > 30) {
            paste(
              "Showing first 30 rows of", format(nrow(prevalence$estimated), big.mark = "."),
              "total rows"
            )
          } else {
            paste("Showing all", nrow(prevalence$estimated), "rows")
          }
        ) |> DT::formatStyle(columns = colnames(prevalence$estimated), fontSize = "15px")
      })
    }
  )
}


## ---- Module helper functions ------------------------------------------------

#'
#'
#'
#' @keywords internal
#'
#'
display_input_variables_survey <- function(vars, ns) {
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
#' @keywords internal
#'
#'
display_input_variables_screening <- function(vars, ns) {
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
#'
#'
#'
#'
run_mwana_prevalence_functions_wfhz <- function(
    df, wts = NULL, oedema = NULL,
    area1, area2, area3) {
  if (all(nzchar(c(area1, area2, area3)))) {
    if ((nzchar(wts) && nzchar(oedema))) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = !!rlang::sym(wts),
        oedema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else if (!nzchar(wts) && nzchar(oedema)) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = NULL,
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    } else if (nzchar(wts)  && !nzchar(oedema)) {
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
        oedema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    }
  } else if (nzchar(area2) && !nzchar(area3)) {
    if (all(sapply(c(wts, oedema), !nzchar))) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = !!rlang::sym(wts),
        oedema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else if (!nzchar(wts) && nzchar(oedema)) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = NULL,
        oedema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else if (nzchar(wts) && !nzchar(oedema)){
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = !!rlang::sym(wts),
        oedema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = NULL,
        oedema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2), !!rlang::sym(area3)
      )
    }
  } else {
    if (all(sapply(c(wts, oedema), !nzchar))) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = !!rlang::sym(wts),
        oedema = !!rlang::sym(oedema),
        !!rlang::sym(area1)
      )
    } else if (!nzchar(wts) && nzchar(oedema)) {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = NULL,
        oedema = !!rlang::sym(oedema),
        !!rlang::sym(area1)
      )
    } else if (nzchar(wts) && !nzchar(oedema)){
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = !!rlang::sym(wts),
        oedema = NULL,
        !!rlang::sym(area1)
      )
    } else {
      mw_estimate_prevalence_wfhz(
        df = df,
        wt = NULL,
        oedema = NULL,
        !!rlang::sym(area1)
      )
    }
  }
}
