data "azurerm_subscription" "current" {}

# workspaces
resource "azurerm_log_analytics_workspace" "ws" {
  name                = var.workspace.name
  resource_group_name = coalesce(lookup(var.workspace, "resource_group", null), var.resource_group)
  location            = coalesce(lookup(var.workspace, "location", null), var.location)
  sku                 = try(var.workspace.sku, "PerGB2018")

  daily_quota_gb                          = try(var.workspace.daily_quota_gb, null)
  internet_ingestion_enabled              = try(var.workspace.internet_ingestion_enabled, true)
  internet_query_enabled                  = try(var.workspace.internet_query_enabled, true)
  retention_in_days                       = try(var.workspace.retention, 30)
  reservation_capacity_in_gb_per_day      = try(var.workspace.reservation_capacity_in_gb_per_day, null)
  allow_resource_only_permissions         = try(var.workspace.allow_resource_only_permissions, true)
  cmk_for_query_forced                    = try(var.workspace.cmk_for_query_forced, false)
  data_collection_rule_id                 = try(var.workspace.data_collection_rule_id, null)
  local_authentication_disabled           = try(var.workspace.local_authentication_disabled, false)
  immediate_data_purge_on_30_days_enabled = try(var.workspace.immediate_data_purge_on_30_days_enabled, false)
  tags                                    = try(var.workspace.tags, {})

  dynamic "identity" {
    for_each = lookup(var.workspace, "identity", null) != null ? [lookup(var.workspace, "identity", {})] : []

    content {
      type = lookup(identity.value, "type", "SystemAssigned")
      identity_ids = lookup(identity.value, "type", "SystemAssigned") == "UserAssigned" ? (
        lookup(identity.value, "identity_ids", null) != null ?
        identity.value.identity_ids :
        [for uai in azurerm_user_assigned_identity.identity : uai.id]
      ) : null
    }
  }
}

# solutions
resource "azurerm_log_analytics_solution" "solutions" {
  for_each = local.solutions

  solution_name         = each.key
  location              = each.value.location
  resource_group_name   = each.value.resource_group
  workspace_resource_id = each.value.workspace_id
  workspace_name        = each.value.workspace_name
  tags                  = each.value.tags

  plan {
    publisher = each.value.publisher
    product   = each.value.product
  }
}

# data export rules
resource "azurerm_log_analytics_data_export_rule" "rule" {
  for_each = length(lookup(var.workspace, "export_rules", {})) > 0 ? lookup(var.workspace, "export_rules", {}) : {}

  name                    = try(each.value.name, each.key)
  resource_group_name     = try(each.value.resource_group, var.workspace.resource_group)
  workspace_resource_id   = azurerm_log_analytics_workspace.ws.id
  destination_resource_id = each.value.destination_resource_id
  table_names             = each.value.table_names
  enabled                 = try(each.value.enabled, true)
}

# user assigned identity
resource "azurerm_user_assigned_identity" "identity" {
  for_each = lookup(var.workspace, "identity", null) != null ? (

    lookup(var.workspace.identity, "type", null) == "UserAssigned" &&
    lookup(var.workspace.identity, "identity_ids", null) == null ? { "identity" = var.workspace.identity } : {}
  ) : {}

  name                = lookup(each.value, "name", "uai-${var.workspace.name}")
  location            = coalesce(lookup(each.value, "location", null), var.workspace.location)
  resource_group_name = coalesce(lookup(each.value, "resource_group", null), var.workspace.resource_group)
  tags                = try(var.workspace.tags, var.tags, null)
}

# linked services, applicable for automation accounts only
resource "azurerm_log_analytics_linked_service" "link" {
  for_each = contains(keys(var.workspace), "linked_service") ? { "linked" = "service" } : {}

  resource_group_name = try(each.value.resource_group, var.workspace.resource_group)
  workspace_id        = azurerm_log_analytics_workspace.ws.id
  read_access_id      = lookup(var.workspace.linked_service, "read_access_id", null)
  write_access_id     = lookup(var.workspace.linked_service, "write_access_id", null)
}

# linked storage
resource "azurerm_log_analytics_linked_storage_account" "link" {
  for_each = lookup(var.workspace, "linked_storage", {})

  data_source_type      = each.value.data_source_type
  resource_group_name   = try(each.value.resource_group, var.workspace.resource_group)
  workspace_resource_id = azurerm_log_analytics_workspace.ws.id
  storage_account_ids   = each.value.storage_account_ids
}
