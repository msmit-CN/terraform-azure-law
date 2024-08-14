# Export Rules

This deploys data export rules within a log analytic workspace.

## Types

```hcl
workspace = object({
  name           = string
  location       = string
  resource_group = string
  export_rules  = optional(map(object({
    table_names             = list(string)
    destination_resource_id = string
  })))
})
```

## Notes

Export rules can also be used as a submodule if there is an existing Log Analytics workspace.
