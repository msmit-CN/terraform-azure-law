# Linked Storage

This deploys storage linked to the log analytics workspace.

## Types

```hcl
law = object({
  name            = string
  location        = string
  resourcegroup   = string
  read_access_id  = optional(string)
  write_access_id = optional(string)
  linked_storage  = optional(map(object({
    data_source_type    = string
    resourcegroup       = optional(string)
    storage_account_ids = list(string)
  })))
})
```

## Notes

For data source type alerts, only one storage account can be linked.
