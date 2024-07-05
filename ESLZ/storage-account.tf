variable "storageaccounts" {
  description = "Storage accounts to deploy"
  type        = any
  default     = {}
}

module "storage-account" {
  source   = "/home/max/devops/modules/terraform-azurerm-caf-storage-accountv2"
  for_each = var.storageaccounts

  userDefinedString = each.key
  location = var.location
  env = var.env
  resource_group = local.resource_groups_L2.Project
  storage_account = each.value
  subnets = local.subnets
  tags = var.tags
}
