
## ---- Module: UI -------------------------------------------------------------

#'
#' 
#' Module UI for IPC Acute Malnutrition sample size requirements check
#' 
#' @param id Module ID
#'
#' @keywords internal
#' 
#' 
#' 
module_ui_ipccheck <- function(id) {
  ## Namespace ID ----
  ns <- shiny::NS(id)

  ## UI elements ----
  shiny::tagList(
    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
        width = 400,
        bslib::card(
          bslib::card_header(htmltools::tags$span("Define Parameters for Check",
        style = "font-weight: 600;")),
          style = "width: 350px",

           #### Display options on source of data ----
          shiny::radioButtons(
            inputId = ns("ipccheck"),
            label = htmltools::tags$span(
              "Select data source", style = "font-size: 16px; font-weight: 500;"
            ),
            choices = list(
              "Survey" = "survey",
              "Screening" = "screening",
              "Sentinel site" = "sentinel"
            ),
            selected = "survey"
          ),

           #### Display data wrangling method options from the server ----
          shiny::uiOutput(ns("data_source")),
          htmltools::tags$br(),
          shiny::actionButton(
            inputId = ns("apply_check"),
            label = "Apply Check",
            class = "btn-primary"
          )
        )
      ),

      ### Add main content area for results
      bslib::card(
        bslib::card_header(htmltools::tags$span("IPC Check Results",
      style = "font-weight: 600;")),

      #### Display variable inputs rendered from the server ----
        shinycssloaders::withSpinner(
          ui_element = DT::DTOutput(ns("checked")),
          type = 8,
          color.background = "#004225",
          image = "logo.png",
          image.height = "50px",
          color = "#004225",
          caption = htmltools::tags$div(
            htmltools::tags$h6("Checking"), htmltools::tags$h6("Please wait...")
          )
        ),

        #### Placeholder for donwload button ----
        shiny::uiOutput(outputId = ns("download_ipccheck"))
      )
    )
  )
}


## ---- Module: Sever ----------------------------------------------------------

