data "azurerm_subscription" "current" {}

# workspaces
resource "azurerm_log_analytics_workspace" "ws" {
  name                = var.law.name
  resource_group_name = var.law.resourcegroup
  location            = var.law.location
  sku                 = try(var.law.sku, "PerGB2018")

  daily_quota_gb                          = try(var.law.daily_quota_gb, null)
  internet_ingestion_enabled              = try(var.law.internet_ingestion_enabled, true)
  internet_query_enabled                  = try(var.law.internet_query_enabled, true)
  retention_in_days                       = try(var.law.retention, 30)
  reservation_capacity_in_gb_per_day      = try(var.law.reservation_capacity_in_gb_per_day, null)
  allow_resource_only_permissions         = try(var.law.allow_resource_only_permissions, true)
  cmk_for_query_forced                    = try(var.law.cmk_for_query_forced, false)
  data_collection_rule_id                 = try(var.law.data_collection_rule_id, null)
  local_authentication_disabled           = try(var.law.local_authentication_disabled, false)
  immediate_data_purge_on_30_days_enabled = try(var.law.immediate_data_purge_on_30_days_enabled, false)
}

# solutions
resource "azurerm_log_analytics_solution" "solutions" {
  for_each = local.solutions

  solution_name         = each.key
  location              = each.value.location
  resource_group_name   = each.value.resourcegroup
  workspace_resource_id = each.value.workspace_id
  workspace_name        = each.value.workspace_name

  plan {
    publisher = each.value.publisher
    product   = each.value.product
  }
}

# data export rules
resource "azurerm_log_analytics_data_export_rule" "rule" {
  for_each = length(lookup(var.law, "export_rules", {})) > 0 ? lookup(var.law, "export_rules", {}) : {}

  name                    = try(each.value.name, each.key)
  resource_group_name     = try(each.value.resourcegroup, var.law.resourcegroup)
  workspace_resource_id   = azurerm_log_analytics_workspace.ws.id
  destination_resource_id = each.value.destination_resource_id
  table_names             = each.value.table_names
  enabled                 = try(each.value.enabled, true)
}
