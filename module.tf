resource "azurerm_storage_account" "storage-account" {
  # Required parameters
  name                     = local.storage_account-name
  resource_group_name      = local.resource_group_name
  location                 = var.location
  account_tier             = var.storage_account.account_tier
  account_replication_type = var.storage_account.account_replication_type

  # Optional parameters
  account_kind                      = try(var.storage_account.account_kind, "StorageV2")
  access_tier                       = try(var.storage_account.access_tier, "Hot")
  https_traffic_only_enabled        = try(var.storage_account.https_traffic_only_enabled, true)
  min_tls_version                   = try(var.storage_account.min_tls_version, "TLS1_2")
  allow_nested_items_to_be_public   = try(var.storage_account.allow_nested_items_to_be_public, false)
  shared_access_key_enabled         = try(var.storage_account.shared_access_key_enabled, false)
  public_network_access_enabled     = try(var.storage_account.public_network_access_enabled, false)
  default_to_oauth_authentication   = try(var.storage_account.default_to_oauth_authentication, false)
  is_hns_enabled                    = try(var.storage_account.is_hns_enabled, false)
  nfsv3_enabled                     = try(var.storage_account.nfsv3_enabled, false)
  cross_tenant_replication_enabled  = try(var.storage_account.cross_tenant_replication_enabled, true)
  large_file_share_enabled          = try(var.storage_account.large_file_share_enabled, null)
  local_user_enabled                = try(var.storage_account.local_user_enabled, null)
  sftp_enabled                      = try(var.storage_account.sftp_enabled, null)
  allowed_copy_scope                = try(var.storage_account.allowed_copy_scope, null)
  edge_zone                         = try(var.storage_account.edge_zone, null)
  dns_endpoint_type                 = try(var.storage_account.dns_endpoint_type, null)
  infrastructure_encryption_enabled = try(var.storage_account.infrastructure_encryption_enabled, null)
  provisioned_billing_model_version = try(var.storage_account.provisioned_billing_model_version, null)
  queue_encryption_key_type         = try(var.storage_account.queue_encryption_key_type, null)
  table_encryption_key_type         = try(var.storage_account.table_encryption_key_type, null)

  # Network rules
  network_rules {
    default_action             = try(var.storage_account.network_rules.default_action, "Deny")
    ip_rules                   = try(var.storage_account.network_rules.ip_rules, [])
    virtual_network_subnet_ids = local.virtual_network_subnet_ids
    bypass                     = try(var.storage_account.network_rules.bypass, ["AzureServices"])
  }

  # Managed identity
  dynamic "identity" {
    for_each = try(var.storage_account.identity, null) != null ? [1] : []
    content {
      type         = var.storage_account.identity.type
      identity_ids = try(var.storage_account.identity.identity_ids, null)
    }
  }

  # Custom domain
  dynamic "custom_domain" {
    for_each = try(var.storage_account.custom_domain, null) != null ? [1] : []
    content {
      name          = var.storage_account.custom_domain.name
      use_subdomain = try(var.storage_account.custom_domain.use_subdomain, null)
    }
  }

  # Customer managed key (requires identity block with UserAssigned)
  dynamic "customer_managed_key" {
    for_each = try(var.storage_account.customer_managed_key, null) != null ? [1] : []
    content {
      key_vault_key_id          = try(var.storage_account.customer_managed_key.key_vault_key_id, null)
      managed_hsm_key_id        = try(var.storage_account.customer_managed_key.managed_hsm_key_id, null)
      user_assigned_identity_id = var.storage_account.customer_managed_key.user_assigned_identity_id
    }
  }

  # Blob properties
  dynamic "blob_properties" {
    for_each = try(var.storage_account.blob_properties, null) != null ? [1] : []
    content {
      versioning_enabled            = try(var.storage_account.blob_properties.versioning_enabled, false)
      change_feed_enabled           = try(var.storage_account.blob_properties.change_feed_enabled, false)
      change_feed_retention_in_days = try(var.storage_account.blob_properties.change_feed_retention_in_days, null)
      default_service_version       = try(var.storage_account.blob_properties.default_service_version, null)
      last_access_time_enabled      = try(var.storage_account.blob_properties.last_access_time_enabled, false)

      dynamic "cors_rule" {
        for_each = try(var.storage_account.blob_properties.cors_rule, [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "delete_retention_policy" {
        for_each = try(var.storage_account.blob_properties.delete_retention_policy, null) != null ? [1] : []
        content {
          days                     = try(var.storage_account.blob_properties.delete_retention_policy.days, 7)
          permanent_delete_enabled = try(var.storage_account.blob_properties.delete_retention_policy.permanent_delete_enabled, false)
        }
      }

      dynamic "restore_policy" {
        for_each = try(var.storage_account.blob_properties.restore_policy, null) != null ? [1] : []
        content {
          days = var.storage_account.blob_properties.restore_policy.days
        }
      }

      dynamic "container_delete_retention_policy" {
        for_each = try(var.storage_account.blob_properties.container_delete_retention_policy, null) != null ? [1] : []
        content {
          days = try(var.storage_account.blob_properties.container_delete_retention_policy.days, 7)
        }
      }
    }
  }

  # Queue properties (Standard StorageV2 or Storage only)
  dynamic "queue_properties" {
    for_each = try(var.storage_account.queue_properties, null) != null ? [1] : []
    content {
      dynamic "cors_rule" {
        for_each = try(var.storage_account.queue_properties.cors_rule, [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "logging" {
        for_each = try(var.storage_account.queue_properties.logging, null) != null ? [1] : []
        content {
          delete                = var.storage_account.queue_properties.logging.delete
          read                  = var.storage_account.queue_properties.logging.read
          version               = var.storage_account.queue_properties.logging.version
          write                 = var.storage_account.queue_properties.logging.write
          retention_policy_days = try(var.storage_account.queue_properties.logging.retention_policy_days, null)
        }
      }

      dynamic "minute_metrics" {
        for_each = try(var.storage_account.queue_properties.minute_metrics, null) != null ? [1] : []
        content {
          enabled               = var.storage_account.queue_properties.minute_metrics.enabled
          version               = var.storage_account.queue_properties.minute_metrics.version
          include_apis          = try(var.storage_account.queue_properties.minute_metrics.include_apis, null)
          retention_policy_days = try(var.storage_account.queue_properties.minute_metrics.retention_policy_days, null)
        }
      }

      dynamic "hour_metrics" {
        for_each = try(var.storage_account.queue_properties.hour_metrics, null) != null ? [1] : []
        content {
          enabled               = var.storage_account.queue_properties.hour_metrics.enabled
          version               = var.storage_account.queue_properties.hour_metrics.version
          include_apis          = try(var.storage_account.queue_properties.hour_metrics.include_apis, null)
          retention_policy_days = try(var.storage_account.queue_properties.hour_metrics.retention_policy_days, null)
        }
      }
    }
  }

  # Share properties (Standard StorageV2/Storage or Premium FileStorage)
  dynamic "share_properties" {
    for_each = try(var.storage_account.share_properties, null) != null ? [1] : []
    content {
      dynamic "cors_rule" {
        for_each = try(var.storage_account.share_properties.cors_rule, [])
        content {
          allowed_headers    = cors_rule.value.allowed_headers
          allowed_methods    = cors_rule.value.allowed_methods
          allowed_origins    = cors_rule.value.allowed_origins
          exposed_headers    = cors_rule.value.exposed_headers
          max_age_in_seconds = cors_rule.value.max_age_in_seconds
        }
      }

      dynamic "retention_policy" {
        for_each = try(var.storage_account.share_properties.retention_policy, null) != null ? [1] : []
        content {
          days = try(var.storage_account.share_properties.retention_policy.days, 7)
        }
      }

      dynamic "smb" {
        for_each = try(var.storage_account.share_properties.smb, null) != null ? [1] : []
        content {
          versions                        = try(var.storage_account.share_properties.smb.versions, null)
          authentication_types            = try(var.storage_account.share_properties.smb.authentication_types, null)
          kerberos_ticket_encryption_type = try(var.storage_account.share_properties.smb.kerberos_ticket_encryption_type, null)
          channel_encryption_type         = try(var.storage_account.share_properties.smb.channel_encryption_type, null)
          multichannel_enabled            = try(var.storage_account.share_properties.smb.multichannel_enabled, false)
        }
      }
    }
  }

  # Azure Files authentication
  dynamic "azure_files_authentication" {
    for_each = try(var.storage_account.azure_files_authentication, null) != null ? [1] : []
    content {
      directory_type                 = var.storage_account.azure_files_authentication.directory_type
      default_share_level_permission = try(var.storage_account.azure_files_authentication.default_share_level_permission, null)

      dynamic "active_directory" {
        for_each = try(var.storage_account.azure_files_authentication.active_directory, null) != null ? [1] : []
        content {
          domain_name         = var.storage_account.azure_files_authentication.active_directory.domain_name
          domain_guid         = var.storage_account.azure_files_authentication.active_directory.domain_guid
          domain_sid          = try(var.storage_account.azure_files_authentication.active_directory.domain_sid, null)
          storage_sid         = try(var.storage_account.azure_files_authentication.active_directory.storage_sid, null)
          forest_name         = try(var.storage_account.azure_files_authentication.active_directory.forest_name, null)
          netbios_domain_name = try(var.storage_account.azure_files_authentication.active_directory.netbios_domain_name, null)
        }
      }
    }
  }

  # Routing preferences
  dynamic "routing" {
    for_each = try(var.storage_account.routing, null) != null ? [1] : []
    content {
      publish_internet_endpoints  = try(var.storage_account.routing.publish_internet_endpoints, false)
      publish_microsoft_endpoints = try(var.storage_account.routing.publish_microsoft_endpoints, false)
      choice                      = try(var.storage_account.routing.choice, "MicrosoftRouting")
    }
  }

  # Account-level immutability policy (forces new resource on changes)
  dynamic "immutability_policy" {
    for_each = try(var.storage_account.immutability_policy, null) != null ? [1] : []
    content {
      allow_protected_append_writes = var.storage_account.immutability_policy.allow_protected_append_writes
      state                         = var.storage_account.immutability_policy.state
      period_since_creation_in_days = var.storage_account.immutability_policy.period_since_creation_in_days
    }
  }

  # Static website — accepts true (boolean) for defaults or an object with custom documents
  # Note: deprecated in azurerm v4, superseded by azurerm_storage_account_static_website in v5
  dynamic "static_website" {
    for_each = try(tobool(var.storage_account.static_website), var.storage_account.static_website != null, false) == true ? [1] : []
    content {
      index_document     = try(var.storage_account.static_website.index_document, "index.html")
      error_404_document = try(var.storage_account.static_website.error_404_document, null)
    }
  }

  # SAS policy - only valid if shared key access is enabled
  dynamic "sas_policy" {
    for_each = try(var.storage_account.shared_access_key_enabled, false) == true ? [1] : []
    content {
      expiration_action = try(var.storage_account.sas_policy.expiration_action, "Log")         # Only possible value is Log, setting it as a variable in case this changes
      expiration_period = try(var.storage_account.sas_policy.expiration_period, "90.00:00:00") # Format for expiration period is DD.HH:MM:SS. Default to 90 days
    }
  }

  # Tags - Merging tags provided by ESLZ with tags provided by the user
  tags = merge(var.tags, try(var.storage_account.tags, {}))

  # Private link access gets added by policy, ignoring changes to better fit with it
  lifecycle {
    ignore_changes = [network_rules[0].private_link_access]
  }
}

# Calls this module if we need a private endpoint attached to the storage account
module "private_endpoint" {
  source   = "github.com/canada-ca-terraform-modules/terraform-azurerm-caf-private_endpoint.git?ref=v1.0.2"
  for_each = try(var.storage_account.private_endpoint, {})

  name                           = "${local.storage_account-name}-${each.key}"
  location                       = var.location
  resource_groups                = var.resource_groups
  subnets                        = var.subnets
  private_connection_resource_id = azurerm_storage_account.storage-account.id
  private_endpoint               = each.value
  private_dns_zone_ids           = var.private_dns_zone_ids
  tags                           = var.tags
}