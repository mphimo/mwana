## ---- Source mwana app UI and Server files into testthat env -----------------

### UI ----
ui_path <- here::here("inst", "app", "ui.R")
server_path <- here::here("inst", "app", "server.R")

source(file = ui_path, local = TRUE)
source(file = server_path, local = TRUE)

### Create App ----
shiny::shinyApp(ui = ui, server = server)