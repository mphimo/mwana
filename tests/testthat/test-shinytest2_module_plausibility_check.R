# ==============================================================================
#  Test Suite: Module Plausibility Check
# ==============================================================================

## ---- Plausibility Check on WFHZ data ----------------------------------------

### Skip test on windows ----
if (identical(Sys.getenv("CI"), "true") && Sys.info()[["sysname"]] == "Windows") {
  skip("Skipping shinytest2 integration tests on Windows CI to reduce runtime")
}

testthat::test_that(
  desc = "Plausibility check module works well for WFHZ data",
  code = {
    ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"),
      load_timeout = 120000,
      wait = TRUE
    )

    ### Let the app load ----
    app$wait_for_idle(timeout = 40000)

    ### Click on data upload tab ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle(timeout = 40000)

    #### Find the data to upload ----
    data <- read.csv(
      file = system.file("app", "anthro-01.csv", package = "mwana"),
      check.names = FALSE
    )

    tempfile <- tempfile(fileext = ".csv")
    write.csv(data, tempfile, row.names = FALSE)

    #### Upload ----
    app$upload_file(`upload_data-upload` = tempfile, wait_ = TRUE)

    ### Click on the data wrangling tab ----
    app$click(selector = "a[data-value='Data Wrangling']")
    app$wait_for_idle(timeout = 40000)

    ### Select data wrangling method ----
    app$set_inputs(`wrangle_data-wrangle` = "wfhz", wait_ = FALSE)

    ### Select input variables ----
    app$set_inputs(`wrangle_data-dos` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-dob` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-age` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`wrangle_data-weight` = "weight", wait_ = FALSE)
    app$set_inputs(`wrangle_data-height` = "height", wait_ = FALSE)

    ### Click wrangle button ----
    app$click(input = "wrangle_data-apply_wrangle")
    app$wait_for_idle(timeout = 40000)

    ### Click on the Plausibility Check tab ----
    app$click(selector = "a[data-value='Plausibility Check']")
    app$wait_for_idle(timeout = 40000)

    ### Select method for plausibility check ----
    app$set_inputs(`plausible-method` = "wfhz", wait_ = FALSE)

    ### Select input variables ----
    app$set_inputs(`plausible-area1` = "area", wait_ = FALSE)
    app$set_inputs(`plausible-area2` = "", wait_ = FALSE)
    app$set_inputs(`plausible-area3` = "", wait_ = FALSE)
    app$set_inputs(`plausible-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`plausible-age` = "age", wait_ = FALSE)
    app$set_inputs(`plausible-weight` = "weight", wait_ = FALSE)
    app$set_inputs(`plausible-height` = "height", wait_ = FALSE)
    app$set_inputs(`plausible-flags` = "flag_wfhz", wait_ = FALSE)

    ### Click on check plausibility button ----
    app$click(input = "plausible-check")
    app$wait_for_value(output = "plausible-checked", timeout = 40000)

    ### Get checked file and assert existing variables agains expected ----
    vals <- app$get_js(
      "$('#plausible-checked thead th').map(function() {
      return $(this).text();
    }).get();"
    )[1:20] |> as.character()

    ### Test check -----
    testthat::expect_equal(
      object = vals,
      expected = c(
        "Area", "Total children", "Flagged data (%)",
        "Class. of flagged data", "Sex ratio (p)", "Class. of sex ratio",
        "Age ratio (p)", "Class. of age ratio", "DPS weight (#)", "Class. DPS weight",
        "DPS height (#)", "Class. DPS height", "Standard Dev* (#)",
        "Class. of standard dev", "Skewness* (#)", "Class. of skewness",
        "Kurtosis* (#)", "Class. of kurtosis", "Overall score", "Overall quality"
      )
    )

    ### Stop the app ----
    app$stop()
  }
)

## ---- Plausibility Check on MFAZ data ----------------------------------------

### Skip test on windows ----
if (identical(Sys.getenv("CI"), "true") && Sys.info()[["sysname"]] == "Windows") {
  skip("Skipping shinytest2 integration tests on Windows CI to reduce runtime")
}

testthat::test_that(
  desc = "Plausibility check module works well for MFAZ data",
  code = {
    # Initialise app ----
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

    ### Select data wrangling method ----
    app$set_inputs(`wrangle_data-wrangle` = "mfaz", wait_ = TRUE, timeout_ = 15000)
    app$wait_for_idle(timeout = 40000)

    app$set_inputs(`wrangle_data-dos` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-dob` = "", wait_ = FALSE)
    app$set_inputs(`wrangle_data-age` = "age", wait_ = FALSE)
    app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`wrangle_data-muac` = "muac", wait_ = FALSE)

    ### Click wrangle button ----
    app$click(input = "wrangle_data-apply_wrangle")
    app$wait_for_idle(timeout = 40000)

    ### Click on the Plausibility Check tab ----
    app$click(selector = "a[data-value='Plausibility Check']")
    app$wait_for_idle(timeout = 40000)

    ### Select method for plausibility check ----
    app$set_inputs(`plausible-method` = "mfaz", wait_ = TRUE, timeout_ = 15000)

    ### Select input variables ----
    app$set_inputs(`plausible-area1` = "area", wait_ = FALSE)
    app$set_inputs(`plausible-area2` = "", wait_ = FALSE)
    app$set_inputs(`plausible-area3` = "", wait_ = FALSE)
    app$set_inputs(`plausible-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`plausible-age` = "age", wait_ = FALSE)
    app$set_inputs(`plausible-muac` = "muac", wait_ = FALSE)
    app$set_inputs(`plausible-flags` = "flag_mfaz", wait_ = FALSE)

    ### Click on check plausibility button ----
    app$click(input = "plausible-check")
    app$wait_for_value(output = "plausible-checked", timeout = 40000)

    ### Get checked file and assert existing variables agains expected ----
    vals <- app$get_js(
      "$('#plausible-checked thead th').map(function() {
      return $(this).text();
    }).get();"
    )[1:18] |> as.character()

    ### Test check ----
    testthat::expect_equal(
      object = vals,
      expected = c(
        "Area", "Total children", "Flagged data (%)",
        "Class. of flagged data", "Sex ratio (p)", "Class. of sex ratio",
        "Age ratio (p)", "Class. of age ratio", "DPS (#)",
        "Class. of DPS", "Standard Dev* (#)", "Class. of standard dev",
        "Skewness* (#)", "Class. of skewness", "Kurtosis* (#)",
        "Class. of kurtosis", "Overall score", "Overall quality"
      )
    )
    ### Stop the app ----
    app$stop()
  }
)



## ---- Plausibility Check on raw MUAC data ------------------------------------

### Skip test on windows ----
if (identical(Sys.getenv("CI"), "true") && Sys.info()[["sysname"]] == "Windows") {
  skip("Skipping shinytest2 integration tests on Windows CI to reduce runtime")
}

testthat::test_that(
  desc = "Plausibility check module works well for MUAC data",
  code = {
    ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"),
      load_timeout = 120000, 
      wait = TRUE
    )

    ### Let the app load ----
    app$wait_for_idle(timeout = 40000)

    ### Click on data upload tab ----
    app$click(selector = "a[data-value='Data Upload']")
    app$wait_for_idle(timeout = 40000)

    #### Find the data to upload ----
    data <- read.csv(
      file = system.file("app", "anthro-01.csv", package = "mwana"),
      check.names = FALSE
    )

    tempfile <- tempfile(fileext = ".csv")
    write.csv(data, tempfile, row.names = FALSE)

    #### Upload ----
    app$upload_file(`upload_data-upload` = tempfile, wait_ = TRUE)

    ### Click on the data wrangling tab ----
    app$click(selector = "a[data-value='Data Wrangling']")
    app$wait_for_idle(timeout = 40000)

    ### Select data wrangling method ----
    app$set_inputs(`wrangle_data-wrangle` = "muac", wait_ = TRUE, timeout_ = 15000)
    app$wait_for_idle(timeout = 40000)

    ### Select input variables ----
    app$set_inputs(`wrangle_data-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`wrangle_data-muac` = "muac", wait_ = FALSE)

    ### Click wrangle button ----
    app$click(input = "wrangle_data-apply_wrangle")
    app$wait_for_idle(timeout = 40000)

    ### Click on the Plausibility Check tab ----
    app$click(selector = "a[data-value='Plausibility Check']")
    app$wait_for_idle(timeout = 40000)

    ### Select method for plausibility check ----
    app$set_inputs(`plausible-method` = "muac", wait_ = TRUE, timeout_ = 15000)
    app$wait_for_idle(timeout = 40000)

    ### Select input variables ----
    app$set_inputs(`plausible-area1` = "area", wait_ = FALSE)
    app$set_inputs(`plausible-area2` = "", wait_ = FALSE)
    app$set_inputs(`plausible-area3` = "", wait_ = FALSE)
    app$set_inputs(`plausible-sex` = "sex", wait_ = FALSE)
    app$set_inputs(`plausible-muac` = "muac", wait_ = FALSE)
    app$set_inputs(`plausible-flags` = "flag_muac", wait_ = FALSE)

    ### Click on check plausibility button
    app$click(input = "plausible-check")
    app$wait_for_value(output = "plausible-checked", timeout = 40000)

    ### Get checked file and assert existing variables agains expected ----
    vals <- app$get_js(
      "$('#plausible-checked thead th').map(function() {
      return $(this).text();
    }).get();"
    )[1:10] |> as.character()

    ### Test check -----
    testthat::expect_equal(
      object = vals,
      expected = c(
        "Area", "Total children", "Flagged data (%)",
        "Class. of flagged data", "Sex ratio (p)", "Class. of sex ratio", "DPS(#)",
        "Class. of DPS", "Standard Dev* (#)", "Class. of standard dev"
      )
    )

    ### Stop the app ----
    app$stop()
  }
)
