variable "storageaccounts" {
  description = "Storage accounts to deploy"
  type        = any
  default     = {}
}

module "storage-account" {
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-storage_accountV2.git?ref=v1.0.5"
  for_each = var.storageaccounts

  userDefinedString = each.key
  location = var.location
  env = var.env
  resource_groups = local.resource_groups_all
  storage_account = each.value
  subnets = local.subnets
  private_dns_zone_ids = local.Project-dns-zone
  tags = var.tags
}