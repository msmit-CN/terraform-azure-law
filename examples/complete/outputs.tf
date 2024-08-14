output "workspace" {
  value     = module.analytics.workspace
  sensitive = true
}

output "subscription_id" {
  value = module.analytics.subscription_id
}

