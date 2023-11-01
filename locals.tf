locals {
  solutions = flatten([
    for solution_key, solution in try(var.law.solutions, {}) : {

      solution_key   = solution_key
      publisher      = "Microsoft"
      solution_name  = solution
      product        = "OMSGallery/${solution}"
      location       = var.law.location
      workspace_id   = azurerm_log_analytics_workspace.ws.id
      workspace_name = azurerm_log_analytics_workspace.ws.name
      resourcegroup  = var.law.resourcegroup
    }
  ])
}
