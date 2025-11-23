# ==============================================================================
#  Test Suite: Module Prevalence
# ==============================================================================

## ---- Survey data ------------------------------------------------------------

### WFHZ Prevalence ----

#### Skip test on windows ----
if (identical(Sys.getenv("CI"), "true") && Sys.info()[["sysname"]] == "Windows") {
  skip("Skipping shinytest2 integration tests on Windows CI to reduce runtime")
}

testthat::test_that(
  desc = "Module works well to estimate prevalence of AMN by WFHZ from survey", 
  code = {

    ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"), 
      timeout = 120000,
      wait = TRUE
    )

    ### Wait the app to idle ----
    app$wait_for_idle(timeout = 40000)

    ### Click in the Data Upload tab ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle(timeout = 40000)

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
    app$wait_for_idle(timeout = 40000)

    ## App defaults to WFHZ ----
    ### Input variables ----
    app$set_inputs(`wrangle_data-dos` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-dob` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`wrangle_data-weight` = "weight", wait_ = FALSE)
    app$set_inputs(`wrangle_data-height` = "height", wait_ = FALSE)

    ### Click wrangle button and wait the app to idle ----
    app$click(input = "wrangle_data-apply_wrangle")
     Sys.sleep(3)

    ### Click on the Prevalence tab and wait the app to idle ----
    app$click(selector = "a[data-value='Prevalence Analysis']")
    app$wait_for_idle(timeout = 40000)

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
    app$wait_for_value(output = "prevalence-results", timeout = 40000)

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
        "area", "sex", "children (N)", "gam #", "gam %", "gam lcl", "gam ucl", "gam deff",
        "sam #", "sam %", "sam lcl", "sam ucl", "sam deff",
        "mam #", "mam %", "mam lcl", "mam ucl", "mam deff"
      )
    )

  ### Stop the app ----
    app$stop()
    
  }
)

### MUAC prevalence ----

#### Skip test on windows ----
if (identical(Sys.getenv("CI"), "true") && Sys.info()[["sysname"]] == "Windows") {
  skip("Skipping shinytest2 integration tests on Windows CI to reduce runtime")
}

testthat::test_that(
  desc = "Module works well to estimate prevalence of AMN by MUAC from survey",
  code = {

     ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"), 
      timeout = 120000,
      wait = TRUE
    )

    ### Wait the app to idle ----
    app$wait_for_idle(timeout = 40000)

    ### Click in the Data Upload tab ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle(timeout = 40000)

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
    app$wait_for_idle(timeout = 40000)

    ### Select data wrangling method and wait the app till idles ----
    app$set_inputs(`wrangle_data-wrangle` = "mfaz", wait_ = TRUE)
    app$wait_for_idle(timeout = 40000)

    ### Input variables ----
    app$set_inputs(`wrangle_data-dos` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-dob` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-age` = "age", wait_ = FALSE)
    app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`wrangle_data-muac` = "muac", wait_ = FALSE)

    ### Click wrangle button and wait the app to idle ----
    app$click(input = "wrangle_data-apply_wrangle")
    app$wait_for_idle(timeout = 40000)

    ### Click on the Prevalence tab and wait the app to idle ----
    app$click(selector = "a[data-value='Prevalence Analysis']")
    app$wait_for_idle(timeout = 40000)

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
    app$wait_for_value(output = "prevalence-results", timeout = 40000)

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
        "area", "sex", "children (N)","gam #", "gam %", "gam lcl", "gam ucl", "gam deff",
        "sam #", "sam %", "sam lcl", "sam ucl", "sam deff",
        "mam #", "mam %", "mam lcl", "mam ucl", "mam deff"
      )
    )

  ### Stop the app ----
    app$stop()
  }
)

### Combined prevalence ----

#### Skip test on windows ----
if (identical(Sys.getenv("CI"), "true") && Sys.info()[["sysname"]] == "Windows") {
  skip("Skipping shinytest2 integration tests on Windows CI to reduce runtime")
}

testthat::test_that(
  desc = "Module works well to estimate prevalence of combined AMN from survey",
  code = {

     ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"), 
      timeout = 120000,
      wait = TRUE
    )

    ### Wait the app to idle ----
    app$wait_for_idle(timeout = 40000)

    ### Click in the Data Upload tab ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle(timeout = 40000)

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
    app$wait_for_idle(timeout = 40000)

    ### Select data wrangling method and wait the app till idles ----
    app$set_inputs(`wrangle_data-wrangle` = "combined", wait_ = TRUE)
    app$wait_for_idle(timeout = 40000)

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
    app$wait_for_idle(timeout = 40000)

    ### Click on the Prevalence tab and wait the app to idle ----
    app$click(selector = "a[data-value='Prevalence Analysis']")
    app$wait_for_idle(timeout = 40000)

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
    app$wait_for_value(output = "prevalence-results", timeout = 40000)

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
        "area", "sex", "cgam %", "csam %", "cmam %", "children (N)", "cgam #",
        "cgam lcl", "cgam ucl", "cgam deff", "csam #", "csam lcl", "csam ucl",
        "csam deff", "cmam #", "cmam lcl", "cmam ucl", "cmam deff"
      )
    )

  ### Stop the app ----
    app$stop()
  }
)

## ---- Screening data ---------------------------------------------------------

### When age is available ----

### Skip test on windows ----
if (identical(Sys.getenv("CI"), "true") && Sys.info()[["sysname"]] == "Windows") {
  skip("Skipping shinytest2 integration tests on Windows CI to reduce runtime")
}

testthat::test_that(
  desc = "Module works well to estimate prevalence from screening",
  code = {

     ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"), 
      timeout = 120000,
      wait = TRUE
    )

    ### Wait the app to idle ----
    app$wait_for_idle(timeout = 40000)

    ### Click in the Data Upload tab ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle(timeout = 40000)

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
    app$wait_for_idle(timeout = 40000)

    ### Select data wrangling method and wait the app till idles ----
    app$set_inputs(`wrangle_data-wrangle` = "mfaz", wait_ = TRUE)
    app$wait_for_idle(timeout = 40000)

    ### Input variables ----
    app$set_inputs(`wrangle_data-dos` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-dob` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-age` = "age", wait_ = FALSE)
    app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`wrangle_data-muac` = "muac", wait_ = FALSE)

    ### Click wrangle button and wait the app to idle ----
    app$click(input = "wrangle_data-apply_wrangle")
    app$wait_for_idle(timeout = 40000)

    ### Click on the Prevalence tab and wait the app to idle ----
    app$click(selector = "a[data-value='Prevalence Analysis']")
    app$wait_for_idle(timeout = 40000)

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
    app$wait_for_value(output = "prevalence-results", timeout = 40000)

    ### Get the list of variable names from the rendered table ----
    vals <- as.character(
      app$get_js(
      "$('#prevalence-results thead th').map(function() {
      return $(this).text();
    }).get();"
    )[1:9]
  )
    
  ### Test check ----
    testthat::expect_equal(
      object = vals,
      expected = c(
        "area", "sex", "gam #", "gam %" , "sam #", "sam %", 
        "mam #", "mam %", "children (N)"
      )
    )

  ### Stop the app ----
    app$stop()
  }
)


### When age is given in categories ----

#### Skip test on windows ----
if (identical(Sys.getenv("CI"), "true") && Sys.info()[["sysname"]] == "Windows") {
  skip("Skipping shinytest2 integration tests on Windows CI to reduce runtime")
}

testthat::test_that(
  desc = "Prevalence tab works as expected when age is given in categories",
  code = {


    #### Initialise app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"),
      timeout = 120000,
      wait = TRUE
    )

    #### Wait app to idle ----
    app$wait_for_idle(timeout = 40000)

    #### Click on the Data Upload tab ----
    app$click(selector = "a[data-value='Data Upload']")

    app$wait_for_idle(timeout = 40000)

    #### Read data ----
    data <- read.csv(
      file = system.file("app", "anthro-01.csv", package = "mwana"),
      check.names = FALSE
    )
    tempfile <- tempfile(fileext = ".csv")
    write.csv(data, tempfile, row.names = FALSE)

    #### Upload onto the app ----
    app$upload_file(`upload_data-upload` = tempfile, wait_ = TRUE)

    ### Click on Data Wrangling tab ----
    app$click(selector = "a[data-value='Data Wrangling'")
    app$wait_for_idle(timeout = 40000)

    #### Select data wrangling method ----
    app$set_inputs("wrangle_data-wrangle" = "muac")
    app$wait_for_idle(timeout = 40000)

    #### Select variables ----
    app$set_inputs("wrangle_data-sex" = "sex", wait_ = FALSE)
    app$set_inputs("wrangle_data-muac" = "muac", wait_ = FALSE)

    #### Click on wrangle button ----
    app$click(input = "wrangle_data-apply_wrangle")
    app$wait_for_idle(timeout = 40000)

    #### Click on Prevalence tab ----
    app$click(selector = "a[data-value='Prevalence Analysis']")
    app$wait_for_idle(timeout = 40000)

    #### Select source of data ----
    app$set_inputs("prevalence-source" = "screening", wait_ = FALSE)
    app$wait_for_idle(timeout = 40000)

    #### Select if age is available ----
    app$set_inputs("prevalence-amn_method_screening" = "no", wait_ = FALSE)

    #### Select variables ----
    app$set_inputs("prevalence-age_cat" = "age_cat", wait_ = FALSE)
    app$set_inputs("prevalence-area1" = "team", wait_ = FALSE)
    app$set_inputs("prevalence-muac" = "muac", wait_ = FALSE)
    app$set_inputs("prevalence-oedema" = "oedema", wait_ = FALSE)

    #### Click on Estimate Prevalence button ----
    app$click(input = "prevalence-estimate")
    app$wait_for_idle(timeout = 40000)

    #### Wait until output has been rendered ----
    app$wait_for_value(output = "prevalence-results", timeout = 40000)

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
        "team", "gam #", "gam %" , "sam #", "sam %", "mam #", 
        "mam %", "children (N)"
      )
    )

  ### Stop the app ----
    app$stop()

  }
)
