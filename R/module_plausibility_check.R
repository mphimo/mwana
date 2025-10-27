## ---- Module: UI -------------------------------------------------------------

#'
#'
#' @keywords internal
#'
#'
module_ui_plausibility_check <- function(id) {
  ## Namespace ID ----
  ns <- shiny::NS(id)

  bslib::layout_sidebar(
    sidebar = bslib::sidebar(
      width = 400,

      ### Left side of the nav panel: Parameters setup ----
      bslib::card(
        bslib::card_header(htmltools::tags$span(
          "Define Parameters for Plausibility Check",
          style = "font-weight: 600;"
        )),
        style = "width: 350px;",

        #### Enable plausibility check options based on data wrangling method ----

        shiny::radioButtons(
          inputId = ns("method"),
          label = "Select Method",
          choices = list(
            "Weight-for-Height z-scores (WFHZ)" = "wfhz",
            "MUAC-for-Age z-scores (MFAZ)" = "mfaz",
            "Raw MUAC" = "muac"
          ),
          selected = "wfhz"
        ),
        shiny::uiOutput(outputId = ns("check_vars")),
        htmltools::tags$br(),
        shiny::actionButton(
          inputId = ns("check"),
          label = "Check Plausibility",
          class = "btn-primary"
        )
      )
    ),

    ### Right side of the nav panel: Plausibility check results ----
    bslib::card(
      bslib::card_header(htmltools::tags$span("Plausibility Check Results",
        style = "font-weight: 600;"
      )),
      shinycssloaders::withSpinner(
        ui_element = DT::DTOutput(outputId = ns("checked")),
        type = 8,
        color.background = "#004225",
        image = "logo.png",
        image.height = "50px",
        color = "#004225",
        caption = htmltools::tags$div(
          htmltools::tags$h6("Checking plausibility"), htmltools::tags$h6("Please wait...")
        )
      ),
      shiny::uiOutput(outputId = ns("download_plausibility"))
    )
  )
}


## ---- Module: Server ---------------------------------------------------------


