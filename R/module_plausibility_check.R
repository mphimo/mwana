#'
#'
#'
#' @keywords export
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

        # Show WFHZ options when wrangle method is "wfhz"
        shiny::conditionalPanel(
          condition = "input['wrangle_data-wrangle'] == 'wfhz'",
          shiny::radioButtons(
            inputId = ns("plc_wfhz"),
            label = "Weight-for-Height z-scores (WFHZ)",
            choices = list("WFHZ" = "wfhz")
          )
        ),

        # Show MFAZ options when wrangle method is "mfaz"
        shiny::conditionalPanel(
          condition = "input['wrangle_data-wrangle'] == 'mfaz'",
          shiny::radioButtons(
            inputId = ns("plc_mfaz"),
            label = "MUAC-for-Age z-scores (MFAZ)",
            choices = list("MFAZ" = "mfaz")
          )
        ),

        # Show MUAC options when wrangle method is "muac"
        shiny::conditionalPanel(
          condition = "input['wrangle_data-wrangle'] == 'muac'",
          shiny::radioButtons(
            inputId = ns("plc_muac"),
            label = "Raw MUAC",
            choices = list("MUAC" = "muac")
          )
        ),

        # Show combined options for other methods
        shiny::conditionalPanel(
          condition = "input['wrangle_data-wrangle'] == 'combined'",
          shiny::radioButtons(
            inputId = ns("plc_wfhz_mfaz"),
            label = "Selected method",
            choices = list(
              "Weight-for-Height z-scores (WFHZ)" = "wfhz",
              "MUAC-for-Age z-scores (MFAZ)" = "mfaz"
            ),
            selected = "wfhz"
          )
        ),
        shiny::uiOutput(outputId = ns("pls_check_vars")),
        htmltools::tags$br(),
        shiny::actionButton(
          inputId = ns("pls_check"),
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
        ui_element = DT::DTOutput(outputId = ns("pls_checked")),
        type = 8,
        color.background = "#004225",
        image = "logo.png",
        image.height = "50px",
        color = "#004225",
        caption = htmltools::tags$div(
          htmltools::tags$h6("Checking plausibility"), htmltools::tags$h6("Please wait...")
        )
      ),
      shiny::uiOutput(outputId = ns("pls_download"))
    )
  )
}


