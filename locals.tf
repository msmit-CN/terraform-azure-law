locals {
  solutions = {
    for solution_key, solution in try(var.workspace.solutions, {}) : solution => {
      solution_name  = solution
      publisher      = "Microsoft"
      product        = "OMSGallery/${solution}"
      location       = try(solution.location, var.workspace.location)
      workspace_id   = azurerm_log_analytics_workspace.ws.id
      workspace_name = azurerm_log_analytics_workspace.ws.name
      resource_group = try(solution.resource_group, var.workspace.resource_group)
      tags           = try(solution.tags, var.tags, null)
    }
  }
}
