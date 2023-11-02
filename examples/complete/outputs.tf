output "workspace" {
  value     = module.analytics.workspace
  sensitive = true
}

output "subscriptionId" {
  value = module.analytics.subscriptionId
}

