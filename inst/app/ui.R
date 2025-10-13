# ==============================================================================
#                            USER INTERFACE (UI)
# ==============================================================================

## ---- Load required libraries ------------------------------------------------

library(shiny)
library(bslib)
library(DT)
library(shinycssloaders)
library(mwana)
library(dplyr)
library(openxlsx)
library(rlang)

## ---- User's navigation bars -------------------------------------------------

ui <- page_navbar(
  title = tags$div(
    style = "display: flex; align-items: center;",
    tags$span("mwana", 
    style = "margin-right: 10px; font-family: Arial, sans-serif; font-size: 50px;"),
    tags$a( 
      href = "https://nutriverse.io/mwana/",
      tags$span(
        tags$img(src = "logo.png", height = "40px"), 
        style = "margin-right: 20px;" 
      )
    )
  ),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")
  ),

  ## ---- Tab 1: Home ----------------------------------------------------------

  nav_panel(
    title = "Home",
    icon = icon("house"),

    ### Left sidebar for contents ----
    layout_sidebar(
      sidebar = tags$div(
        sytle = "padding: 1rem;",
        tags$h4("Contents"),
        tags$h6(tags$a(href = "#sec1", "Welcome")),
        tags$h6(tags$a(href = "#sec2", "Data Upload")),
        tags$h6(tags$a(href = "#sec3", "IPC Check")),
        tags$h6(tags$a(href = "#sec4", "Data Wrangling")),
        tags$h6(tags$a(href = "#sec5", "Plausibility Check")),
        tags$h6(tags$a(href = "#sec6", "Prevalence Analysis")),
        tags$h6(tags$a(href = "#sec7", "Credits and Licensing"))
      ),
      card(
        style = "padding: 1rem;",
        tags$html(
          tags$div(
            style = "padding: 0.5rem 1rem;",

            #### Title + logo row ----
            tags$div(
              style = "display: flex; justify-content: space-between; align-items: center;",

              ##### Title ----
              tags$h3(
                style = "marging: 0; font-weight: bold;",
                list(
                  tags$code("mwana"),
                  " App: Lorem Ipsum"
                )
              ),

              ##### Logo ----
              tags$a(
                href = "https://nutriverse.io/mwana/",
                tags$img(
                  src = "logo.png",
                  height = "80px",
                  alt = "mwana website",
                  style = "marging-left: 1rem;"
                )
              )
            ),

            #### Underlying subtitle ----
            tags$h4(
              style = "margin: 0; font-weight: normal; line-height: 1.2;",
              list(
                "Lorem Ipsum ", tags$code("mwana"), "Lorem Ipsum"
              )
            )
          )
        )
      )
    )
  ),

  ## ---- Tab 2: Data Upload ---------------------------------------------------

 nav_panel(title = "Data Upload", mod_upload_ui(id = "upload_data")),

        

  ## ---- Tab 3: IPC Check -----------------------------------------------------

  nav_panel(
    title = "IPC Check",
    layout_sidebar(
      sidebar = sidebar(
        width = 400,
        card()
      )
    )
  ),

  ## ---- Tab 4: Data Wrangling ------------------------------------------------

  nav_panel(
    title = "Data Wrangling",
    layout_sidebar(
      sidebar = sidebar(
        width = 400,
        card()
      ),
      card()
    )
  ),

  ## ---- Tab 5: Plausibility Check --------------------------------------------

  nav_panel(
    title = "Plausibility Check",
    layout_sidebar(
      sidebar = sidebar(
        width = 400,
        card()
      ),
      card()
    )
  ),

  ## ---- Tab 6: Prevalence Analysis -------------------------------------------

  nav_panel(
    title = "Prevalence Analysis",
    layout_sidebar(
      sidebar = sidebar(
        width = 400,
        card()
      ),
      card()
    )
  )
)
