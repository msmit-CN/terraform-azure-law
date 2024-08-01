# Complete

This example highlights the complete usage.

## Types

```hcl
law = object({
  name          = string
  location      = string
  resourcegroup = string
  identity = optional(object({
    type         = string
    identity_ids = optional(list(string))
  }))
  export_rules = optional(map(object({
    table_names             = list(string)
    destination_resource_id = string
  })))
  solutions = optional(list(string))
})
```

## Notes

When setting the identity type to UserAssigned, the module will generate a user-assigned identity automatically.

However, if you specify identities under the identity_ids property, the module will skip the generating one, and your specified identities will be used instead.
