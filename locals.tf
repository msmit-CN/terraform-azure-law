locals {
  solutions = {
    for solution_key, solution in try(var.law.solutions, {}) : solution => {
      solution_name  = solution
      publisher      = "Microsoft"
      product        = "OMSGallery/${solution}"
      location       = var.law.location
      workspace_id   = azurerm_log_analytics_workspace.ws.id
      workspace_name = azurerm_log_analytics_workspace.ws.name
      resourcegroup  = var.law.resourcegroup
    }
  }
}
