# ==============================================================================
#  Test Suite: Module IPC Check
# ==============================================================================

## ---- IPC check on survey data -----------------------------------------------

testthat::test_that(
  "IPC check's server module behaves as expected on survey data",
  {
    ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"),
      load_timeout = 30000
    )

    ### Let the app load ----
    app$wait_for_idle()

    ### Click on the Data uploading navbar ----
    app$click(selector = "a[data-value='IPC Check']")
    app$wait_for_idle()

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

    #### Set IPC Check for survey data ----
    app$set_inputs(`ipc_check-ipccheck` = "survey", wait_ = FALSE, timeout_ = 10000)
    app$wait_for_idle()

    #### Now set parameters for survey ----
    app$set_inputs(`ipc_check-area1` = "area", wait_ = FALSE, timeout_ = 10000)
    app$set_inputs(`ipc_check-area2` = "", wait_ = FALSE, timeout_ = 10000)
    app$set_inputs(`ipc_check-psu` = "cluster", wait_ = FALSE, timeout_ = 10000)

    #### Run check ----
    app$click(input = "ipc_check-apply_check")
    app$wait_for_idle()

    testthat::expect_true(app$get_js("$('#ipc_check-checked').length > 0"))
    expect_equal(
      object = app$get_js("
    $('#ipc_check-checked thead th').map(function() {
      return $(this).text();
    }).get();
  ")[2:5] |> as.character(),
      expected = c(
        "area", "n_clusters", "n_obs", "meet_ipc"
      )
    )
  }
)

## ---- IPC Check on screening data --------------------------------------------

testthat::test_that(
  "IPC check's server module behaves as expected on screening data",
  {
    ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"),
      load_timeout = 30000
    )

    ### Let the app load ----
    app$wait_for_idle()

    ### Click on the Data uploading navbar ----
    app$click(selector = "a[data-value='IPC Check']")
    app$wait_for_idle()

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
    app$set_inputs(`ipc_check-ipccheck` = "screening", wait_ = FALSE, timeout_ = 10000)
    app$wait_for_idle()

    #### Now set parameters for survey ----
    app$set_inputs(`ipc_check-area1` = "area", wait_ = FALSE, timeout_ = 10000)
    app$set_inputs(`ipc_check-area2` = "sex", wait_ = FALSE, timeout_ = 10000)
    app$set_inputs(`ipc_check-sites` = "cluster", wait_ = FALSE, timeout_ = 10000)

    #### Run check ----
    app$click(input = "ipc_check-apply_check")
    app$wait_for_idle()

    testthat::expect_true(app$get_js("$('#ipc_check-checked').length > 0"))
    expect_equal(
      object = app$get_js("
    $('#ipc_check-checked thead th').map(function() {
      return $(this).text();
    }).get();
  ")[2:6] |> as.character(),
      expected = c(
        "area", "sex", "n_clusters", "n_obs", "meet_ipc"
      )
    )
  }
)

## ---- IPC Check on sentinel site data ----------------------------------------

testthat::test_that(
  "IPC check's server module behaves as expected on sentinel site data",
  {
    ### Initialise mwana app ----
    app <- shinytest2::AppDriver$new(
      app_dir = testthat::test_path("fixtures"),
      load_timeout = 30000
    )

    ### Let the app load ----
    app$wait_for_idle()

    ### Click on the Data uploading navbar ----
    app$click(selector = "a[data-value='IPC Check']")
    app$wait_for_idle()

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
    app$set_inputs(`ipc_check-ipccheck` = "sentinel", wait_ = FALSE, timeout_ = 10000)
    app$wait_for_idle()

    #### Now set parameters for survey ----
    app$set_inputs(`ipc_check-area1` = "area", wait_ = FALSE, timeout_ = 10000)
    app$set_inputs(`ipc_check-area2` = "sex", wait_ = FALSE, timeout_ = 10000)
    app$set_inputs(`ipc_check-ssites` = "cluster", wait_ = FALSE, timeout_ = 10000)

    #### Run check ----
    app$click(input = "ipc_check-apply_check")
    app$wait_for_idle()

    testthat::expect_true(app$get_js("$('#ipc_check-checked').length > 0"))
    expect_equal(
      object = app$get_js("
    $('#ipc_check-checked thead th').map(function() {
      return $(this).text();
    }).get();
  ")[2:6] |> as.character(),
      expected = c(
        "area", "sex", "n_clusters", "n_obs", "meet_ipc"
      )
    )
  }
)
