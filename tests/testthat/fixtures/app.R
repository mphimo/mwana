## ---- Source mwana app UI and Server files into testthat env -----------------

### UI ----
ui_path <- system.file("app", "ui.R", package = "mwana")
server_path <- system.file("app", "server.R", package = "mwana")

source(file = ui_path, local = TRUE)
source(file = server_path, local = TRUE)

### Create App ----
shiny::shinyApp(ui = ui, server = server)