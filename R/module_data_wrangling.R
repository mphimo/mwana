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
          style = "font-weight: 600;")),
          style = "width: 350px;",
          shiny::radioButtons(
            inputId = ns("wrangle"),
            label = htmltools::tags$span("Select method", 
            style = "font-size: 16px; font-weight: 500;"),
            choices = list(
              "Weight-for-Height z-scores" = "wfhz",
              "Mid-Upper Arm Circumference" = "muac"
            ), 
            selected = "wfhz"
          ),
          shiny::uiOutput(outputId = ns("select_vars")),
          htmltools::tags$br(),
          shiny::actionButton(
            inputId = ns("wrangle!"),
            label = "Wrangle",
            class = "btn-primary"
          )
        )
      ),

      ### Right side of the nav panel ----
      bslib::card(
        bslib::card_header(htmltools::tags$span("Data Preview",
          style = "font-weight: 600;")),
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