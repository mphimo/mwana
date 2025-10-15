#'
#'
#'
#'
#' @keywords internal
#'
module_ui_upload <- function(id) {
  ## Namespace ID's ----
  ns <- shiny::NS(id)

  ## UI elements ----
  shiny::tagList(
    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
        width = 400,
        bslib::card(
          bslib::card_header("Upload Data"),
          style = "width: 350px",
          shiny::fileInput(
            inputId = ns("upload"),
            label = "Upload a .csv file",
            buttonLabel = "Browse...",
            accept = ".csv"
          ),
          shiny::conditionalPanel(
            condition = "output.showProgress == true",
            ns = ns,
            htmltools::tags$hr(),
            htmltools::tags$h4("Processing file..."),
            shiny::uiOutput(outputId = ns("uploadProgress"))
          ),
          shiny::conditionalPanel(
            condition = "output.fileUploaded == true",
            ns = ns,
            htmltools::tags$hr(),
            htmltools::tags$h5("File information"),
            shiny::verbatimTextOutput(outputId = ns("fileInfo"))
          )
        )
      ),
      bslib::card(
        bslib::card_header("Data Preview"),
        shiny::conditionalPanel(
          condition = "output.fileUploaded == true",
          ns = ns,
          DT::DTOutput(outputId = ns("uploadedDataTable"))
        ),
        shiny::conditionalPanel(
          condition = "output.showProgress == true",
          ns = ns,
          htmltools::tags$div(
            style = "text-align: center; padding: 50px;",
            htmltools::tags$div(class = "spinner-border text-primary", role = "status"),
            htmltools::tags$h4("Loading data...", style = "color: #007bff; margin-top: 20px;"),
            htmltools::tags$p("Please wait while the file gets processed.")
          )
        ),
        shiny::conditionalPanel(
          condition = "output.fileUploaded != true && output.showProgress != true",
          ns = ns,
          htmltools::tags$div(
            style = "text-align: center; padding: 50px;",
            htmltools::tags$h4("No file uploaded yet", style = "color: #6c757d;"),
            htmltools::tags$p("Please upload a .csv file to see the data preview.")
          )
        )
      )
    )
  )
}


#'
#'
#'
#' @keywords internal
#'
module_server_upload <- function(id) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
        ### Capture reactive values ----
  values <- reactiveValues(
    data = NULL,
    processing = FALSE,
    file_uploaded = FALSE 
  )
      #### Show data uploading progress bar ----
      output$showProgress <- shiny::reactive({values$processing})
      shiny::outputOptions(output, "showProgress", suspendWhenHidden = FALSE)
      output$fileUploaded <- shiny::reactive({values$file_uploaded})
      shiny::outputOptions(output, "fileUploaded", suspendWhenHidden = FALSE)

      output$uploadProgress <- shiny::renderUI({
        if (values$processing) {
          htmltools::tags$div(
            class = "progress",
            htmltools::tags$div(
              class = "progress-bar progress-bar-striped progress-bar-animated",
              role = "progressbar",
              style = "width: 100%"
            )
          )
        }
      })

      shiny::observe({
        shiny::req(input$upload)
        values$processing <- TRUE
        values$file_uploaded <- FALSE

        progress <- shiny::Progress$new(session, min = 0, max = 100)
        on.exit(progress$close())

        progress$set(message = "Reading file...", value = 20)
        Sys.sleep(0.5)

        progress$set(message = "Processing data...", value = 50)

        tryCatch(
          {
            df <- utils::read.csv(
              file = input$upload$datapath, 
              stringsAsFactors = FALSE,
              check.names = FALSE
            )[,-1]
            progress$set(message = "Finalising...", value = 80)
            Sys.sleep(0.3)

            values$data <- df
            progress$set(message = "Complete!", value = 100)
            Sys.sleep(0.2)

            values$processing <- FALSE
            values$file_uploaded <- TRUE
          },
          error = function(e) {
            values$processing <- FALSE
            values$file_uploaded <- FALSE
            shiny::showNotification(
              paste("Error reading file:", e$message),
              type = "error",
              duration = 5
            )
          }
        )
      })

      #### Display uploaded file info ----
      output$fileInfo <- shiny::renderText({
        ##### Required inputs ----
        shiny::req(input$upload, values$data)

        ##### Info to display ----
        paste0(
          "Filename: ", input$upload$name, "\n",
          "Size: ", round(input$upload$size / 1024, 2), " KB\n",
          "Rows: ", format(nrow(values$data), big.mark = ","), "\n",
          "Columns: ", ncol(values$data)
        )
      })

      #### Preview data ----
      output$uploadedDataTable <- shiny::renderDataTable({
        shiny::req(values$data)

        df_preview <- utils::head(values$data, 30)
        DT::datatable(
          data = df_preview,
          rownames = FALSE,
          options = list(
            pageLength = 30,
            scrollX = FALSE,
            scrollY = "800px",
            columnDefs = list(list(className = "dt-center", targets = "_all"))
          ),
          caption = if (nrow(values$data) > 30) {
            paste(
              "Showing first 30 rows of", format(nrow(values$data), big.mark = ","),
              "total rows"
            )
          } else {
            paste("Showing all", nrow(values$data), "rows")
          }
        ) |> 
          DT::formatStyle(columns = colnames(df_preview), fontSize = "12px")
      })

      return(shiny::reactive(values$data))
    }
  )
}