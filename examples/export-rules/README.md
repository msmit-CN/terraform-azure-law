This example highlights integrating data export rules into a workspace.

## Usage: export rules

```hcl
module "analytics" {
  source  = "cloudnationhq/law/azure"
  version = "~> 0.8"

  law = {
    name          = module.naming.log_analytics_workspace.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    export_rules = {
      demo = {
        table_names             = ["Perf"]
        destination_resource_id = module.storage.account.id
      }
    }
  }
}
```
