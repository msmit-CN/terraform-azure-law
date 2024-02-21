module "naming" {
  source  = "cloudnationhq/naming/azure"
  version = "~> 0.1"

  suffix = ["demo", "export"]
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

module "storage" {
  source  = "cloudnationhq/sa/azure"
  version = "~> 0.1"

  storage = {
    name          = module.naming.storage_account.name_unique
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name
  }
}

module "analytics" {
  source  = "cloudnationhq/law/azure"
  version = "~> 0.1"

  law = {
    name          = module.naming.log_analytics_workspace.name
    location      = module.rg.groups.demo.location
    resourcegroup = module.rg.groups.demo.name

    export_rules = {
      demo = {
        table_names             = ["Perf"]
        destination_resource_id = module.storage.account.id
      }
    }
  }
}
