# Linked Service

This deploys a automation account linked to the log analytics workspace.

## Types

```hcl
workspace = object({
  name            = string
  location        = string
  resource_group  = string
  read_access_id  = optional(string)
  write_access_id = optional(string)
  linked_service  = optional(object({
    read_access_id  = optional(string)
    write_access_id = optional(string)
  }))
})
```

## Notes

At least one of read_access_id or write_access_id needs to be specified using the linked service.
