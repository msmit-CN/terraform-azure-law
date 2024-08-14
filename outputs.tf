output "workspace" {
  description = "contains all log analytics workspace settings"
  value       = azurerm_log_analytics_workspace.ws
}

output "subscription_id" {
  description = "contains the current subscription id"
  value       = data.azurerm_subscription.current.subscription_id
}

output "solutions" {
  description = "contains log analytics solutions"
  value       = azurerm_log_analytics_solution.solutions
}
