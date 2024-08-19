# Solutions

This deploys tables within a log analytic workspace.

This resource does not create or destroy tables. This resource is used to update attributes (currently only retention_in_days) of the tables created when a Log Analytics Workspace is created.
Deleting an azurerm_log_analytics_workspace_table resource will not delete the table. Instead, the table's retention_in_days field will be set to the value of azurerm_log_analytics_workspace retention_in_days

## Types

```hcl
workspace = object({
  name           = string
  location       = string
  resource_group = string
  tables      = optional(map(object({
    plan                    = string
    retention_in_days       = number
    total_retention_in_days = number
  })))
})
```

## Notes
The retention_in_days cannot be specified when plan is Basic because the retention is fixed at eight days.