This example highlights integrating analytics solutions into a workspace.

## Usage: solutions

```hcl
module "analytics" {
  source  = "cloudnationhq/law/azure"
  version = "~> 0.6"

  law = {
    name          = module.naming.log_analytics_workspace.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    solutions = [
      "ContainerInsights",
      "VMInsights",
      "AzureActivity"
    ]
  }
}
```
