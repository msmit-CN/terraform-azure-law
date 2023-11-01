This example demonstrates the use of solutions within a log analytics workspace. Solutions enable specific analytic capabilities to be integrated within a workspace, essentially providing them tailored insights.

## Usage: solutions

```hcl
module "law" {
  source = "../../"

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
