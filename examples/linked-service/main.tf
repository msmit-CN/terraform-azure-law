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

module "automation" {
  source  = "cloudnationhq/aa/azure"
  version = "~> 0.1"

  account = {
    name          = module.naming.automation_account.name
    resourcegroup = module.rg.groups.demo.name
    location      = module.rg.groups.demo.location
  }
}

module "analytics" {
  source  = "cloudnationhq/law/azure"
  version = "~> 0.1"

  law = {
    name           = module.naming.log_analytics_workspace.name_unique
    location       = module.rg.groups.demo.location
    resourcegroup  = module.rg.groups.demo.name
    read_access_id = module.automation.account.id
  }
}
