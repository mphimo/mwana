# ==============================================================================
#                               SERVER LOGIC
# ==============================================================================

## ---- Server's definitions ---------------------------------------------------

server <- function(input, output, session) {
  
  ### Upload module - returns reactive data ----
  df <- module_server_upload(id = "upload_data")
  
  ### IPC check module - pass the reactive data ----
  ipc_results <- module_server_ipccheck(id = "ipc_check", data = df)
  
  ### Data Wrangling ----
  wrangled <- module_server_wrangling(id = "wrangle_data", data = df)

}