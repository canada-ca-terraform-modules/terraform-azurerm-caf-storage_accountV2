resource "azurerm_storage_account" "storage-account" {
  # Required parameters
  name                     = local.storage_account-name
  resource_group_name      = local.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account.account_tier
  account_replication_type = var.storage_account.account_replication_type

  # Optional parameters
  account_kind                     = try(var.storage_account.account_kind, "StorageV2")
  access_tier                      = try(var.storage_account.access_tier, "Hot")
  https_traffic_only_enabled        = try(var.storage_account.https_traffic_only_enabled, true)
  min_tls_version                  = try(var.storage_account.min_tls_version, "TLS1_2")
  allow_nested_items_to_be_public  = try(var.storage_account.allow_nested_items_to_be_public, false)
  shared_access_key_enabled        = try(var.storage_account.shared_access_key_enabled, false)
  public_network_access_enabled    = try(var.storage_account.public_network_access_enabled, false)
  default_to_oauth_authentication  = try(var.storage_account.default_to_oauth_authentication, false)
  is_hns_enabled                   = try(var.storage_account.is_hns_enabled, false)
  nfsv3_enabled                    = try(var.storage_account.nfsv3_enabled, false)
  cross_tenant_replication_enabled = try(var.storage_account.cross_tenant_replication_enabled, true)

  # Network rules
  network_rules {
    default_action             = try(var.storage_account.network_rules.default_action, "Deny")
    ip_rules                   = try(var.storage_account.network_rules.ip_rules, [])
    virtual_network_subnet_ids = local.virtual_network_subnet_ids
    bypass                     = try(var.storage_account.network_rules.bypass, ["AzureServices"])
  }

  # Static website
  dynamic "static_website" {
    for_each = try(var.storage_account.static_website, "false") == true ? [1] : []
    content {
      index_document = "index.html"
    }
  }

  # SAS  policy - only valid is shared key access is enabled
  dynamic "sas_policy" {
    for_each = try(var.storage_account.shared_access_key_enabled, false) == true ? [1] : []
    content {
      expiration_action = try(var.storage_account.sas_policy.expiration_action, "Log")            # Only possible value if Log, setting it as a variable in case this changes
      expiration_period = try(var.storage_account.sas_policy.expiration_period, "90.00:00:00")    # Format for expiration period is DD.HH:MM:SS. Default to 90 days
    }
  }

  # Tags - Merging tags provided by ESLZ with tags provided by the user
  tags = merge(var.tags, try(var.storage_account.tags, {}))

  # Private link access gets added by policy, ignoring changes to better fit with it
  lifecycle {
    ignore_changes = [ network_rules[0].private_link_access ]
  }
}

# Calls this module if we need a private endpoint attached to the storage account
module "private_endpoint" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-private_endpoint.git?ref=v1.0.2"
  for_each =  try(var.storage_account.private_endpoint, {}) 

  name = "${local.storage_account-name}-${each.key}"
  location = var.location
  resource_groups = var.resource_groups
  subnets = var.subnets
  private_connection_resource_id = azurerm_storage_account.storage-account.id
  private_endpoint = each.value
  private_dns_zone_ids = var.private_dns_zone_ids
  tags = var.tags
}