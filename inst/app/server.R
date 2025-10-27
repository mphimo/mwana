# ==============================================================================
#                               SERVER LOGIC
# ==============================================================================

## ---- Server's definitions ---------------------------------------------------

server <- function(input, output, session) {
  
  ### Upload module - returns reactive data ----
  df <- mwana:::module_server_upload(id = "upload_data")
  
  ### IPC check module - pass the reactive data ----
  ipc_results <- mwana:::module_server_ipccheck(id = "ipc_check", data = df)
  
  ### Data Wrangling ----
  wrangled <- mwana:::module_server_wrangling(id = "wrangle_data", data = df)

  ### Plausibility Check ----
  mwana:::module_server_plausibility_check(id = "plausible", data = wrangled)

  ### Prevalence ----
  mwana:::module_server_prevalence(id = "prevalence", data = wrangled)

}