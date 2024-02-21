# data export rules
resource "azurerm_log_analytics_data_export_rule" "rule" {
  for_each = var.export_rules

  name                    = try(each.value.name, each.key)
  resource_group_name     = try(each.value.resourcegroup, var.resourcegroup)
  workspace_resource_id   = each.value.workspace_id
  destination_resource_id = each.value.destination_resource_id
  table_names             = each.value.table_names
  enabled                 = try(each.value.enabled, true)
}
