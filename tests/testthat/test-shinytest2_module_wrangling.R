# ==============================================================================
#  Test Suite: Module Data Wrangling
# ==============================================================================


## ---- Data Wrangling: WFHZ ---------------------------------------------------

testthat::test_that(desc = "Server data wrangling works as expected for WFHZ", {

  ## Initialise app ----
  app <- shinytest2::AppDriver$new(
    app_dir = testthat::test_path("fixtures"),
      load_timeout = 120000, 
      wait = TRUE
  )

  ### Let the app load ----
    app$wait_for_idle(timeout = 40000)

    ### Click on the Data uploading navbar ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle(timeout = 40000)

    ### Upload data ----
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

  ### Select input variables ----
  app$set_inputs(`wrangle_data-wrangle` = "wfhz", wait_ = FALSE)
  app$set_inputs(`wrangle_data-dos` = "", wait_ = FALSE)
  app$set_inputs(`wrangle_data-dob` = "", wait_ = FALSE)
  app$set_inputs(`wrangle_data-age` = "", wait_ = FALSE)
  app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
  app$set_inputs(`wrangle_data-weight` = "weight", wait_ = FALSE)
  app$set_inputs(`wrangle_data-height` = "height", wait_ = FALSE)

  ### Click wrangle button ----
  app$click(input = "wrangle_data-apply_wrangle")
  app$wait_for_value(output = "wrangle_data-wrangled", timeout = 40000)

  ### Get wrangled values ----
  vals <- app$get_js("
    $('#wrangle_data-wrangled thead th').map(function() {
      return $(this).text();
    }).get();
  ") |> as.character()

  testthat::expect_true(all(c("wfhz", "flag_wfhz") %in% vals))
   testthat::expect_equal(
    object = length(vals),
    expected = 14)

  #### Stop the app ----
  app$stop()
}

)


## ---- Data Wrangling: MFAZ ---------------------------------------------------


testthat::test_that(desc = "Server data wrangling works as expected for MFAZ", {

  ## Initialise app ----
  app <- shinytest2::AppDriver$new(
    app_dir = testthat::test_path("fixtures"),
      load_timeout = 120000,
      wait = TRUE
  )

  ### Let the app load ----
    app$wait_for_idle(timeout = 40000)

    ### Click on the Data uploading navbar ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle(timeout = 40000)

    ### Upload data ----
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

  ### Set the wrangling method to MFAZ ----
  app$set_inputs(`wrangle_data-wrangle` = "mfaz", wait_ = FALSE)

  ### Select variables ----
  app$set_inputs(`wrangle_data-dos` = "", wait_ = FALSE)
  app$set_inputs(`wrangle_data-dob` = "", wait_ = FALSE)
  app$set_inputs(`wrangle_data-age` = "age", wait_ = FALSE)
  app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
  app$set_inputs(`wrangle_data-muac` = "muac", wait_ = FALSE)

  ### Click wrangle button ----
  app$click(input = "wrangle_data-apply_wrangle")
  app$wait_for_value(output = "wrangle_data-wrangled", timeout = 40000)

  ### Get wrangled values ----
  vals <- app$get_js("
    $('#wrangle_data-wrangled thead th').map(function() {
      return $(this).text();
    }).get();
  ") |> as.character()

  ### Test check ----
  testthat::expect_true(all(vals %in% c("age_days", "mfaz", "flag_mfaz")))
    testthat::expect_true(app$get_js("$('#ipc_check-checked').length > 0"))

  #### Stop the app ----
  app$stop()
}

)


## ---- Data Wrangling: MUAC ---------------------------------------------------

### When age is given in categories ----
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

    ### Get wrangled values ----
  vals <- app$get_js("
    $('#wrangle_data-wrangled thead th').map(function() {
      return $(this).text();
    }).get();
  ") |> as.character()

  ### Test check ----
  testthat::expect_true("flag_muac" %in% vals)
        testthat::expect_true(app$get_js("$('#ipc_check-checked').length > 0"))

  ### Stop the app ----
    app$stop()

  }
)


## ---- Data Wrangling: WFHZ and MFAZ ------------------------------------------

testthat::test_that(
  desc = "Server data wrangling works as expected for combined wrangling", {

  ## Initialise app ----
  app <- shinytest2::AppDriver$new(
    app_dir = testthat::test_path("fixtures"),
      load_timeout = 120000,
      wait = TRUE
  )

  ### Let the app load ----
    app$wait_for_idle(timeout = 40000)

    ### Click on the Data uploading navbar ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle(timeout = 40000)

    ### Upload data ----
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

  ### Select input variables ----
  app$set_inputs(`wrangle_data-wrangle` = "combined", wait_ = FALSE)
  app$set_inputs(`wrangle_data-dos` = "", wait_ = FALSE)
  app$set_inputs(`wrangle_data-dob` = "", wait_ = FALSE)
  app$set_inputs(`wrangle_data-age` = "age", wait_ = FALSE)
  app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
  app$set_inputs(`wrangle_data-weight` = "weight", wait_ = FALSE)
  app$set_inputs(`wrangle_data-height` = "height", wait_ = FALSE)
  app$set_inputs(`wrangle_data-muac` = "muac", wait_ = FALSE)

  ### Click wrangle button ----
  app$click(input = "wrangle_data-apply_wrangle")
  app$wait_for_value(output = "wrangle_data-wrangled", timeout = 40000)

  ### Get wrangled values ----
  vals <- app$get_js("
    $('#wrangle_data-wrangled thead th').map(function() {
      return $(this).text();
    }).get();
  ") |> as.character()

  ### Test check ----
  testthat::expect_true(all(vals %in% c(
    "wfhz", "flag_wfhz", "age_days", "mfaz", "flag_mfaz")
  ))
      testthat::expect_true(app$get_js("$('#ipc_check-checked').length > 0"))

  #### Stop the app ----
  app$stop()
  }

)


