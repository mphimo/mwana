## ---- Module: UI -------------------------------------------------------------

#'
#'
#' Module UI for prevalence analysis
#'
#' @param id Module ID
#'
#' @keywords internal
#'
#'
#'
module_ui_prevalence <- function(id) {
  ## Namespace ID ----
  ns <- shiny::NS(id)

  bslib::layout_sidebar(
    sidebar = bslib::sidebar(
      width = 400,
      position = "left",
      style = "width: 350px",

      ### Left side of the navbar ----
      bslib::card(
        style = "background-color: #f9fdfb;",
        style = "width: 350px;",
        bslib::card_header(
          htmltools::tags$span("Define Analysis Parameters",
            style = "font-size: 15px; font-weight: bold;"
          )
        ),

        #### Select the source of data for prevalence analysis ----
        shiny::radioButtons(
          inputId = ns("source"),
          label = htmltools::tags$span("Select Data Source",
            style = "font-size: 14px; font-weight: bold;"
          ),
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
      style = "background-color: #f9fdfb;",
      bslib::card_header(
        htmltools::tags$span("Prevalence Analysis Results",
          style = "font-size: 15px; font-weight: bold;"
        )
      ),

      #### A Placehoder for wrangled data and embed user feedback ----
      shinycssloaders::withSpinner(
        ui_element = DT::DTOutput(outputId = ns("results")),
        type = 8,
        color.background = "#004225",
        image = "logo.png",
        image.height = "50px",
        color = "#004225",
        caption = htmltools::tags$div(
          htmltools::tags$h6(htmltools::tags$span("Estimating prevalence",
            style = "font-size: 12px;"
          )),
          htmltools::tags$h6(htmltools::tags$span("Please wait...",
            style = "font-size: 12px;"
          ))
        )
      ),

      #### Placeholder for donwload button ----
      shiny::uiOutput(outputId = ns("download_prevalence"))
    )
  )
}


## ---- Module: Server ---------------------------------------------------------

#'
#'
#' Module server for prevalence analysis
#'
#' @param id Module ID
#'
#' @keywords internal
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
              label = htmltools::tags$span("Acute malnutrition based on:",
                style = "font-size: 14px; font-weight: bold;"
              ),
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
              label = htmltools::tags$span("Is age in months available?",
                style = "font-size: 14px; font-weight: bold;"
              ),
              choices = list("Yes" = "yes", "No" = "no"),
              selected = "yes",
              inline = TRUE
            )
          }
        )
      })

      ### Render input variables ----
      output$amn_vars <- shiny::renderUI({
        shiny::req(data())
        vars <- names(data())

        mod_prevalence_display_input_variables(
          vars = vars, source = input$source, ns = ns
        )
      })

      ### Always observe Action button, but branch inside ----
      shiny::observeEvent(input$estimate, {
        ### Ensure input data exists ----
        shiny::req(data())
        prevalence$estimating <- TRUE

        ### Handle errors gracefully ----
        valid <- TRUE
        message <- ""

        if (input$source == "screening") {
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
                  mod_prevalence_call_wfhz_prev_estimator(
                    df = data(),
                    wts = input$wts,
                    oedema = input$oedema,
                    area1 = input$area1,
                    area2 = input$area2,
                    area3 = input$area3
                  ) |> mod_prevalence_neat_output_survey(.type = "wfhz")
                },
                "muac" = {
                  data() |>
                    dplyr::mutate(muac = recode_muac(.data$muac, "mm")) |>
                    mod_prevalence_call_muac_prev_estimator(
                      wts = input$wts,
                      oedema = input$oedema,
                      area1 = input$area1,
                      area2 = input$area2,
                      area3 = input$area3
                    ) |>
                    mod_prevalence_neat_output_survey(.type = "muac")
                },
                "combined" = {
                  data() |>
                    dplyr::mutate(muac = recode_muac(.data$muac, "mm")) |>
                    mod_prevalence_call_combined_prev_estimator(
                      wts = input$wts,
                      oedema = input$oedema,
                      area1 = input$area1,
                      area2 = input$area2,
                      area3 = input$area3
                    ) |>
                    mod_prevalence_neat_output_survey(.type = "combined")
                }
              )
            } else {
              switch(input$amn_method_screening,
                "yes" = {
                  shiny::req(input$muac)

                  data() |>
                    dplyr::mutate(muac = recode_muac(.data$muac, "mm")) |>
                    mod_prevalence_call_prev_estimator_screening(
                      muac = input$muac,
                      oedema = input$oedema,
                      area1 = input$area1,
                      area2 = input$area2,
                      area3 = input$area3
                    ) |>
                    mod_prevalence_neat_output_screening()
                },
                "no" = {
                  shiny::req(input$muac, input$age_cat)

                  data() |>
                    mod_prevalence_call_prev_estimator_screening2(
                      age_cat = input$age_cat,
                      muac = input$muac,
                      oedema = input$oedema,
                      area1 = input$area1,
                      area2 = input$area2,
                      area3 = input$area3
                    ) |>
                    mod_prevalence_neat_output_screening()
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
          utils::head(prevalence$estimated, 20),
          rownames = FALSE,
          options = list(
            pageLength = 20,
            scrollX = FALSE,
            scrollY = "800px",
            columnDefs = list(list(className = "dt-center", targets = "_all"))
          ),
          caption = if (nrow(prevalence$estimated) > 20) {
            paste(
              "Showing first 20 rows of", format(nrow(prevalence$estimated), big.mark = "."),
              "total rows"
            )
          } else {
            paste("Showing all", nrow(prevalence$estimated), "rows")
          }
        ) |> DT::formatStyle(columns = colnames(prevalence$estimated), fontSize = "13px")
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
              shiny::showNotification("File downloaded successfully!", type = "message")
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
