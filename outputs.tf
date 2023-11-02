output "workspace" {
  description = "Contains all log analytics workspace settings"
  value       = azurerm_log_analytics_workspace.ws
}

output "subscriptionId" {
  description = "Contains the current subscription id"
  value       = data.azurerm_subscription.current.subscription_id
}

output "solutions" {
  value = azurerm_log_analytics_solution.solutions
}
