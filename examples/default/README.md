This example illustrates the default log analytics workspace setup, in its simplest form.

## Usage: default

```hcl
module "analytics" {
  source  = "cloudnationhq/law/azure"
  version = "~> 0.5"

  law = {
    name          = module.naming.log_analytics_workspace.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
  }
}
```

## Usage: multiple

Additionally, for certain scenarios, the example below highlights the ability to use multiple log analytic workspaces, enabling a broader setup.

```hcl
module "analytics" {
  source  = "cloudnationhq/law/azure"
  version = "~> 0.1"

  for_each = local.workspaces

  law = each.value
}
```

The module uses a local to iterate, generating a workspace for each key.

```hcl
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
```
