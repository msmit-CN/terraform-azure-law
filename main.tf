data "azurerm_subscription" "current" {}

# workspaces
resource "azurerm_log_analytics_workspace" "ws" {
  name                = var.law.name
  resource_group_name = coalesce(lookup(var.law, "resourcegroup", null), var.resourcegroup)
  location            = coalesce(lookup(var.law, "location", null), var.location)
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
  tags                                    = try(var.law.tags, {})

  dynamic "identity" {
    for_each = lookup(var.law, "identity", null) != null ? [lookup(var.law, "identity", {})] : []

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
  resource_group_name   = each.value.resourcegroup
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
  for_each = length(lookup(var.law, "export_rules", {})) > 0 ? lookup(var.law, "export_rules", {}) : {}

  name                    = try(each.value.name, each.key)
  resource_group_name     = try(each.value.resourcegroup, var.law.resourcegroup)
  workspace_resource_id   = azurerm_log_analytics_workspace.ws.id
  destination_resource_id = each.value.destination_resource_id
  table_names             = each.value.table_names
  enabled                 = try(each.value.enabled, true)
}

# user assigned identity
resource "azurerm_user_assigned_identity" "identity" {
  for_each = lookup(var.law, "identity", null) != null ? (

    lookup(var.law.identity, "type", null) == "UserAssigned" &&
    lookup(var.law.identity, "identity_ids", null) == null ? { "identity" = var.law.identity } : {}
  ) : {}

  name                = lookup(each.value, "name", "uai-${var.law.name}")
  location            = coalesce(lookup(each.value, "location", null), var.law.location)
  resource_group_name = coalesce(lookup(each.value, "resourcegroup", null), var.law.resourcegroup)
  tags                = try(var.law.tags, var.tags, null)
}

resource "azurerm_log_analytics_linked_service" "linked" {
  for_each = contains(keys(var.law), "linked_service") ? { "linked" = "service" } : {}

  resource_group_name = var.law.resourcegroup
  workspace_id        = azurerm_log_analytics_workspace.ws.id
  read_access_id      = lookup(var.law.linked_service, "read_access_id", null)
  write_access_id     = lookup(var.law.linked_service, "write_access_id", null)
}
