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

ui <- tagList(
  ### Link up with custom .css file ----
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css") # external stylesheet
  ),
  page_navbar(
    title = tags$div(
      style = "display: flex; align-items: center; justify-content: space-between; width: 100%;",

      ### Left side: app name and logo ----
      tags$div(
        style = "display: flex; align-items: center;",
        tags$span("mwana",
          style = "margin-right: 10px; font-family: Arial, sans-serif; font-size: 50px;"
        ),
        tags$a(
          href = "https://nutriverse.io/mwana/",
          tags$span(
            tags$img(src = "logo.png", height = "40px"),
            style = "margin-right: 20px;"
          )
        )
      ),

      ### Right side: app version ----
      tags$span("v.1.0.0",
        id = "app-version",
        style = "font-size: 12.5px; color:  rgba(255, 255, 255, 0.4);
        position: fixed; top: 40px; right: 20px;"
      )
    ),

    ## ---- Tab 1: Home ----------------------------------------------------------

    nav_panel(
      title = "Home",
      icon = icon("house"),

      ### Left sidebar for contents ----
      layout_sidebar(
        sidebar = tags$div(
          style = "padding: 1rem;",
          tags$h4("Contents"),
          tags$h6(tags$a(href = "#sec1", "Welcome")),
          tags$h6(tags$a(href = "#sec2", "Data Upload")),
          tags$h6(tags$a(href = "#sec3", "Data Wrangling")),
          tags$h6(tags$a(href = "#sec4", "Plausibility Check")),
          tags$h6(tags$a(href = "#sec5", "Prevalence Analysis")),
          tags$h6(tags$a(href = "#sec6", "IPC Check")),
          tags$h6(tags$a(href = "#sec7", "Authorship")),
          tags$h6(tags$a(href = "#sec8", "License")),
        ),
        card(
          style = "padding: 1rem; background-color: #f9fdfb;",
          tags$html(
            tags$div(
              style = "padding: 0.5rem 1rem;",

              #### Title + logo row ----
              tags$div(
                class = "app-title",
                style = "display: flex; justify-content: space-between; align-items: center;",

                ##### Left side: title + subtitle stacked ----
                tags$div(
                  style = "display: flex; flex-direction: column;",
                tags$h3(
                  style = "marging: 0; font-weight: bold;",
                  "Seamless workflow for data plausibility check and
                wasting prevalence analysis"
                ),

                #### Underlying subtitle ----
              tags$h4(
                style = "margin: 0; font-weight: normal; line-height: 1.2;",
                "
                A simplified workflow of", tags$code("mwana"), "package for non-R
                users
                "
              )
            ),

                ##### Right side: logo ----
                tags$a(
                  href = "https://nutriverse.io/mwana/",
                  tags$img(
                    src = "logo.png",
                    height = "160px",
                    alt = "mwana website",
                    style = "marging-left: 1rem;"
                  )
                )
              )
              ),

              #### Welcome message ----
              tags$div(
                id = "sec1",
                style = "text-align: justify;",
                tags$hr(),
                tags$p(
                  "
                  This app is a lightweight, field-ready application
                  thoughtful designed to seamlessly streamline plausibility checks
                  and wasting prevalence estimation of child anthropometric data,
                  by automating key steps of the R package
                  ",
                  tags$a(
                    href = "https://nutriverse.io/mwana/",
                    tags$code("mwana")
                  ), "for non-R users."
                ),
                tags$p(
                  "The app is divided in five easy-to-navigate tabs, apart from
                  the Home - where you at right now.",
                  tags$ol(
                    tags$li(tags$b("Data Upload")),
                    tags$li(tags$b("Data Wrangling")),
                    tags$li(tags$b("Plausibility Check")),
                    tags$li(tags$b("Prevalence Analysis")),
                    tags$li(tags$b("IPC Check"))
                  )
                ),
                tags$hr(),

                ##### Briefly describe each tab ----
                tags$div(
                  id = "sec2",
                  style = "text-align: justify;",

                  ###### Data Upload tab ----
                  tags$p(tags$b("Data Upload")),
                  tags$p(
                    "
                    This is where the workflow begins. Upload the
                    dataset saved in a comma-separated-value format (.csv); this is
                    the only accepted format. Click on the 'Browse' button to locate
                    the file to be uploaded from your computer; it is as simple as that.
                    Once uploaded, the first 20 rows will be priviewed on the right side.
                    "
                  ),
                  tags$ul(
                    tags$li(
                      tags$b("Data requirements"),
                      tags$p(
                        "
                        The data to be uploaded must have been tidy up in accordance
                        to the below-described app's", tags$b("input file"), "and",
                        tags$b("input variable"), "requirements:
                        "
                      ),
                      tags$ul(
                        tags$li(
                          tags$b("Input file requirements"),
                          tags$ul(
                            tags$li(
                              tags$b("File naming:"), "the file name must use
                            underscore ( _ ) to separate words. Hyphen ( - ) or
                            simple spaces will lead to errors along the uploading
                            process. Consider the following naming example:",
                              tags$em("my_file_to_upload.csv")
                            )
                          )
                        ),
                        tags$br(),
                        tags$li(
                          tags$b("Input variable requirements"),
                          tags$ul(
                            tags$li(
                              tags$b("Age:"), "values must be in months. The variable name
                              must be written in lowercase ('age')."
                            ),
                            tags$li(
                              tags$b("Sex:"), "values must be given in 'm' for boys and 'f'
                              for girls."
                            ),
                            tags$li(
                              tags$b("MUAC:"), "values must be in millimetres. Ensure there
                              are no strange numbers, such as '130.1'. The presence
                              of decimal places will raise error in the data wrangling
                              tab and hault the app."
                            ),
                            tags$li(
                              tags$b("Oedema:"), "values must be given in 'y' for yes,
                              and 'n' for no."
                            )
                          )
                        )
                      )
                    )
                  )
                ),
                tags$hr(),

                ###### Data Wrangling tab ----
                tags$div(
                  id = "sec3",
                  style = "text-align: justify;",
                  tags$p(tags$b("Data Wrangling")),
                  tags$p(
                    "
                    Wrangle the dataset for downstream workflow. For this, different
                    wrangling methods are given. Upon completion, this tab's output
                    becomes available in subsequent tabs; therefore, the wrangling
                    method selected herein should match the intended analysis.

                    "
                  ),
                  tags$p(
                    "
                    Under the hood, the wrangling process consists in
                    calculating age in months and excluding all records that fall under
                    six months and over 59.99 months. Then, it computes z-scores - if
                    either WFHZ or MFAZ method is selected - then it detects outliers
                    based on the SMART flagging criteria - for z-scores. For MUAC, when
                    age in months is not available, values under 100 and over 200
                    millimetres are considered as outliers. At the the end, two new
                    columns get added into the dataset:", tags$code("wfhz"), "and",
                    tags$code("flag_wfhz"), "for weight-for-heigh z-scores and flagged
                    records, respectively. Moreover, when working with MUAC and when
                    age is available, the following columns get added:", tags$code("mfaz"),
                    "and", tags$code("flag_mfaz"), "for MUAC-for-age z-scores and flagged
                    records, respectively. Finally, when age is not available, only one
                    column gets added:", tags$code("flag_muac"), "which indicates
                    the flagged records based on the above-mentioned criterion.

                    "
                  ),
                  tags$p(
                    "
                    Once the wrangling process is completed, a preview of the output
                    is displayed on the right side of the tab, wherein the first 20
                    rows are shown. You can get a full view of the entire dataset by
                    downloading it. Click on the 'Download Wrangle Data' button, and
                    thereafter look for the file in the 'downloads' folder on your
                    computer.
                    "
                  )
                ),
                tags$hr(),

                ###### Plausibility Check tab ----
                tags$div(
                  id = "sec4",
                  style = "text-align: justify;",
                  tags$p(tags$b("Plausibility Check")),
                  tags$p(
                    "As above-described, this tab depends on the previous tab.
                    Select the same method as in the data wrangling. Thereafter,
                    supply the input fields with the corresponding variables
                    from the dataset. For this, a dropdown list of the variable
                    names found in the dataset is given; Select the one that
                    applies, and click on 'Check Plausibility' button thereafter.

                    The app lets you get the plausibility checks results grouped by
                    different categories - up to a maximum of three. For this,
                    supply the grouping variables to", tags$code("Area 1"),
                    tags$code("Area 2"), "and", tags$code("Area 3")
                  ),
                  tags$p(tags$em(
                    "For example: In your dataset, there are the following
                    indentifying variables: 'state', 'county', and 'team'. You
                    wish to get the plausibility check results grouped by
                    province, then by county and then you also wish to check the
                    results by survey teams that worked in each county and provinces.
                    You can achieve this simply by supplying 'province' to",
                    tags$code("Area 1"), "'county' to", tags$code("Area 2"),
                    "and 'team' to", tags$code("Area 3"), "."
                  )),
                  tags$p(
                    "
                    Upon completion, you can download the results into Excel
                    by clicking on the 'Download Results' button found at the
                    bottom-right side of the tab.
                    "
                  )
                ),
                tags$hr(),

                ###### Prevalence Analysis tab ----
                tags$div(
                  id = "sec5",
                  style = "text-align: justify;",
                  tags$p(tags$b("Prevalence Analysis")),
                  tags$p(
                    "
                    As afore-mentioned, this tab depends on the data wrangling.
                    The app lets you estimate prevalence derived from survey and
                    screening. Therefore, the first step is to select the
                    data source - whether survey or screening. If screening,
                    indicate whether there is an age variable in the dataset with
                    values given in months. This tells the app whether to use it
                    or resort to a fallback - when 'No' is selected.

                    In the latter case, you must have a variable called",
                    tags$code("age_cat"), ".", "This should have the following
                    categories: '6-23' for each record wherein age is between 6 and
                    23 months, and '24-59' for when age is between 24 and 59 monts.
                    This must be done before uploading the data.", "The",
                    tags$code("age_cat"), "variable is supplied to the ",
                    tags$code("Age categories (6-23 and 24-59)"), "input field.
                    This ensures that MUAC-based prevalence gets age-weighted
                    whenever there is excess of children in the 6-23' category.", "Read more",
                    tags$a("here", href = "https://nutriverse.io/mwana/dev/reference/age_ratio.html"),
                    "and", tags$a("here", href = "https://nutriverse.io/mwana/dev/articles/prevalence.html#sec-prevalence-muac"),
                    "."
                  ),
                  tags$p(
                    "
                    Thereafter, the next step is to select the method to define
                    acute malnutrition. Then, supply the input variables as required.
                    "
                  ),
                  tags$p(
                    "
                    You can also group the analysis by different groups, as
                    explained in the plausibility check section. Follow the same
                    guide provided therein.
                    "
                  )
                ),
                tags$hr(),

                ###### IPC Check tab ----
                tags$div(
                  id = "sec6",
                  style = "text-align: justify;",
                  tags$p(tags$b("IPC Check")),
                  tags$p(
                    "
                    This lets you check whether the IPC Acute Malnutrition evidence
                    requirements for outcome data have been met or not. It checks
                    against survey, screening and sentinel sites data source-related
                    requirements, in accordance with the IPC protocols.
                    "
                  ),
                  tags$p(
                    "
                    This tab depends on the 'Upload Data' tab; this means that
                    you can check the requirements even before the wrangling the
                    data.
                    "
                  )
                ),
                tags$hr(),
                tags$div(
                  id = "sec7",
                  style = "text-align: justify;",
                  tags$p(tags$b("Authorship")),
                  tags$p(
                    "This app was developed and is maintained by Tomás Zaba."
                  )
                ),
                tags$hr(),
                tags$div(
                  id = "sec8",
                  style = "text-align: justify;",
                  tags$p(tags$b("License")),
                  tags$p(
                    "This app is licensed under the GPL (>=3) license."
                  )
                )
              )
            )
          )
        )
    ),

    ## ---- Tab 2: Data Upload ---------------------------------------------------

    nav_panel(
      title = "Data Upload",
      mwana:::module_ui_upload(id = "upload_data")
    ),

    ## ---- Tab 4: Data Wrangling ------------------------------------------------

    bslib::nav_panel(
      title = "Data Wrangling",
      mwana:::module_ui_wrangling(id = "wrangle_data")
    ),

    ## ---- Tab 5: Plausibility Check --------------------------------------------

    nav_panel(
      title = "Plausibility Check",
      mwana:::module_ui_plausibility_check(id = "plausible")
    ),

    ## ---- Tab 6: Prevalence Analysis -------------------------------------------

    nav_panel(
      title = "Prevalence Analysis",
      mwana:::module_ui_prevalence(id = "prevalence")
    ),

    ## ---- Tab 3: IPC Check -----------------------------------------------------

    nav_panel(
      title = "IPC Check",
      mwana:::module_ui_ipccheck(id = "ipc_check")
    )
  )
)
