# Export Rules

This submodule illustrates how to manage data export rules.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.61 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 3.61 |

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_data_export_rule.rule](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_data_export_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_export_rules"></a> [export\_rules](#input\_export\_rules) | contains all log analytics data export rules | `any` | n/a | yes |
| <a name="input_resourcegroup"></a> [resourcegroup](#input\_resourcegroup) | contains the resourcegroup name | `string` | `null` | no |
