# ==============================================================================
#  Test Suite: Module Data Upload
# ==============================================================================

## ---- Module: Data Upload ----------------------------------------------------

### Skip test on windows ----
if (identical(Sys.getenv("CI"), "true") && Sys.info()[["sysname"]] == "Windows") {
  skip("Skipping shinytest2 integration tests on Windows CI to reduce runtime")
}

testthat::test_that("Data upload tab works as expected", {
  ### Initialise app ----
  app <- shinytest2::AppDriver$new(
    app_dir = testthat::test_path("fixtures"),
    load_timeout = 120000,
    wait = TRUE
  )

  ### Wait for the app to fully load ----
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
  app$wait_for_value(output = "upload_data-uploadedDataTable", timeout = 40000)

  #### Get values ----
  vals <- app$get_values(
    input = "upload_data-upload",
    output = c("upload_data-fileUploaded", "upload_data-uploadedDataTable")
  )

  ### Test checks ----
  testthat::expect_equal(object = vals$input$`upload_data-upload`$size, 78696)
  testthat::expect_equal(object = vals$input$`upload_data-upload`$type, "text/csv")
  testthat::expect_true(object = vals$output$`upload_data-fileUploaded`)
  testthat::expect_true(app$get_js("$('#upload_data-uploadedDataTable').length > 0"))
  expect_equal(
    object = app$get_js("
    $('#upload_data-uploadedDataTable thead th').map(function() {
      return $(this).text();
    }).get();
  ")[1:12] |> as.character(),
    expected = c(
      "area", "dos", "cluster", "team", "sex",
      "dob", "age", "age_cat", "weight", "height", "edema", "muac"
    )
  )

  #### Stop the app ----
  app$stop()
})
