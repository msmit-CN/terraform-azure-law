# Solutions

This deploys solutions within a log analytic workspace

## Types

```hcl
law = object({
  name          = string
  location      = string
  resourcegroup = string
  solutions     = optional(list(string))
})
```
