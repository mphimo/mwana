#'
#'
#'
#'
#' @keywords internal
#'
module_ui_wrangling <- function(id) {
  ## Namespace ID ----
  ns <- shiny::NS(id)

  ## UI elements ----
  shiny::tagList(
    bslib::layout_sidebar(
      sidebar = bslib::sidebar(
        width = 400,

        ### Left side of the nav panel ----
        bslib::card(
          bslib::card_header(htmltools::tags$span("Define Data Wrangling Parameters",
            style = "font-weight: 600;"
          )),
          style = "width: 350px;",
          shiny::radioButtons(
            inputId = ns("wrangle"),
            label = htmltools::tags$span("Select method",
              style = "font-size: 16px; font-weight: 500;"
            ),
            choices = list(
              "Weight-for-Height z-scores" = "wfhz",
              "Mid-Upper Arm Circumference" = "muac",
              "Both" = "combined"
            ),
            selected = "wfhz"
          ),
          shiny::uiOutput(outputId = ns("select_vars")),
          htmltools::tags$br(),
          shiny::actionButton(
            inputId = ns("apply_wrangle"),
            label = "Wrangle",
            class = "btn-primary"
          )
        )
      ),

      ### Right side of the nav panel ----
      bslib::card(
        bslib::card_header(htmltools::tags$span("Data Preview",
          style = "font-weight: 600;"
        )),
        shinycssloaders::withSpinner(
          ui_element = DT::DTOutput(outputId = ns("wrangled")),
          type = 8,
          color.background = "#004225",
          image = "logo.png",
          image.height = "50px",
          color = "#004225",
          caption = htmltools::tags$div(
            "Wrangling", htmltools::tags$br(), htmltools::tags$h5("Please wait...")
          )
        ),
        shiny::uiOutput(outputId = ns("download_wrangled_data"))
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
#'
module_server_wrangling <- function(id, data) {
  shiny::moduleServer(
    id,
    function(input, output, session) {
      ns <- session$ns

      ### Capture reactivity ----
      dataset <- shiny::reactiveValues(wrangled = NULL)

      ### Fetch reactive user inputs ----
      ui_inputs <- shiny::reactive({
        shiny::req(data(), input$wrangle)

        #### Get variables names to display inside input selectors ----
        vars <- base::names(data())

        #### Display variables based on the wrangling method ----
        switch(input$wrangle,

          ##### WFHZ ----
          "wfhz" = list(
            shiny::selectInput(ns("sex"), "Sex", c("", vars)),
            shiny::selectInput(ns("weight"), "Weight (kg)", c("", vars)),
            shiny::selectInput(ns("height"), "Height (cm)", c("", vars))
          ),

          ##### MUAC ----
          "muac" = list(
            shiny::selectInput(ns("age"), "Age (months)", c("", vars)),
            shiny::selectInput(ns("sex"), "Sex", c("", vars)),
            shiny::selectInput(ns("muac"), "MUAC (cm)", c("", vars))
          ),

          ##### Combined ----
          "combined" = list(
            shiny::selectInput(ns("age"), "Age (months)", c("", vars)),
            shiny::selectInput(ns("sex"), "Sex", c("", vars)),
            shiny::selectInput(ns("weight"), "Weight (kg)", c("", vars)),
            shiny::selectInput(ns("height"), "Height (cm)", c("", vars)),
            shiny::selectInput(ns("muac"), "MUAC (cm)", c("", vars))
          )
        )
      })

      output$select_vars <- shiny::renderUI({
        tagList(ui_inputs())
      })

      ### Create container for reactivity ----
      dataset$wrangling <- reactiveVal(FALSE)

      shiny::observeEvent(input$apply_wrangle, {
        shiny::req(data())
        dataset$wrangling(TRUE)

        #### Handle errors gracefully ----
        valid <- TRUE
        message <- ""

        if (input$wrangle == "wfhz") {
          if (is.null(input$sex) || is.null(input$weight) || is.null(input$height)) {
            valid <- FALSE
            message <- "😬 Please select all required variables."
          }
        } else if (input$wrangle == "muac") {
          if (is.null(input$age) || is.null(input$sex) || is.null(input$muac)) {
            valid <- FALSE
            message <- "😬 Please select all required variables."
          }
        } else {
          if (is.null(any(c(input$age, input$sex, input$weight, input$height, input$muac)))) {
            message <- "😬 Please select all required variables."
          }
        }

        if (!valid) {
          shiny::showNotification(message, type = "error")
          dataset$wrangling(FALSE)
          return()
        }

        tryCatch(
          expr = {
            w <- switch(EXPR = input$wrangle,
              "wfhz" = {
                shiny::req(input$sex, input$weight, input$height)
                data() |>
                  dplyr::rename(
                    sex = !!rlang::sym(input$sex),
                    weight = !!rlang::sym(input$weight),
                    height = !!rlang::sym(input$height)
                  ) |>
                  mw_wrangle_wfhz(
                    sex = sex,
                    .recode_sex = TRUE,
                    weight = weight,
                    height = height
                  )
              },
              "muac" = {
                shiny::req(input$age, input$sex, input$muac)

                data() |>
                  dplyr::rename(
                    age = !!rlang::sym(input$age),
                    sex = !!rlang::sym(input$sex),
                    muac = !!rlang::sym(input$muac)
                  ) |>
                  mw_wrangle_age(dos = NULL, dob = NULL, age = age) |>
                  mw_wrangle_muac(
                    sex = sex,
                    .recode_sex = TRUE,
                    age = age,
                    muac = muac,
                    .recode_muac = FALSE,
                    .to = "none"
                  )
              },
              "combined" = {
                shiny::req(
                  input$age, input$sex, input$weight, input$height,
                  input$muac
                )

                data() |>
                  dplyr::rename(
                    age = !!rlang::sym(input$age),
                    sex = !!rlang::sym(input$sex),
                    muac = !!rlang::sym(input$muac),
                    weight = !!rlang::sym(input$weight),
                    height = !!rlang::sym(input$height)
                  ) |>
                  mw_wrangle_wfhz(
                    sex = sex,
                    .recode_sex = TRUE,
                    weight = weight,
                    height = height
                  ) |>
                  mw_wrangle_age(dos = NULL, dob = NULL, age = age) |>
                  mw_wrangle_muac(
                    sex = sex,
                    .recode_sex = FALSE,
                    age = age,
                    muac = muac,
                    .recode_muac = FALSE,
                    .to = "none"
                  )
              }
            )

            dataset$wrangled <- w
          },
          error = function(e) {
            shiny::showNotification(paste("Wrangling error", e$message), type = "error")
          }
        )

        dataset$wrangling(FALSE)
      })

      ### Display wrangled data ----
      output$wrangled <- DT::renderDT({
        shiny::req(!dataset$wrangling())
        shiny::req(dataset$wrangled)

        DT::datatable(
          data = utils::head(dataset$wrangled, 30),
          rownames = FALSE,
          options = list(
            pageLength = 30,
            scrollX = FALSE,
            scrolly = "800px",
            columnDefs = list(list(className = "dt-center", targets = "_all"))
          ),
          caption = if (nrow(dataset$wrangled) > 30) {
            paste(
              "Showing first 30 rows of", format(nrow(dataset$wrangled), big.mark = ","),
              "total rows"
            )
          } else {
            paste("showing all", nrow(dataset$wrangled), "rows")
          }
        ) |> DT::formatStyle(columns = colnames(dataset$wrangled), fontSize = "13px")
      })

      ### Download data ----
      #### Add download button into the UI ----
      output$download_wrangled_data <- shiny::renderUI({
        shiny::req(dataset$wrangled)
        shiny::req(!dataset$wrangling())
        htmltools::tags$div(
          style = "margin-bottom: 15px; text-align: right;",
          shiny::downloadButton(
            outputId = ns("download_data"),
            label = "Download Wrangled Data",
            class = "btn-primary",
            icon = shiny::icon(name = "download", class = "fa-lg")
          )
        )
      })

      #### Downloadable results by clicking on the download button ----
      output$download_data <- shiny::downloadHandler(
        filename = function() {
          if (input$wrangle == "wfhz") {
            paste0("mwana-wranged-data-wfhz_", Sys.Date(), ".xlsx", sep = "")
          } else if (input$wrangle == "muac") {
            paste0("mwana-wranged-data-muac_", Sys.Date(), ".xlsx", sep = "")
          } else {
            paste0("mwana-wranged-data-combined_", Sys.Date(), ".xlsx", sep = "")
          }
        },
        content = function(file) {
          shiny::req(dataset$wrangled) # Ensure results exist
          tryCatch(
            {
              openxlsx::write.xlsx(dataset$wrangled, file)
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
