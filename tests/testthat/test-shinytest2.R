testthat::test_that("mwana app works as expected", {
  ### Initialise app ----
  app <- shinytest2::AppDriver$new(
    app_dir = testthat::test_path("fixtures"),
    load_timeout = 30000
  )

  ### Wait for the app to fully load ----
  app$wait_for_idle(timeout = 20000)

  ### Click on the Data uploading navbar ----
  app$click(selector = "a[data-value='Data Upload']")
  app$wait_for_idle(timeout = 5000)

  ### Upload data ----
  #### Read data ----
  data <- read.csv(file = here::here("inst", "app", "anthro-01.csv"))
  tempfile <- tempfile(fileext = ".csv")
  write.csv(data, tempfile, row.names = FALSE)

  #### Upload onto the app ----
  app$upload_file(`upload_data-upload` = tempfile, wait_ = TRUE)

  #### Get values ----
  vals <- app$get_values(
    input = "upload_data-upload",
    output = c("upload_data-fileUploaded", "upload_data-uploadedDataTable")
  )

  ### Test checks ----
  testthat::expect_equal(object = vals$input$`upload_data-upload`$size, 75314)
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
      "X", "area", "dos", "cluster", "team", "sex",
      "dob", "age", "weight", "height", "edema", "muac"
    )
  )

  #### Stop the app ----
  app$stop()
})
