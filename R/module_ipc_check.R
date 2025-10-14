#'
#' 
#' 
#' 
#' @keywords internal
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
          style = "width: 350px",
          shiny::radioButtons(
            inputId = ns("ipccheck"),
            label = htmltools::tags$strong("Select the data source"),
            choices = list(
              "Survey" = "survey", 
              "Screening" = "screening",
              "Sentinel site" = "sentinel"
            ),
            selected = "survey"
          ),
          shiny::uiOutput(ns("data_source")),
          htmltools::tags$br(),
          shiny::actionButton(
            inputId = ns("apply_check"),
            label = "Apply Check",
            class = "btn-primary"
          )
        )
      ),
      # Add main content area for results
      bslib::card(
        bslib::card_header("IPC Check Results"),
        shinycssloaders::withSpinner(
          ui_element = DT::DTOutput(ns("checked")),
          type = 8,
          color.background = "#004225",
          image = "logo.png",
          image.height = "50px",
          color = "#004225",
          caption = htmltools::tags$div("Checking", htmltools::tags$br(), htmltools::tags$h5("Please wait..."))
        ), 
        shiny::uiOutput(outputId = ns("download_ipccheck"))
      )
    )
  )
}

#'
#' 
#' 
#' 
#' @keywords internal
#' 
module_server_ipccheck <- function(id, data) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    values <- reactiveValues(
      checked = NULL
    )

    # Use the reactive data properly
    current_data <- reactive({
      req(data())
      data()
    })

    # Create a reactive that explicitly depends on both inputs
    ui_inputs <- reactive({
      req(current_data(), input$ipccheck)
      
      cols <- names(current_data())
      
      switch(input$ipccheck,
        "survey" = list(
          shiny::selectInput(ns("area1"), "Unit of analysis", c("", cols)),
          shiny::selectInput(ns("area2"), "Unit of analysis (optional)", c("", cols)),
          shiny::selectInput(ns("psu"), "Primary sampling units", c("", cols))
        ),
        "screening" = list(
          shiny::selectInput(ns("area1"), "Unit of analysis", c("", cols)),
          shiny::selectInput(ns("area2"), "Unit of analysis (optional)", c("", cols)),
          shiny::selectInput(ns("sites"), "Screening sites", c("", cols))
        ),
        "sentinel" = list(
          shiny::selectInput(ns("area1"), "Unit of analysis", c("", cols)),
          shiny::selectInput(ns("area2"), "Unit of analysis (optional)", c("", cols)),
          shiny::selectInput(ns("ssites"), "Sentinel sites", c("", cols))
        )
      )
    })

    output$data_source <- renderUI({
      do.call(shiny::tagList, ui_inputs())
    })

    values$checking <- reactiveVal(FALSE)

    observeEvent(input$apply_check, {
      req(current_data())
      values$checking(TRUE)
      
      valid <- TRUE
      message <- ""
      
      if (input$ipccheck == "survey") {
        if (is.null(input$area1) || is.null(input$psu) || input$area1 == "" || input$psu == "") {
          valid <- FALSE
          message <- "😬 Please select all required variables (Location and clusters) and try again."
        }
      } else if (input$ipccheck == "screening") {
        if (is.null(input$area1) || is.null(input$sites) || input$area1 == "" || input$sites == "") {
          valid <- FALSE
          message <- "😬 Please select all required variables (Location and screening sites) and try again."
        }
      } else if (input$ipccheck == "sentinel") {
        if (is.null(input$area1) || is.null(input$ssites) || input$area1 == "" || input$ssites == "") {
          valid <- FALSE
          message <- "😬 Please select all required variables (Location and sentinel sites) and try again."
        }
      }

      if (!valid) {
        shiny::showNotification(message, type = "error")
        values$checking(FALSE)
        return()
      }
      
      ### If validation passes, perform your check logic ----
      tryCatch(
      {
        x <- switch(input$ipccheck,
        "survey" = {
          #### Required variables. Area2 is optional ----
          req(input$area1, input$psu)

            mw_check_ipcamn_ssreq(
          df = current_data(),
              cluster = !!rlang::sym(input$psu),
              .source = "survey",
              !!rlang::sym(input$area1), if (input$area2 != "") !!rlang::sym(input$area2) else NULL
            )
        }, 
        "screening" = {
                    #### Required variables. Area2 is optional ----
          req(input$area1, input$sites)
            mw_check_ipcamn_ssreq(
          df = current_data(),
              cluster = !!rlang::sym(input$sites),
              .source = "screening",
              !!rlang::sym(input$area1), if (input$area2 != "") !!rlang::sym(input$area2) else NULL
            )
        },
        "sentinel" = {
                    #### Required variables. Area2 is optional ----
          req(input$area1, input$ssites)
            mw_check_ipcamn_ssreq(
          df = current_data(),
              cluster = !!rlang::sym(input$ssites),
              .source = "ssite",
              !!rlang::sym(input$area1), if (input$area2 != "") !!rlang::sym(input$area2) else NULL
            )
        }
        )

        values$checked <- x
      },

      error = function(e) {
        showNotification(paste("Error during check: ", e$message), type = "error")
      }
    )
      values$checking(FALSE)
    })

    output$checked <- DT::renderDT({
      req(values$checked)
      
      DT::datatable(
        values$checked,
        options = list(
          pageLength = 10,
          scrollX = TRUE,
          scrollY = "400px"
        )
      )
    })

    #### Download button to download table of detected clusters in .xlsx ----
  ##### Output into the UI ----
  output$"download_ipccheck" <- renderUI({
    req(values$checked)
    req(!values$checking())
    div(
      style = "margin-bottom: 15px; text-align: right;",
      downloadButton(
        outputId = ns("download_results"),
        label = "Download Results",
        class = "btn-primary",
        icon = icon(name = "download", class = "fa-lg")
      )
    )
  })

  ##### Downloadable results by clicking on the download button ----
  output$download_results <- downloadHandler(
    filename = function() {
      if (input$ipccheck == "survey") {
              paste0("ipc-check-for-survey_", Sys.Date(), ".xlsx", sep = "")
      } else if (input$ipccheck == "screening") {
        paste0("ipc-check-for-screening_", Sys.Date(), ".xlsx", sep = "")
      } else{
        paste0("ipc-check-for-sentinel-site_", Sys.Date(), ".xlsx", sep = "")
      }
    },
    content = function(file) {
      req(values$checked) # Ensure results exist
      tryCatch(
        {
          openxlsx::write.xlsx(values$checked, file)
          showNotification("File downloaded successfully! 🎉 ", type = "message")
        },
        error = function(e) {
          showNotification(paste("Error creating file:", e$message), type = "error")
        }
      )
    }
    )
    
})
}