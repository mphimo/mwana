#'
#'
#'
#'
#' @keywords internal
#'
mod_upload_ui <- function(id) {
  ## Namespace ID's ----
  ns <- NS(id)

  ## UI elements ----
  tagList(
    layout_sidebar(
      sidebar = sidebar(
        width = 400,
        card(
          card_header("Upload data"),
          style = "width: 350px",
          fileInput(
            inputId = ns("upload"),
            label = "Upload a .csv file",
            buttonLabel = "Browse...",
            accept = ".csv"
          ),
          conditionalPanel(
            condition = "output.showProgress",
            tags$hr(),
            tags$h4("Processing file..."),
            uiOutput(outputId = ns("uploadProgress"))
          ),
          conditionalPanel(
            condition = "output.fileUploaded",
            tags$hr(),
            tags$h4("File information"),
            verbatimTextOutput(outputId = ns("fileInfo"))
          )
        )
      ),
      card(
        card_header("Data preview"),
        conditionalPanel(
          condition = "output.fileUploaded",
          ns = ns,
          DTOutput(outputId = ns("uploadedDataTable"))
        ),
        conditionalPanel(
          condition = "output.showProgress",
          ns = ns,
          tags$div(
            style = "text-align: center; padding: 50px;",
            tags$div(class = "spinner-border text-primary", role = "status"),
            tags$h4("Loading data...", style = "color: #007bff; margin-top: 20px;"),
            tags$p("Please wait while we process your file.")
          )
        ),
        conditionalPanel(
          condition = "!output.fileUploaded",
          ns = ns,
          tags$div(
            style = "text-align: center; padding: 50px;",
            tags$h4("No file uploaded yet", style = "color: #6c757d;"),
            tags$p("Please upload a .csv file to see the data preview.")
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
mod_upload_server <- function(id, values) {
  moduleServer(
    id,
    function(input, output, session) {
      #### Show data uploading progress bar ----
      output$showProgress <- reactive({values$processing})
      outputOptions(output, "showProgress", suspendWhenHidden = FALSE)
      output$fileUploaded <- reactive({values$file_uploaded})
      outputOptions(output, "fileUploaded", suspendWhenHidden = FALSE)

      output$uploadProgress <- renderUI({
        if (values$processing) {
          tags$div(
            class = "progress",
            tags$div(
              class = "progress-bar progress-bar-striped progress-bar-animated",
              role = "progressbar",
              style = "width: 100%"
            )
          )
        }
      })

      observe({
        req(input$upload)
        values$processing <- TRUE
        values$file_uploaded <- FALSE

        progress <- Progress$new(session, min = 0, max = 100)
        on.exit(progress$close())

        progress$set(message = "Reading file...", value = 20)
        Sys.sleep(0.5)

        progress$set(message = "Processing data...", value = 50)

        tryCatch(
          {
            df <- read.csv(file = input$upload$datapath, stringsAsFactors = FALSE)
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
            showNotification(
              paste("Error reading file:", e$message),
              type = "error",
              duration = 5
            )
          }
        )
      })

      #### Display uploaded file info ----
      output$fileInfo <- renderText({
        ##### Required inputs ----
        req(input$upload, values$data)

        ##### Info to display ----
        paste0(
          "Filename: ", input$upload$name, "\n",
          "Size: ", round(input$upload$size / 1024, 2), " KB\n",
          "Rows: ", format(nrow(values$data), big.mark = ","), "\n",
          "Columns: ", ncol(values$data)
        )
      })

      #### Preview data ----
      output$uploadedDataTable <- renderDataTable({
        req(values$data)

        df_preview <- head(values$data, 30)
        datatable(
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
        ) %>% 
          formatStyle(columns = colnames(df_preview), fontSize = "12px")
      })

      return(reactive(values$data))
    }
  )
}