#'
#'
#'
#' @keywords internal
#' 
#'
module_server_plausibility_check <- function(id, data) {
  shiny::moduleServer(
    id,
    module = function(input, output, session) {
      ns <- session$ns

      ### Capture reactivity ----
      plausibility <- shiny::reactiveValues(checked = NULL)

      ### Render variables on the basis of user-defined wrangling method ----
      output$check_vars <- shiny::renderUI({
        #### Ensure data exists ----
        shiny::req(data())

        #### Get variable names to be displayed ----
        vars <- base::names(data())

        #### Dynamically inputs based on user-defined plausibility method ----
        if (input$method == "wfhz") {
          ##### WFHZ ----
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
              inputId = ns("sex"),
              label = shiny::tagList(
                "Sex",
                htmltools::tags$span("*", style = "color: red;")
              ),
              choices = c("", vars)
            ),
            shiny::selectInput(
              inputId = ns("age"),
              label = shiny::tagList(
                "Age (months)",
                htmltools::tags$span("*", style = "color: red;")
              ),
              choices = c("", vars)
            ),
            shiny::selectInput(
              inputId = ns("weight"),
              label = shiny::tagList(
                "Weight (kg)",
                htmltools::tags$span("*", style = "color: red;")
              ),
              choices = c("", vars)
            ),
            shiny::selectInput(
              inputId = ns("height"),
              label = shiny::tagList(
                "Height (cm)",
                htmltools::tags$span("*", style = "color: red;")
              ),
              choices = c("", vars)
            ),
            shiny::selectInput(
              inputId = ns("flags"),
              label = shiny::tagList(
                "Flags",
                htmltools::tags$span("*", style = "color: red;")
              ),
              choices = c("", vars)
            )
          )
        } else if (input$method == "mfaz") {
          ##### MFAZ ----
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
              inputId = ns("sex"),
              label = shiny::tagList(
                "Sex",
                htmltools::tags$span("*", style = "color: red;")
              ),
              choices = c("", vars)
            ),
            shiny::selectInput(
              inputId = ns("age"),
              label = shiny::tagList(
                "Age (months)",
                htmltools::tags$span("*", style = "color: red;")
              ),
              choices = c("", vars)
            ),
            shiny::selectInput(
              inputId = ns("muac"),
              label = shiny::tagList(
                "MUAC (cm)",
                htmltools::tags$span("*", style = "color: red;")
              ),
              choices = c("", vars)
            ),
            shiny::selectInput(
              inputId = ns("flags"),
              label = shiny::tagList(
                "Flags",
                htmltools::tags$span("*", style = "color: red;")
              ),
              choices = c("", vars)
            )
          )
        } else {
          ##### Raw MUAC ----
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
              inputId = ns("sex"),
              label = shiny::tagList(
                "Sex",
                htmltools::tags$span("*", style = "color: red;")
              ),
              choices = c("", vars)
            ),
            shiny::selectInput(
              inputId = ns("muac"),
              label = shiny::tagList(
                "MUAC (cm)",
                htmltools::tags$span("*", style = "color: red;")
              ),
              choices = c("", vars)
            ),
            shiny::selectInput(
              inputId = ns("flags"),
              label = shiny::tagList(
                "Flags",
                htmltools::tags$span("*", style = "color: red;")
              ),
              choices = c("", vars)
            )
          )
        }
      })


      ### Create container for reactivity ----
      plausibility$checking <- shiny::reactiveVal(FALSE)

      shiny::observeEvent(input$check, {
        shiny::req(data())
        plausibility$checking(TRUE)

        #### Handle errors gracefully ----
        valid <- TRUE
        message <- ""

        if (input$method == "wfhz") {
          required_vars <- c(input$sex, input$weight, input$height, input$age, input$flags)
          if (any(required_vars == "" | is.null(required_vars))) {
            valid <- FALSE
            message <- "Please select all required variables."
          }
        } else if (input$method == "mfaz") {
          required_vars <- c(input$age, input$sex, input$muac, input$flags)
          if (any(required_vars == "" | is.null(required_vars))) {
            valid <- FALSE
            message <- "Please select all required variables."
          }
        } else if (input$method == "muac") {
          required_vars <- c(input$sex, input$muac, input$flags)
          if (any(required_vars == "" | is.null(required_vars))) {
            valid <- FALSE
            message <- "Please select all required variables."
          }
        } else {
          valid <- FALSE
          message <- "Please select a method first."
        }

        if (!valid) {
          shiny::showNotification(message, type = "error")
          plausibility$checking(FALSE)
          return()
        }

        tryCatch(
          expr = {
            w <- switch(EXPR = input$method,

              ##### Run plausibility check for WFHZ ----
              "wfhz" = {
                shiny::req(
                  input$sex, input$weight, input$height, input$age, input$flags
                )
                ##### Run plausibility check ----
                mod_call_plausibility_checkers(
                  df = data(),
                  .for = "wfhz",
                  sex = input$sex,
                  age = input$age,
                  height = input$height,
                  weight = input$weight,
                  flags = input$flags,
                  area1 = input$area1,
                  area2 = input$area2,
                  area3 = input$area3
                )
              },
              ##### Run plausibility check for MFAZ ----
              "mfaz" = {
                shiny::req(input$age, input$sex, input$muac, input$flags)

                mod_call_plausibility_checkers(
                  df = data(),
                  .for = "mfaz",
                  sex = input$sex,
                  age = input$age,
                  muac = input$muac,
                  flags = input$flags,
                  area1 = input$area1,
                  area2 = input$area2,
                  area3 = input$area3
                )
              },

              ##### Run plausibility check for MUAC ----
              "muac" = {
                shiny::req(input$sex, input$muac, input$flags)

                mod_call_plausibility_checkers(
                  df = data(),
                  .for = "muac",
                  sex = input$sex,
                  muac = input$muac,
                  flags = input$flags,
                  area1 = input$area1,
                  area2 = input$area2,
                  area3 = input$area3
                )
              }
            )

            plausibility$checked <- w
          },
          error = function(e) {
            shiny::showNotification(paste("Checking error:", e$message), type = "error")
          }
        )

        plausibility$checking(FALSE)
      })

      ### Render results into UI ----
      output$checked <- DT::renderDT({
        #### Ensure checked output is available ----
        shiny::req(plausibility$checked)
        DT::datatable(
          plausibility$checked,
          options = list(
            pageLength = 10,
            scrollX = TRUE,
            scrollY = "800px",
            columnDefs = list(list(className = "dt-center", targets = "_all"))
          ),
          caption = if (nrow(plausibility$checked) > 30) {
            paste(
              "Showing first 30 rows of", format(nrow(plausibility$checked), big.mark = "."),
              "total rows"
            )
          } else {
            paste("Showing all", nrow(plausibility$checked), "rows")
          }
        ) |> DT::formatStyle(columns = colnames(plausibility$checked), fontSize = "15px")
      })

      #### Download button to download table of detected clusters in .xlsx ----
      ##### Output into the UI ----
      output$download_plausibility <- shiny::renderUI({
        shiny::req(plausibility$checked)
        shiny::req(!plausibility$checking())
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
          if (input$method == "wfhz") {
            paste0("mwana-plausibility-check-wfhz_", Sys.Date(), ".xlsx", sep = "")
          } else if (input$method == "mfaz") {
            paste0("mwana-plausibility-check-mfaz_", Sys.Date(), ".xlsx", sep = "")
          } else {
            paste0("mwana-plausibility-check-muac_", Sys.Date(), ".xlsx", sep = "")
          }
        },
        content = function(file) {
          shiny::req(plausibility$checked) # Ensure results exist
          tryCatch(
            {
              openxlsx::write.xlsx(plausibility$checked, file)
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