#'
#' 
#' Module server for IPC Acute Malnutrition sample size requirements check
#' 
#' @param id Module ID
#' 
#'
#' @keywords internal
#' 
#' 
#' 
module_server_ipccheck <- function(id, data) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    dataset <- shiny::reactiveValues(
      checked = NULL
    )

    ### Create a reactive that explicitly depends on both inputs ----
    ui_inputs <- shiny::reactive({
      shiny::req(data(), input$ipccheck)

      cols <- base::names(data())

      switch(input$ipccheck,

        #### Survey ----
        ##### Screening sites: mandatory ----
        "survey" = list(
          shiny::selectInput(ns("area1"), 
          label = shiny::tagList("Area 1", 
          htmltools::tags$span("*", style = "color: red;"),
          htmltools::tags$div(
              style = "font-size: 0.85em; color: #6c7574;", "(Primary area)")
          ), 
          choices = c("", cols)
        ),

         ##### Secondary grouping area: optional ----
          shiny::selectInput(ns("area2"), 
          label = shiny::tagList("Area 2", htmltools::tags$div(
              style = "font-size: 0.85em; color: #6c7574;" ,"(Sub-area)")
          ),
          choices = c("", cols)
        ),

         ##### Survey clusters: mandatory ----
          shiny::selectInput(
            inputId = ns("psu"), 
            label = shiny::tagList(
              "Survey clusters",
              htmltools::tags$span("*", style = "color: red;"),
          ), 
          choices = c("", cols))
        ),

        #### Screening ----
        ##### Primary grouping area: mandatory ----
        "screening" = list(
          shiny::selectInput(ns("area1"), 
          label = shiny::tagList("Area 1", 
          htmltools::tags$span("*", style = "color: red;"),
          htmltools::tags$div(
              style = "font-size: 0.85em; color: #6c7574;", "(Primary area)")
          ), 
          choices = c("", cols)),

          ##### Secondary grouping area: optional ----
          shiny::selectInput(
            inputId = ns("area2"), 
          label = shiny::tagList(
            "Area 2", htmltools::tags$div(
              style = "font-size: 0.85em; color: #6c7574;" ,"(Sub-area)")
          ),
          choices = c("", cols)
        ),

         ##### Screening sites: mandatory ----
          shiny::selectInput(
            inputId = ns("sites"), 
            label = shiny::tagList(
              "Screening sites", htmltools::tags$span("*", style = "color: red;"),
            ), 
            choices = c("", cols)
          )
        ),

        #### Sentinel sites ----
        ##### Primary grouping area: mandatory ----
        "sentinel" = list(
          shiny::selectInput(ns("area1"), 
          label = shiny::tagList("Area 1", 
          htmltools::tags$span("*", style = "color: red;"),
          htmltools::tags$div(
              style = "font-size: 0.85em; color: #6c7574;", "(Primary area)")
          ), 
          choices = c("", cols)
        ),

        ##### Secondary grouping area: optional ----
          shiny::selectInput(ns("area2"), 
          label = shiny::tagList("Area 2", htmltools::tags$div(
              style = "font-size: 0.85em; color: #6c7574;" ,"(Sub-area)")
          ),
          choices = c("", cols)
        ),

        ##### Sentinel sites: mandatory ----
          shiny::selectInput(
           inputId = ns("ssites"), 
           label = shiny::tagList("Sentinel sites", 
           htmltools::tags$span("*", style = "color: red;")
          ),
           choices = c("", cols)
          )
        )
      )
    })

    output$data_source <- shiny::renderUI({
      do.call(shiny::tagList, ui_inputs())
    })

    dataset$checking <- shiny::reactiveVal(FALSE)

    shiny::observeEvent(input$apply_check, {
      shiny::req(data())
      dataset$checking(TRUE)

      valid <- TRUE
      message <- ""

      if (input$ipccheck == "survey") {
        if (is.null(input$area1) || is.null(input$psu) || input$area1 == "" || input$psu == "") {
          valid <- FALSE
          message <- "Please select all required variables."
        }
      } else if (input$ipccheck == "screening") {
        if (is.null(input$area1) || is.null(input$sites) || input$area1 == "" || input$sites == "") {
          valid <- FALSE
          message <- "Please select all required variables."
        }
      } else if (input$ipccheck == "sentinel") {
        if (is.null(input$area1) || is.null(input$ssites) || input$area1 == "" || input$ssites == "") {
          valid <- FALSE
          message <- "Please select all required variables."
        }
      }

      if (!valid) {
        shiny::showNotification(message, type = "error")
        dataset$checking(FALSE)
        return()
      }

      ### If validation passes, perform your check logic ----
      tryCatch(
        {
          x <- switch(input$ipccheck,
            "survey" = {
              #### Required variables. Area2 is optional ----
              shiny::req(input$area1, input$psu)

              #### Check if minimum sample size requirements for survey are met ----
              mod_call_ipcamn_checker(
                data(), input$psu, "survey", input$area1, input$area2
              )
            },
            "screening" = {
              #### Required variables. Area2 is optional ----
              shiny::req(input$area1, input$sites)

              #### Check if minimum sample size requirements for screening are met ----
              mod_call_ipcamn_checker(
                data(), input$sites, "screening", input$area1, input$area2
              )
            },
            "sentinel" = {
              #### Required variables. Area2 is optional ----
              shiny::req(input$area1, input$ssites)

              #### Check if minimum sample size requirements for sentinel sites are met ----
              mod_call_ipcamn_checker(
                data(), input$ssites, "ssite", input$area1, input$area2
              )
            }
          )

          dataset$checked <- x
        },
        error = function(e) {
          shiny::showNotification(paste("Error during check: ", e$message), type = "error")
        }
      )
      dataset$checking(FALSE)
    })

    ### Render results into UI ----
    output$checked <- DT::renderDT({
      #### Ensure checked output is available ----
      shiny::req(dataset$checked)
      DT::datatable(
        dataset$checked,
        options = list(
          pageLength = 10,
          scrollX = TRUE,
          scrollY = "800px", 
          columDefs = list(list(className = "dt-center", targets = "_all"))
        ),
        caption = if (nrow(dataset$checked) > 30) {
          paste(
            "Showing first 30 rows of", format(nrow(dataset$checked), big.mark = "."),
            "total rows"
          )
        } else {
          paste("Showing all", nrow(dataset$checked), "rows")
        }
      ) |> DT::formatStyle(columns = colnames(dataset$checked), fontSize = "15px")
    })

    #### Download button to download table of detected clusters in .xlsx ----
    ##### Output into the UI ----
    output$download_ipccheck <- shiny::renderUI({
      shiny::req(dataset$checked)
      shiny::req(!dataset$checking())
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
        if (input$ipccheck == "survey") {
          paste0("mwana-ipc-check-for-survey_", Sys.Date(), ".xlsx", sep = "")
        } else if (input$ipccheck == "screening") {
          paste0("mwana-ipc-check-for-screening_", Sys.Date(), ".xlsx", sep = "")
        } else {
          paste0("mwana-ipc-check-for-sentinel-site_", Sys.Date(), ".xlsx", sep = "")
        }
      },
      content = function(file) {
        shiny::req(dataset$checked) # Ensure results exist
        tryCatch(
          {
            openxlsx::write.xlsx(dataset$checked, file)
            shiny::showNotification("File downloaded successfully! 🎉 ", type = "message")
          },
          error = function(e) {
            shiny::showNotification(paste("Error creating file:", e$message), type = "error")
          }
        )
      }
    )
  })
}
