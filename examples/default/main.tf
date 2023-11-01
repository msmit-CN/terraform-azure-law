module "naming" {
  source = "github.com/cloudnationhq/az-cn-module-tf-naming"

  suffix = ["demo", "dev"]
}

module "rg" {
  source = "github.com/cloudnationhq/az-cn-module-tf-rg"

  groups = {
    demo = {
      name   = module.naming.resource_group.name
      region = "westeurope"
    }
  }
}

//module "analitics" {
//  source = "../../"
//
//  law = {
//    name          = module.naming.log_analytics_workspace.name
//    location      = module.rg.groups.demo.location
//    resourcegroup = module.rg.groups.demo.name
//  }
//}

module "analytics" {
  source = "../../"

  for_each = local.workspaces

  law = each.value
}