#'
#'
#'
#'
#'
module_server_plausibility_check <- function(id, data) {
  shiny::moduleServer(
    id,
    module = function(input, output, session) {
      ns <- session$ns

      ### Capture reactivity ----
      dataset <- shiny::reactiveValues(checked = NULL)

      ### Get current method ----
      get_method <- shiny::reactive({
        if (!is.null(input$plc_wfhz) && input$plc_wfhz == "wfhz") {
          "wfhz"
        } else if (!is.null(input$plc_mfaz) && input$plc_mfaz == "mfaz") {
          "mfaz"
        } else if (!is.null(input$plc_muac) && input$plc_muac == "muac") {
          "muac"
        } else if (!is.null(input$plc_wfhz_mfaz)) {
          input$plc_wfhz_mfaz
        } else {
          NULL
        }
      })

      ### Fetch reactivity of user inputs ----
      ui_inputs <- shiny::reactive({
        #### Requires ----
        shiny::req(data())

        #### Get variable names to be displayed ----
        vars <- base::names(data())
        
        #### Get current method ----
        method <- get_method()
        
        if (is.null(method)) {
          return(list()) # Return empty if no method selected
        }

        #### Display inputs based on plausibility check method ----
        if (method == "wfhz") {
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
        } else if (method == "mfaz") {
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

      ### Display variables ----
      output$pls_check_vars <- shiny::renderUI({
        shiny::tagList(ui_inputs())
      })

      ### Create container for reactivity ----
      dataset$checking <- shiny::reactiveVal(FALSE)

      shiny::observeEvent(input$pls_check, {
        shiny::req(data())
        dataset$checking(TRUE)

        #### Handle errors gracefully ----
        valid <- TRUE
        message <- ""
        
        method <- get_method()

        if (method == "wfhz") {
          required_vars <- c(input$sex, input$weight, input$height, input$age, input$flags)
          if (any(required_vars == "" | is.null(required_vars))) {
            valid <- FALSE
            message <- "Please select all required variables."
          }
        } else if (method == "mfaz") {
          required_vars <- c(input$age, input$sex, input$muac, input$flags)
          if (any(required_vars == "" | is.null(required_vars))) {
            valid <- FALSE
            message <- "Please select all required variables."
          }
        } else if (method == "muac") {
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
          dataset$checking(FALSE)
          return()
        }

        tryCatch(
          expr = {
            w <- switch(EXPR = method,
              "wfhz" = {
                shiny::req(
                  input$sex, input$weight, input$height, input$age, input$flags
                )

                run_plausibility_check(
                  df = data(),
                  .for = "wfhz",
                  sex = input$sex,
                  age = input$age,
                  height = input$height,
                  weight = input$weight,
                  flags = input$flags,
                  area1 = input$area1, 
                  area2 = input$area2
                ) |> 
                mw_neat_output_wfhz()
              },
              "mfaz" = {
                shiny::req(input$age, input$sex, input$muac, input$flags)

                run_plausibility_check(
                  df = data(),
                  .for = "mfaz",
                  sex = input$sex,
                  age = input$age,
                  muac = input$muac,
                  flags = input$flags,
                  area1 = input$area1, 
                  area2 = input$area2
                )
              },
              "muac" = {
                shiny::req(input$sex, input$muac, input$flags)

                run_plausibility_check(
                  df = data(),
                  .for = "muac",
                  sex = input$sex,
                  muac = input$muac,
                  flags = input$flags,
                  area1 = input$area1, 
                  area2 = input$area2
                )
              }
            )

            dataset$checked <- w
          },
          error = function(e) {
            shiny::showNotification(paste("Checking error:", e$message), type = "error")
          }
        )

        dataset$checking(FALSE)
      })

      ### Render results into UI ----
      output$pls_checked <- DT::renderDT({
        #### Ensure checked output is available ----
        shiny::req(dataset$checked)
        DT::datatable(
          dataset$checked,
          options = list(
            pageLength = 10,
            scrollX = TRUE,
            scrollY = "800px", 
            columnDefs = list(list(className = "dt-center", targets = "_all"))
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
    }
  )
}



## ---- Module helper functions ------------------------------------------------

#'
#'
#'
#' @keywords internal
#'
run_plausibility_check <- function(
  df, age = NULL, sex, muac = NULL, weight = NULL, 
  height = NULL, flags, area1, area2, .for = c("wfhz", "muac", "mfaz")
) {

  .for <- match.arg(.for)

  if (.for == "wfhz") {
    if (area2 != "") {
      mw_plausibility_check_wfhz(
        df = df, 
        sex = !!rlang::sym(sex), 
        age = !!rlang::sym(age),
        weight = !!rlang::sym(weight),
        height = !!rlang::sym(height), 
        flags = !!rlang::sym(flags), 
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else {
      mw_plausibility_check_wfhz(
        df = df, 
        sex = !!rlang::sym(sex), 
        age = !!rlang::sym(age), 
        weight = !!rlang::sym(weight), 
        height = !!rlang::sym(height), 
        flags = !!rlang::sym(flags), 
        !!rlang::sym(area1)
      )
    }
  } else if (.for == "mfaz") {
    if (area2 != "") {
      mw_plausibility_check_mfaz(
        df = df, 
        sex = !!rlang::sym(sex), 
        muac = !!rlang::sym(muac), 
        age = !!rlang::sym(age), 
        flags = !!rlang::sym(flags), 
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else {
       mw_plausibility_check_mfaz(
        df = df, 
        sex = !!rlang::sym(sex), 
        muac = !!rlang::sym(muac), 
        age = !!rlang::sym(age), 
        flags = !!rlang::sym(flags), 
        !!rlang::sym(area1)
       )
    }
  } else {
    if (area2 != "") {
      mw_plausibility_check_muac(
                df = df, 
        sex = !!rlang::sym(sex), 
        muac = !!rlang::sym(muac), 
        flags = !!rlang::sym(flags), 
        !!rlang::sym(area1), !!rlang::sym(area2)
      )
    } else {
       mw_plausibility_check_muac(
                df = df, 
        sex = !!rlang::sym(sex), 
        muac = !!rlang::sym(muac), 
        flags = !!rlang::sym(flags), 
        !!rlang::sym(area1)
       )
  }
}
}