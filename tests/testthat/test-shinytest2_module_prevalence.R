# ==============================================================================
#  Test Suite: Module Prevalence
# ==============================================================================

## ---- Survey data ------------------------------------------------------------

### WFHZ Prevalence ----

testthat::test_that(
  desc = "Module works well to estimate prevalence of AMN by WFHZ from survey", 
  code = {

    ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"), 
      timeout = 30000
    )

    ### Wait the app to idle ----
    app$wait_for_idle()

    ### Click in the Data Upload tab ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle()

    #### Read data ----
    data <- read.csv(
      file = system.file("app", "anthro-01.csv", package = "mwana"),
      check.names = FALSE
    )
    tempfile <- tempfile(fileext = ".csv")
    write.csv(data, tempfile, row.names = FALSE)

    #### Upload onto the app ----
    app$upload_file(`upload_data-upload` = tempfile, wait_ = TRUE)

    ### Click on the data wrangling tab ----
    app$click(selector = "a[data-value='Data Wrangling']")
    app$wait_for_idle()

    ### Select data wrangling method and wait the app till idles ----
    app$set_inputs(`wrangle_data-wrangle` = "wfhz", wait_ = FALSE)
    app$wait_for_idle()

    ### Input variables ----
    app$set_inputs(`wrangle_data-dos` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-dob` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`wrangle_data-weight` = "weight", wait_ = FALSE)
    app$set_inputs(`wrangle_data-height` = "height", wait_ = FALSE)

    ### Click wrangle button and wait the app to idle ----
    app$click(input = "wrangle_data-apply_wrangle")
    app$wait_for_idle()

    ### Click on the Prevalence tab and wait the app to idle ----
    app$click(selector = "a[data-value='Prevalence Analysis']")
    app$wait_for_idle()

    ### Select source of data ----
    app$set_inputs(`prevalence-source` = "survey", wait_ = FALSE)

    ### Select the method ----
    app$set_inputs(`prevalence-amn_method_survey` = "wfhz", wait_ = FALSE)
    app$set_inputs(`prevalence-area1` = "area", wait_ = FALSE)
    app$set_inputs(`prevalence-area2` = "sex", wait_ = FALSE) ## Assume sex as grouping var
    app$set_inputs(`prevalence-area3` = "", wait_ = FALSE)
    app$set_inputs(`prevalence-wts` = "", wait_ = FALSE)
    app$set_inputs(`prevalence-oedema` = "oedema", wait_ = FALSE)

    ### Click on Estime Prevalence button ----
    app$click(input = "prevalence-estimate")
    app$wait_for_idle()

    ### Get the list of variable names from the rendered table ----
    vals <- as.character(
      app$get_js(
      "$('#prevalence-results thead th').map(function() {
      return $(this).text();
    }).get();"
    )[1:18]
  )
    
  ### Test check ----
    testthat::expect_equal(
      object = vals,
      expected = c(
        "area", "sex", "gam_n", "gam_p", "gam_p_low", "gam_p_upp", "gam_p_deff",
        "sam_n", "sam_p", "sam_p_low", "sam_p_upp", "sam_p_deff",
        "mam_n", "mam_p", "mam_p_low", "mam_p_upp", "mam_p_deff", "wt_pop"
      )
    )

  ### Stop the app ----
    app$stop()
    
  }
)

### MUAC prevalence ----

testthat::test_that(
  desc = "Module works well to estimate prevalence of AMN by MUAC from survey",
  code = {

     ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"), 
      timeout = 30000
    )

    ### Wait the app to idle ----
    app$wait_for_idle()

    ### Click in the Data Upload tab ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle()

    #### Read data ----
    data <- read.csv(
      file = system.file("app", "anthro-01.csv", package = "mwana"),
      check.names = FALSE
    )
    tempfile <- tempfile(fileext = ".csv")
    write.csv(data, tempfile, row.names = FALSE)

    #### Upload onto the app ----
    app$upload_file(`upload_data-upload` = tempfile, wait_ = TRUE)

    ### Click on the data wrangling tab ----
    app$click(selector = "a[data-value='Data Wrangling']")
    app$wait_for_idle()

    ### Select data wrangling method and wait the app till idles ----
    app$set_inputs(`wrangle_data-wrangle` = "mfaz", wait_ = TRUE)
    app$wait_for_idle()

    ### Input variables ----
    app$set_inputs(`wrangle_data-dos` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-dob` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-age` = "age", wait_ = FALSE)
    app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`wrangle_data-muac` = "muac", wait_ = FALSE)

    ### Click wrangle button and wait the app to idle ----
    app$click(input = "wrangle_data-apply_wrangle")
    app$wait_for_idle()

    ### Click on the Prevalence tab and wait the app to idle ----
    app$click(selector = "a[data-value='Prevalence Analysis']")
    app$wait_for_idle()

    ### Select source of data ----
    app$set_inputs(`prevalence-source` = "survey", wait_ = FALSE)

    ### Select the method ----
    app$set_inputs(`prevalence-amn_method_survey` = "muac", wait_ = FALSE)
    app$set_inputs(`prevalence-area1` = "area", wait_ = FALSE)
    app$set_inputs(`prevalence-area2` = "sex", wait_ = FALSE) ## Assume sex as grouping var
    app$set_inputs(`prevalence-area3` = "", wait_ = FALSE)
    app$set_inputs(`prevalence-wts` = "", wait_ = FALSE)
    app$set_inputs(`prevalence-oedema` = "oedema", wait_ = FALSE)

    ### Click on Estime Prevalence button ----
    app$click(input = "prevalence-estimate")
    app$wait_for_idle()

    ### Get the list of variable names from the rendered table ----
    vals <- as.character(
      app$get_js(
      "$('#prevalence-results thead th').map(function() {
      return $(this).text();
    }).get();"
    )[1:18]
  )
    
  ### Test check ----
    testthat::expect_equal(
      object = vals,
      expected = c(
        "area", "sex", "gam_n", "gam_p", "gam_p_low", "gam_p_upp", "gam_p_deff",
        "sam_n", "sam_p", "sam_p_low", "sam_p_upp", "sam_p_deff",
        "mam_n", "mam_p", "mam_p_low", "mam_p_upp", "mam_p_deff", "wt_pop"
      )
    )

  ### Stop the app ----
    app$stop()
  }
)

### Combined prevalence ----

testthat::test_that(
  desc = "Module works well to estimate prevalence of combined AMN from survey",
  code = {

     ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"), 
      timeout = 30000
    )

    ### Wait the app to idle ----
    app$wait_for_idle()

    ### Click in the Data Upload tab ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle()

    #### Read data ----
    data <- read.csv(
      file = system.file("app", "anthro-01.csv", package = "mwana"),
      check.names = FALSE
    )
    tempfile <- tempfile(fileext = ".csv")
    write.csv(data, tempfile, row.names = FALSE)

    #### Upload onto the app ----
    app$upload_file(`upload_data-upload` = tempfile, wait_ = TRUE)

    ### Click on the data wrangling tab ----
    app$click(selector = "a[data-value='Data Wrangling']")
    app$wait_for_idle()

    ### Select data wrangling method and wait the app till idles ----
    app$set_inputs(`wrangle_data-wrangle` = "combined", wait_ = TRUE)
    app$wait_for_idle()

    ### Input variables ----
    app$set_inputs(`wrangle_data-dos` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-dob` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-age` = "age", wait_ = FALSE)
    app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`wrangle_data-weight` = "weight", wait_ = FALSE)
    app$set_inputs(`wrangle_data-height` = "height", wait_ = FALSE)
    app$set_inputs(`wrangle_data-muac` = "muac", wait_ = FALSE)

    ### Click wrangle button and wait the app to idle ----
    app$click(input = "wrangle_data-apply_wrangle")
    app$wait_for_idle()

    ### Click on the Prevalence tab and wait the app to idle ----
    app$click(selector = "a[data-value='Prevalence Analysis']")
    app$wait_for_idle()

    ### Select source of data ----
    app$set_inputs(`prevalence-source` = "survey", wait_ = FALSE)

    ### Select the method ----
    app$set_inputs(`prevalence-amn_method_survey` = "combined", wait_ = FALSE)
    app$set_inputs(`prevalence-area1` = "area", wait_ = FALSE)
    app$set_inputs(`prevalence-area2` = "sex", wait_ = FALSE) ## Assume sex as grouping var
    app$set_inputs(`prevalence-area3` = "", wait_ = FALSE)
    app$set_inputs(`prevalence-wts` = "", wait_ = FALSE)
    app$set_inputs(`prevalence-oedema` = "oedema", wait_ = FALSE)

    ### Click on Estime Prevalence button ----
    app$click(input = "prevalence-estimate")
    app$wait_for_idle()

    ### Get the list of variable names from the rendered table ----
    vals <- as.character(
      app$get_js(
      "$('#prevalence-results thead th').map(function() {
      return $(this).text();
    }).get();"
    )[1:18]
  )
    
  ### Test check ----
    testthat::expect_equal(
      object = vals,
      expected = c(
        "area", "sex", "cgam_p", "csam_p" , "cmam_p", "cgam_n", "cgam_p_low", 
        "cgam_p_upp", "cgam_p_deff", "csam_n", "csam_p_low", "csam_p_upp",
        "csam_p_deff", "cmam_n", "cmam_p_low", "cmam_p_upp",
        "cmam_p_deff", "wt_pop" 
      )
    )

  ### Stop the app ----
    app$stop()
  }
)

## ---- Screening data ---------------------------------------------------------

### When age is available ----
testthat::test_that(
  desc = "Module works well to estimate prevalence from screening",
  code = {

     ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"), 
      timeout = 30000
    )

    ### Wait the app to idle ----
    app$wait_for_idle()

    ### Click in the Data Upload tab ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle()

    #### Read data ----
    data <- read.csv(
      file = system.file("app", "anthro-01.csv", package = "mwana"),
      check.names = FALSE
    )
    tempfile <- tempfile(fileext = ".csv")
    write.csv(data, tempfile, row.names = FALSE)

    #### Upload onto the app ----
    app$upload_file(`upload_data-upload` = tempfile, wait_ = TRUE)

    ### Click on the data wrangling tab ----
    app$click(selector = "a[data-value='Data Wrangling']")
    app$wait_for_idle()

    ### Select data wrangling method and wait the app till idles ----
    app$set_inputs(`wrangle_data-wrangle` = "mfaz", wait_ = TRUE)
    app$wait_for_idle()

    ### Input variables ----
    app$set_inputs(`wrangle_data-dos` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-dob` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-age` = "age", wait_ = FALSE)
    app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`wrangle_data-muac` = "muac", wait_ = FALSE)

    ### Click wrangle button and wait the app to idle ----
    app$click(input = "wrangle_data-apply_wrangle")
    app$wait_for_idle()

    ### Click on the Prevalence tab and wait the app to idle ----
    app$click(selector = "a[data-value='Prevalence Analysis']")
    app$wait_for_idle()

    ### Select source of data ----
    app$set_inputs(`prevalence-source` = "screening", wait_ = TRUE)

    ### Select the method ----
    app$set_inputs(`prevalence-amn_method_screening` = "yes", wait_ = FALSE)
    app$set_inputs(`prevalence-area1` = "area", wait_ = FALSE)
    app$set_inputs(`prevalence-area2` = "sex", wait_ = FALSE) ## Assume sex as grouping var
    app$set_inputs(`prevalence-area3` = "", wait_ = FALSE)
    app$set_inputs(`prevalence-muac` = "muac", wait_ = FALSE)
    app$set_inputs(`prevalence-oedema` = "oedema", wait_ = FALSE)

    ### Click on Estime Prevalence button ----
    app$click(input = "prevalence-estimate")
    app$wait_for_idle()

    ### Get the list of variable names from the rendered table ----
    vals <- as.character(
      app$get_js(
      "$('#prevalence-results thead th').map(function() {
      return $(this).text();
    }).get();"
    )[1:8]
  )
    
  ### Test check ----
    testthat::expect_equal(
      object = vals,
      expected = c(
        "area", "sex", "gam_n", "gam_p" , "sam_n", "sam_p", "mam_n", "mam_p" 
      )
    )

  ### Stop the app ----
    app$stop()
  }
)


### When age is given in categories ----
