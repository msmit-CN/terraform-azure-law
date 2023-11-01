locals {
  workspaces = {
    ws1 = {
      name          = join("-", [module.naming.log_analytics_workspace.name, "001"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name

      solutions = [
        "ContainerInsights",
        "VMInsights",
        "AzureActivity"
      ]

    },
    ws2 = {
      name          = join("-", [module.naming.log_analytics_workspace.name, "002"])
      location      = module.rg.groups.demo.location
      resourcegroup = module.rg.groups.demo.name

      solutions = [
        "ContainerInsights",
      ]
    }
  }
}
