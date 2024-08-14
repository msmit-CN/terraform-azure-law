# Solutions

This deploys solutions within a log analytic workspace

## Types

```hcl
workspace = object({
  name           = string
  location       = string
  resource_group = string
  solutions      = optional(list(string))
})
```
