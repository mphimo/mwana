# ==============================================================================
#                               SERVER LOGIC
# ==============================================================================

## ---- Server's definitions ---------------------------------------------------

server <- function(input, output, session) {

  ### Capture reactive values ----
  values <- reactiveValues(
    data = NULL,
    processing = FALSE,
    file_uploaded = FALSE 
  )

  uploaded_data <- mod_upload_server(id = "upload_data", values = values)
}