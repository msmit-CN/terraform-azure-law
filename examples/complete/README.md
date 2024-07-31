# Complete

This example highlights the complete usage.

## Types

```hcl
law = object({
  name          = string
  location      = string
  resourcegroup = string
  export_rules = optional(map(object({
    table_names             = list(string)
    destination_resource_id = string
  })))
  solutions = optional(list(string))
})
```
