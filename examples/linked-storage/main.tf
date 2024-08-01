module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "dev"]
}

module "rg" {
  source  = "cloudnationhq/rg/azure"
  version = "~> 0.1"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

module "storage1" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 0.1"

  storage = {
    name          = "stdemodev1"
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
  }
}

module "storage2" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 0.1"

  storage = {
    name          = "stdemodev2"
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
  }
}

module "analytics" {
  source  = "cloudnationhq/law/azure"
  version = "~> 0.1"

  law = {
    name          = module.naming.log_analytics_workspace.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    linked_storage = {
      customlogs = {
        data_source_type    = "CustomLogs"
        storage_account_ids = [module.storage1.account.id]
      },
      alerts = {
        data_source_type    = "Alerts"
        storage_account_ids = [module.storage2.account.id]
      }
    }
  }
}
