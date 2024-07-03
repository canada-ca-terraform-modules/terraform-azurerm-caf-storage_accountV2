variable "storageaccounts" {
  description = "Storage accounts to deploy"
  type        = any
  default     = []
}

locals {
  # Tupple containing the storage accounts to be deployed (i.e have deploy = true in the definition)
  storage-account-deploy-list = {
    for x, sa in var.storageaccounts : 
    tostring(sa.userDefinedString) => sa if try(sa.deploy,  true) != false
  }
  # Map containing the subnet ids for the network rules for all storage accounts to be deployed. Necessary since tfvars only defines the name of the subnet
  # Same order as in storage-account-deploy-list, so the index match
  subnet_ids = [
    for i in try(local.storage-account-deploy-list, []): {
      for j in try(i.network_rules.virtual_network_subnet, []):
        "${i.userDefinedString}${j}" => local.subnets[j].id
    }
  ]
}

# Need to use count instead of for_each to control access to both objects at the same time
module "storage-account" {
  source   = "/home/max/devops/modules/terraform-azurerm-caf-storage-accountv2"
  count = length(local.storage-account-deploy-list)

  userDefinedString = local.storage-account-deploy-list[keys(local.storage-account-deploy-list)[count.index]].userDefinedString
  location = var.location
  env = var.env
  resource_group = local.resource_groups_L2.Project
  storage_account = local.storage-account-deploy-list[keys(local.storage-account-deploy-list)[count.index]]
  subnet_id = values(local.subnet_ids[count.index])

  private_endpoint = {
    deploy = local.storage-account-deploy-list[keys(local.storage-account-deploy-list)[count.index]].private_endpoint.deploy
    subnet_id = local.subnets[local.storage-account-deploy-list[keys(local.storage-account-deploy-list)[count.index]].private_endpoint.subnet_name].id
    subresource_names = local.storage-account-deploy-list[keys(local.storage-account-deploy-list)[count.index]].private_endpoint.subresource_name
  }

  tags = var.tags
}
