
## ---- Module: UI -------------------------------------------------------------

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
          bslib::card_header(htmltools::tags$span("Define Analysis Parameters",
        style = "font-weight: 600;")),
          style = "width: 350px",
          shiny::radioButtons(
            inputId = ns("ipccheck"),
            label = htmltools::tags$span("Select data source", style = "font-size: 16px; font-weight: 500;"),
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
        bslib::card_header(htmltools::tags$span("IPC Check Results",
      style = "font-weight: 600;")),
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


## ---- Module: Sever ----------------------------------------------------------

#'
#'
#'
#'
#' @keywords internal
#'
module_server_ipccheck <- function(id, data) {
  shiny::moduleServer(id, function(input, output, session) {
    ns <- session$ns

    values <- shiny::reactiveValues(
      checked = NULL
    )

    ### Use the reactive data properly ----
    current_data <- shiny::reactive({
      shiny::req(data())
      data()
    })

    ### Create a reactive that explicitly depends on both inputs ----
    ui_inputs <- shiny::reactive({
      shiny::req(current_data(), input$ipccheck)

      cols <- base::names(current_data())

      switch(input$ipccheck,

        #### Survey ----
        "survey" = list(
          shiny::selectInput(ns("area1"), 
          label = shiny::tagList("Area 1", htmltools::tags$div(
              style = "font-size: 0.85em; color: #6c7574;", "(Primary area)")
          ), 
          choices = c("", cols)),
          shiny::selectInput(ns("area2"), 
          label = shiny::tagList("Area 2 (optional)", htmltools::tags$div(
              style = "font-size: 0.85em; color: #6c7574;" ,"(Sub-area)")
          ),
          choices = c("", cols)),
          shiny::selectInput(ns("psu"), "Survey clusters", c("", cols))
        ),

        #### Screening ----
        "screening" = list(
          shiny::selectInput(ns("area1"), 
          label = shiny::tagList("Area 1", htmltools::tags$div(
              style = "font-size: 0.85em; color: #6c7574;", "(Primary area)")
          ), 
          choices = c("", cols)),
          shiny::selectInput(ns("area2"), 
          label = shiny::tagList("Area 2 (optional)", htmltools::tags$div(
              style = "font-size: 0.85em; color: #6c7574;" ,"(Sub-area)")
          ),
          choices = c("", cols)),
          shiny::selectInput(ns("sites"), "Screening sites", c("", cols))
        ),

        #### Sentinel sites ----
        "sentinel" = list(
          shiny::selectInput(ns("area1"), 
          label = shiny::tagList("Area 1", htmltools::tags$div(
              style = "font-size: 0.85em; color: #6c7574;", "(Primary area)")
          ), 
          choices = c("", cols)),
          shiny::selectInput(ns("area2"), 
          label = shiny::tagList("Area 2 (optional)", htmltools::tags$div(
              style = "font-size: 0.85em; color: #6c7574;" ,"(Sub-area)")
          ),
          choices = c("", cols)),
          shiny::selectInput(ns("ssites"), "Sentinel sites", c("", cols))
        )
      )
    })

    output$data_source <- shiny::renderUI({
      do.call(shiny::tagList, ui_inputs())
    })

    values$checking <- shiny::reactiveVal(FALSE)

    shiny::observeEvent(input$apply_check, {
      shiny::req(current_data())
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
              shiny::req(input$area1, input$psu)

              #### Check if minimum sample size requirements for survey are met ----
              run_ipcamn_check(
                current_data(), input$psu, "survey", input$area1, input$area2
              )
            },
            "screening" = {
              #### Required variables. Area2 is optional ----
              shiny::req(input$area1, input$sites)

              #### Check if minimum sample size requirements for screening are met ----
              run_ipcamn_check(
                current_data(), input$sites, "screening", input$area1, input$area2
              )
            },
            "sentinel" = {
              #### Required variables. Area2 is optional ----
              shiny::req(input$area1, input$ssites)

              #### Check if minimum sample size requirements for sentinel sites are met ----
              run_ipcamn_check(
                current_data(), input$ssites, "ssite", input$area1, input$area2
              )
            }
          )

          values$checked <- x
        },
        error = function(e) {
          shiny::showNotification(paste("Error during check: ", e$message), type = "error")
        }
      )
      values$checking(FALSE)
    })

    ### Render results into UI ----
    output$checked <- DT::renderDT({
      #### Ensure checked output is available ----
      shiny::req(values$checked)
      DT::datatable(
        values$checked,
        options = list(
          pageLength = 10,
          scrollX = TRUE,
          scrollY = "800px", 
          columDefs = list(list(className = "dt-center", targets = "_all"))
        ),
        caption = if (nrow(values$checked) > 30) {
          paste(
            "Showing first 30 rows of", format(nrow(values$checked), big.mark = "."),
            "total rows"
          )
        } else {
          paste("Showing all", nrow(values$checked), "rows")
        }
      ) |> DT::formatStyle(columns = colnames(values$checked), fontSize = "15px")
    })

    #### Download button to download table of detected clusters in .xlsx ----
    ##### Output into the UI ----
    output$"download_ipccheck" <- shiny::renderUI({
      shiny::req(values$checked)
      shiny::req(!values$checking())
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
          paste0("ipc-check-for-survey_", Sys.Date(), ".xlsx", sep = "")
        } else if (input$ipccheck == "screening") {
          paste0("ipc-check-for-screening_", Sys.Date(), ".xlsx", sep = "")
        } else {
          paste0("ipc-check-for-sentinel-site_", Sys.Date(), ".xlsx", sep = "")
        }
      },
      content = function(file) {
        shiny::req(values$checked) # Ensure results exist
        tryCatch(
          {
            openxlsx::write.xlsx(values$checked, file)
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


## ---- Module helper functions ------------------------------------------------

#'
#'
#'
#' @keywords internal
#'
run_ipcamn_check <- function(df, cluster, source, area1, area2) {
  # Conditionally include area2
  if (area2 != "") {
    mw_check_ipcamn_ssreq(
      df = df,
      cluster = !!rlang::sym(cluster),
      .source = "survey",
      !!rlang::sym(area1), !!rlang::sym(area2)
    )
  } else {
    mw_check_ipcamn_ssreq(
      df = df,
      .source = "survey",
      cluster = !!rlang::sym(cluster),
      !!rlang::sym(area1)
    )
  }
}
