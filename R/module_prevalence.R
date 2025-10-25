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
          inputId = ns("estimate"),
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
      shiny::uiOutput(outputId = ns("download_prevalence"))
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
      shiny::observeEvent(input$estimate, {
        ### Ensure input data exists ----
        shiny::req(data())
        prevalence$estimating <- TRUE

        ### Handle errors gracefully ----
        valid <- TRUE
        message <- ""

        if (input$amn_method_screening == "yes") {
        if (!nzchar(input$muac)) {
          valid <- FALSE
          message <- "Please supply MUAC variable."
        }
        } else {
          if (any(!nzchar(c(input$muac, input$age_cat)))) {
            valid <- FALSE
            message <- "Please select all required variables: MUAC and Age category."
          }
        }

        if (!valid) {
          shiny::showNotification(message, type = "error")
          prevalence$estimating <- FALSE
          return()
        }

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
                    run_mwana_prevalence_functions_muac(
                      wts = input$wts,
                      oedema = input$oedema,
                      area1 = input$area1,
                      area2 = input$area2,
                      area3 = input$area3
                    )
                },
                "combined" = {
                  data() |>
                    dplyr::mutate(muac = recode_muac(muac, "mm")) |>
                    run_mwana_prevalence_functions_combined(
                      wts = input$wts,
                      oedema = input$oedema,
                      area1 = input$area1,
                      area2 = input$area2,
                      area3 = input$area3
                    )
                }
              )
            } else {
              switch(input$amn_method_screening,
                "yes" = {
                  shiny::req(input$muac)

                  data() |>
                    dplyr::mutate(muac = recode_muac(muac, "mm")) |>
                    run_mwana_prevalence_muac_screening(
                      muac = input$muac,
                      oedema = input$oedema,
                      area1 = input$area1,
                      area2 = input$area2,
                      area3 = input$area3
                    )
                },
                "no" = {
                  shiny::req(input$muac, input$age_cat)

                  data() |>
                    dplyr::mutate(muac = recode_muac(muac, "mm")) |>
                    run_mwana_prevalence_muac_screening2(
                      age_cat = input$age_cat,
                      muac = input$muac,
                      oedema = input$oedema,
                      area1 = input$area1,
                      area2 = input$area2,
                      area3 = input$area3
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


      #### Download button to download table of detected clusters in .xlsx ----
      ##### Output into the UI ----
      output$download_prevalence <- shiny::renderUI({
        shiny::req(prevalence$estimated)
        prevalence$estimating <- FALSE
        htmltools::tags$div(
          style = "margin-bottom: 15px; text-align: right;",
          shiny::downloadButton(
            outputId = ns("download_results"),
            label = "Download Results",
            class = "btn-primary",
            icon = shiny::icon(name = "download", class = "fa-lg")
          )
        )
      })


      ##### Downloadable results by clicking on the download button ----
      output$download_results <- shiny::downloadHandler(
        filename = function() {
          if (input$source == "survey") {
            if (input$amn_method_survey == "wfhz") {
              paste0("mwana-amn-prevalence-survey-wfhz_", Sys.Date(), ".xlsx", sep = "")
            } else if (input$amn_method_survey == "muac") {
              paste0("mwana-amn-prevalence-survey-muac_", Sys.Date(), ".xlsx", sep = "")
            } else {
              paste0("mwana-amn-prevalence-survey-combined_", Sys.Date(), ".xlsx", sep = "")
            }
          } else {
            if (input$amn_method_screening == "yes") {
              paste0("mwana-amn-prevalence-screening-age-avail_", Sys.Date(), ".xlsx", sep = "")
            } else {
              paste0("mwana-amn-prevalence-screening-age-notavail_", Sys.Date(), ".xlsx", sep = "")
            }
          }
        },
        content <- function(file) {
          shiny::req(prevalence$estimated) # Ensure results exist
          tryCatch(
            {
              openxlsx::write.xlsx(prevalence$estimated, file)
              shiny::showNotification("File downloaded successfully! 🎉 ", type = "message")
            },
            error = function(e) {
              shiny::showNotification(paste("Error creating file:", e$message), type = "error")
            }
          )
        }
      )
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
#'
#'
#'
run_mwana_prevalence_functions_muac <- function(
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
#'
#'
#'
run_mwana_prevalence_functions_combined <- function(
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
#'
#'
#'
run_mwana_prevalence_muac_screening <- function(
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



run_mwana_prevalence_muac_screening2 <- function(
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
      mw_estimate_prevalence_screening(
        df = df,
        age_cat = !!rlang::sym(age_cat),
        muac = !!rlang::sym(muac),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else {
      mw_estimate_prevalence_screening(
        df = df,
        age_cat = !!rlang::sym(age_cat),
        muac = !!rlang::sym(muac),
        edema = NULL,
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    }
  } else {
    if (nzchar(oedema)) {
      mw_estimate_prevalence_screening(
        df = df,
        age_cat = !!rlang::sym(age_cat),
        muac = !!rlang::sym(muac),
        edema = !!rlang::sym(oedema),
        !!rlang::sym(area1)
      )
    } else {
      mw_estimate_prevalence_screening(
        df = df,
        age_cat = !!rlang::sym(age_cat),
        muac = !!rlang::sym(muac),
        edema = NULL,
        !!rlang::sym(area1)
      )
    }
  }
}
