#'
#' 
#' 
#' @export
#' 
#' 
module_ui_prevalence <- function(id) {

  ## Namespace ID ----
  ns <- shiny::NS(id)

  bslib::layout_sidebar(
    sidebar = bslib::sidebar(
      width = 400, 
      position = "left",

      ### Left side of the navbar ----
      bslib::card(
        style = "width: 350px;",
        bslib::card_header(
          htmltools::tags$span(
            "Define Analysis Parameters", 
            style = "font-weight: 600;"
          )
        ), 

        #### Select the source of data for prevalence analysis ----
        shiny::radioButtons(
          inputId = ns("source"),
          label = "Select Data Source",
          choices = list(
            "Survey" = "survey",
            "Screening" = "screening"
          ), 
          selected = "survey"
        ),

        #### Display method through which prevalence should be estimated ----
        shiny::uiOutput(outputId = ns("gamby")),

        #### Display variables corresponding to user-defined method ----
        shiny::uiOutput(outputId = ns("gamby_vars")),

        #### Add a blank space ----
        htmltools::tags$br(),

        #### Add action button ----
        shiny::actionButton(
          inputId = ns("estprev"),
          label = "Estimate Prevalence",
          class = "btn-primary"
        )
      )
    ), 

    ### Right side of the nav panel: Prevalence results ----
    bslib::card(
      bslib::card_header(
        htmltools::tags$span(
          "Prevalence Analysis Results", style = "font-weight: 600;"
        )
      ), 

      #### Inform user when analysis is running ----
      shinycssloaders::withSpinner(
        ui_element = DT::DTOutput(outputId = ns("results")),
        type = 8,
        color.background = "#004225",
        image = "logo.png",
        image.height = "50px",
        color = "#004225",
        caption = htmltools::tags$div(
          htmltools::tags$h6("Estimating prevalence"), 
          htmltools::tags$h6("Please wait...")
        )
      ),

      #### Download results ----
      shiny::uiOutput(outputId = ns("download_results"))
    )
  )
}