resource "azurerm_storage_account" "storage-account" {
  # Required parameters
  name                     = local.storage_account-name
  resource_group_name      = var.resource_group.name
  location                 = var.location
  account_tier             = var.storage_account.account_tier
  account_replication_type = var.storage_account.account_replication_type

  # Optional parameters
  account_kind                     = try(var.storage_account.account_kind, "StorageV2")
  access_tier                      = try(var.storage_account.access_tier, "Hot")
  enable_https_traffic_only        = try(var.storage_account.enable_https_traffic_only, true)
  min_tls_version                  = try(var.storage_account.min_tls_version, "TLS1_2")
  allow_nested_items_to_be_public  = try(var.storage_account.allow_nested_items_to_be_public, false)
  shared_access_key_enabled        = try(var.storage_account.shared_access_key_enabled, true)
  public_network_access_enabled    = try(var.storage_account.public_network_access_enabled, true)
  default_to_oauth_authentication  = try(var.storage_account.default_to_oauth_authentication, false)
  is_hns_enabled                   = try(var.storage_account.is_hns_enabled, false)
  nfsv3_enabled                    = try(var.storage_account.nfsv3_enabled, false)
  cross_tenant_replication_enabled = try(var.storage_account.cross_tenant_replication_enabled, true)

  network_rules {
    default_action             = try(var.storage_account.network_rules.default_action, "Allow")
    ip_rules                   = try(var.storage_account.network_rules.ip_rules, [])
    virtual_network_subnet_ids = var.subnet_id
    bypass                     = try(var.storage_account.network_rules.bypass, null)
  }


  # Tags
  tags = var.tags

  lifecycle {
    ignore_changes = [tags, ]
  }
}

module "private_endpoint" {
  source = "/home/max/devops/modules/terraform-azurerm-caf-private-endpoint"
  count = var.private_endpoint.deploy == true ? 1 : 0
  name = "${local.storage_account-name}-pe"
  location = var.location
  resource_group = var.resource_group
  subnet_id = var.private_endpoint.subnet_id
  private_connection_resource_id = azurerm_storage_account.storage-account.id
  subresource_names = var.private_endpoint.subresource_names


}
