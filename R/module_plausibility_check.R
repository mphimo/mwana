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
    style = "font-weight: 600;")),
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