# ==============================================================================
#  Test Suite: Module IPC Check
# ==============================================================================

## ---- IPC check on survey data -----------------------------------------------

### Skip test on windows ----
# if (identical(Sys.getenv("CI"), "true") && Sys.info()[["sysname"]] == "Windows") {
#   skip("Skipping shinytest2 integration tests on Windows CI to reduce runtime")
# }


testthat::test_that(
  "IPC check's server module behaves as expected on survey data",
  {
    ### Initialise mwana app ----
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

    ### Click on the Data uploading navbar ----
    app$click(selector = "a[data-value='IPC Check']")
    app$wait_for_idle(timeout = 40000)

    #### Set IPC Check for survey data ----
    app$set_inputs(`ipc_check-ipccheck` = "survey", wait_ = FALSE)
    app$wait_for_idle(timeout = 40000)

    #### Now set parameters for survey ----
    app$set_inputs(`ipc_check-area1` = "area", wait_ = FALSE)
    app$set_inputs(`ipc_check-area2` = "", wait_ = FALSE)
    app$set_inputs(`ipc_check-psu` = "cluster", wait_ = FALSE)

    #### Run check ----
    app$click(input = "ipc_check-apply_check")
    app$wait_for_value(output = "ipc_check-checked", timeout = 40000)

    ### Test check ----
    testthat::expect_true(app$get_js("$('#ipc_check-checked').length > 0"))
    expect_equal(
      object = app$get_js("
    $('#ipc_check-checked thead th').map(function() {
      return $(this).text();
    }).get();
  ")[1:4] |> as.character(),
      expected = c(
        "area", "n_clusters", "n_obs", "meet_ipc"
      )
    )
  }
)

## ---- IPC Check on screening data --------------------------------------------

### Skip test on windows ----
# if (identical(Sys.getenv("CI"), "true") && Sys.info()[["sysname"]] == "Windows") {
#   skip("Skipping shinytest2 integration tests on Windows CI to reduce runtime")
# }

testthat::test_that(
  "IPC check's server module behaves as expected on screening data",
  {
    ### Initialise mwana app ----
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

    #### Set IPC Check for screening data ----
    app$set_inputs(`ipc_check-ipccheck` = "screening", wait_ = TRUE, timeout_ = 10000)
    app$wait_for_idle(timeout = 40000)

    ### Click on the Data uploading navbar ----
    app$click(selector = "a[data-value='IPC Check']")
    app$wait_for_idle(timeout = 40000)

    #### Now set parameters for survey ----
    app$set_inputs(`ipc_check-area1` = "area", wait_ = FALSE)
    app$set_inputs(`ipc_check-area2` = "sex", wait_ = FALSE)
    app$set_inputs(`ipc_check-sites` = "cluster", wait_ = FALSE)

    #### Run check ----
    app$click(input = "ipc_check-apply_check")
    app$wait_for_value(output = "ipc_check-checked", timeout = 40000)

    testthat::expect_true(app$get_js("$('#ipc_check-checked').length > 0"))
    expect_equal(
      object = app$get_js("
    $('#ipc_check-checked thead th').map(function() {
      return $(this).text();
    }).get();
  ")[1:5] |> as.character(),
      expected = c(
        "area", "sex", "n_clusters", "n_obs", "meet_ipc"
      )
    )
  }
)

## ---- IPC Check on sentinel site data ----------------------------------------

### Skip test on windows ----
# if (identical(Sys.getenv("CI"), "true") && Sys.info()[["sysname"]] == "Windows") {
#   skip("Skipping shinytest2 integration tests on Windows CI to reduce runtime")
# }

testthat::test_that(
  "IPC check's server module behaves as expected on sentinel site data",
  {
    ### Initialise mwana app ----
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

    ### Click on the IPC Check nav bar ----
    app$click(selector = "a[data-value='IPC Check']")

    #### Set IPC Check for screening data ----
    app$set_inputs(`ipc_check-ipccheck` = "sentinel", wait_ = TRUE, timeout_ = 10000)
    app$wait_for_idle(timeout = 40000)

    #### Now set parameters for survey ----
    app$set_inputs(`ipc_check-area1` = "area", wait_ = FALSE)
    app$set_inputs(`ipc_check-area2` = "sex", wait_ = FALSE)
    app$set_inputs(`ipc_check-ssites` = "cluster", wait_ = FALSE)

    #### Run check ----
    app$click(input = "ipc_check-apply_check")
    app$wait_for_value(output = "ipc_check-checked", timeout = 40000)

    #### Test checks ----
    testthat::expect_true(app$get_js("$('#ipc_check-checked').length > 0"))
    expect_equal(
      object = app$get_js("
    $('#ipc_check-checked thead th').map(function() {
      return $(this).text();
    }).get();
  ")[1:5] |> as.character(),
      expected = c(
        "area", "sex", "n_clusters", "n_obs", "meet_ipc"
      )
    )
  }
)
