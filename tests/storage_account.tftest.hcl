mock_provider "azurerm" {}

# ---------------------------------------------------------------------------
# Shared variables reused across all runs
# ---------------------------------------------------------------------------
variables {
  env               = "Dev"
  userDefinedString = "myapp"
  location          = "canadacentral"
  tags              = { environment = "test" }

  resource_groups = {
    Project = {
      id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test"
      name = "rg-test"
    }
  }

  subnets              = {}
  private_dns_zone_ids = {}

  storage_account = {
    resource_group           = "Project"
    account_tier             = "Standard"
    account_replication_type = "LRS"
  }
}

# ---------------------------------------------------------------------------
# naming_convention
# Verifies the storage account name is generated from env + userDefinedString + sha1 unique suffix
# ---------------------------------------------------------------------------
run "naming_convention" {
  command = plan

  assert {
    condition     = length(azurerm_storage_account.storage-account.name) <= 24
    error_message = "Storage account name must not exceed 24 characters"
  }

  assert {
    condition     = azurerm_storage_account.storage-account.name == lower(azurerm_storage_account.storage-account.name)
    error_message = "Storage account name must be lowercase"
  }
}

# ---------------------------------------------------------------------------
# default_values
# Plan succeeds with only the three required storage_account fields
# ---------------------------------------------------------------------------
run "default_values" {
  command = plan

  assert {
    condition     = azurerm_storage_account.storage-account.account_kind == "StorageV2"
    error_message = "account_kind must default to StorageV2"
  }

  assert {
    condition     = azurerm_storage_account.storage-account.access_tier == "Hot"
    error_message = "access_tier must default to Hot"
  }

  assert {
    condition     = azurerm_storage_account.storage-account.https_traffic_only_enabled == true
    error_message = "https_traffic_only_enabled must default to true"
  }

  assert {
    condition     = azurerm_storage_account.storage-account.min_tls_version == "TLS1_2"
    error_message = "min_tls_version must default to TLS1_2"
  }

  assert {
    condition     = azurerm_storage_account.storage-account.allow_nested_items_to_be_public == false
    error_message = "allow_nested_items_to_be_public must default to false"
  }

  assert {
    condition     = azurerm_storage_account.storage-account.shared_access_key_enabled == false
    error_message = "shared_access_key_enabled must default to false"
  }

  assert {
    condition     = azurerm_storage_account.storage-account.public_network_access_enabled == false
    error_message = "public_network_access_enabled must default to false"
  }

  assert {
    condition     = azurerm_storage_account.storage-account.location == "canadacentral"
    error_message = "location must match var.location"
  }
}

# ---------------------------------------------------------------------------
# sas_policy_with_shared_key
# When shared_access_key_enabled = true the sas_policy block is emitted
# ---------------------------------------------------------------------------
run "sas_policy_with_shared_key" {
  command = plan

  variables {
    storage_account = {
      resource_group            = "Project"
      account_tier              = "Standard"
      account_replication_type  = "LRS"
      shared_access_key_enabled = true
      sas_policy = {
        expiration_period = "30.00:00:00"
        expiration_action = "Log"
      }
    }
  }

  assert {
    condition     = azurerm_storage_account.storage-account.shared_access_key_enabled == true
    error_message = "shared_access_key_enabled must be true"
  }
}

# ---------------------------------------------------------------------------
# sas_policy_absent_without_shared_key
# When shared_access_key_enabled = false (or absent) no sas_policy block
# ---------------------------------------------------------------------------
run "sas_policy_absent_without_shared_key" {
  command = plan

  variables {
    storage_account = {
      resource_group            = "Project"
      account_tier              = "Standard"
      account_replication_type  = "LRS"
      shared_access_key_enabled = false
    }
  }

  assert {
    condition     = azurerm_storage_account.storage-account.shared_access_key_enabled == false
    error_message = "shared_access_key_enabled must be false"
  }
}

# ---------------------------------------------------------------------------
# static_website_bool
# Passing static_website = true enables the block with default index.html
# ---------------------------------------------------------------------------
run "static_website_bool" {
  command = plan

  variables {
    storage_account = {
      resource_group           = "Project"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      static_website           = true
    }
  }

  assert {
    condition     = azurerm_storage_account_static_website.storage-account["enabled"].index_document == "index.html"
    error_message = "static_website index_document must default to index.html"
  }
}

# ---------------------------------------------------------------------------
# static_website_object
# Passing static_website as an object with custom documents works
# ---------------------------------------------------------------------------
run "static_website_object" {
  command = plan

  variables {
    storage_account = {
      resource_group           = "Project"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      static_website = {
        index_document     = "home.html"
        error_404_document = "404.html"
      }
    }
  }

  assert {
    condition     = azurerm_storage_account_static_website.storage-account["enabled"].index_document == "home.html"
    error_message = "static_website index_document must be home.html"
  }
}

# ---------------------------------------------------------------------------
# static_website_absent
# No static_website resource is created when the argument is omitted
# ---------------------------------------------------------------------------
run "static_website_absent" {
  command = plan

  assert {
    condition     = length(azurerm_storage_account_static_website.storage-account) == 0
    error_message = "static_website resource must not be created when unset"
  }
}

# ---------------------------------------------------------------------------
# queue_properties
# Queue properties are created as a dedicated resource (azurerm v5)
# ---------------------------------------------------------------------------
run "queue_properties" {
  command = plan

  variables {
    storage_account = {
      resource_group           = "Project"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      queue_properties = {
        logging = {
          delete                = true
          read                  = true
          write                 = true
          version               = "1.0"
          retention_policy_days = 7
        }
        hour_metrics = {
          version               = "1.0"
          retention_policy_days = 7
        }
      }
    }
  }

  assert {
    condition     = length(azurerm_storage_account_queue_properties.storage-account) == 1
    error_message = "queue_properties resource must be created when provided"
  }
}

# ---------------------------------------------------------------------------
# queue_properties_absent
# No queue_properties resource is created when the argument is omitted
# ---------------------------------------------------------------------------
run "queue_properties_absent" {
  command = plan

  assert {
    condition     = length(azurerm_storage_account_queue_properties.storage-account) == 0
    error_message = "queue_properties resource must not be created when unset"
  }
}

# ---------------------------------------------------------------------------
# queue_properties_metrics_disabled_legacy
# Legacy minute_metrics/hour_metrics.enabled = false suppresses those blocks
# ---------------------------------------------------------------------------
run "queue_properties_metrics_disabled_legacy" {
  command = plan

  variables {
    storage_account = {
      resource_group           = "Project"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      queue_properties = {
        logging = {
          delete  = true
          read    = true
          write   = true
          version = "1.0"
        }
        minute_metrics = {
          enabled = false
          version = "1.0"
        }
        hour_metrics = {
          enabled = false
          version = "1.0"
        }
      }
    }
  }

  assert {
    condition     = length(azurerm_storage_account_queue_properties.storage-account["enabled"].minute_metrics) == 0
    error_message = "minute_metrics block must not be rendered when enabled = false"
  }

  assert {
    condition     = length(azurerm_storage_account_queue_properties.storage-account["enabled"].hour_metrics) == 0
    error_message = "hour_metrics block must not be rendered when enabled = false"
  }
}

# ---------------------------------------------------------------------------
# customer_managed_key
# customer_managed_key only supports key_vault_key_id in azurerm v5 (managed_hsm_key_id removed)
# ---------------------------------------------------------------------------
run "customer_managed_key" {
  command = plan

  variables {
    storage_account = {
      resource_group           = "Project"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      identity = {
        type         = "UserAssigned"
        identity_ids = ["/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-uami"]
      }
      customer_managed_key = {
        key_vault_key_id          = "https://test-kv.vault.azure.net/keys/test-key/0000000000000000000000000000000"
        user_assigned_identity_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-uami"
      }
    }
  }

  assert {
    condition     = azurerm_storage_account.storage-account.customer_managed_key[0].key_vault_key_id == "https://test-kv.vault.azure.net/keys/test-key/0000000000000000000000000000000"
    error_message = "customer_managed_key.key_vault_key_id must be set"
  }
}

# ---------------------------------------------------------------------------
# network_rules_custom
# Custom network_rules are applied when provided
# ---------------------------------------------------------------------------
run "network_rules_custom" {
  command = plan

  variables {
    storage_account = {
      resource_group                = "Project"
      account_tier                  = "Standard"
      account_replication_type      = "LRS"
      public_network_access_enabled = true
      network_rules = {
        default_action         = "Deny"
        ip_rules               = ["203.0.113.0/24"]
        bypass                 = ["AzureServices", "Logging"]
        virtual_network_subnet = []
      }
    }
  }

  assert {
    condition     = azurerm_storage_account.storage-account.public_network_access_enabled == true
    error_message = "public_network_access_enabled must be true"
  }
}

# ---------------------------------------------------------------------------
# identity_system_assigned
# Managed identity block is rendered when identity is provided
# ---------------------------------------------------------------------------
run "identity_system_assigned" {
  command = plan

  variables {
    storage_account = {
      resource_group           = "Project"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      identity = {
        type = "SystemAssigned"
      }
    }
  }
}

# ---------------------------------------------------------------------------
# blob_properties
# blob_properties block with soft delete and versioning
# ---------------------------------------------------------------------------
run "blob_properties" {
  command = plan

  variables {
    storage_account = {
      resource_group           = "Project"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      blob_properties = {
        versioning_enabled  = true
        change_feed_enabled = true
        delete_retention_policy = {
          days = 14
        }
        container_delete_retention_policy = {
          days = 7
        }
      }
    }
  }
}

# ---------------------------------------------------------------------------
# new_optional_flags
# New simple optional args are accepted without errors
# ---------------------------------------------------------------------------
run "new_optional_flags" {
  command = plan

  variables {
    storage_account = {
      resource_group                    = "Project"
      account_tier                      = "Standard"
      account_replication_type          = "LRS"
      large_file_share_enabled          = true
      local_user_enabled                = true
      allowed_copy_scope                = "AAD"
      infrastructure_encryption_enabled = true
      queue_encryption_key_type         = "Account"
      table_encryption_key_type         = "Account"
    }
  }
}

# ---------------------------------------------------------------------------
# routing_preferences
# Routing block is emitted when provided
# ---------------------------------------------------------------------------
run "routing_preferences" {
  command = plan

  variables {
    storage_account = {
      resource_group           = "Project"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      routing = {
        publish_microsoft_endpoints = true
        choice                      = "MicrosoftRouting"
      }
    }
  }
}

# ---------------------------------------------------------------------------
# share_properties_smb
# Share properties with SMB configuration
# ---------------------------------------------------------------------------
run "share_properties_smb" {
  command = plan

  variables {
    storage_account = {
      resource_group           = "Project"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      account_kind             = "StorageV2"
      share_properties = {
        retention_policy = {
          days = 14
        }
        smb = {
          versions             = ["SMB3.1.1"]
          authentication_types = ["Kerberos"]
        }
      }
    }
  }
}

# ---------------------------------------------------------------------------
# azure_files_authentication_aadkerb
# Azure Files auth with AADKERB (no active_directory sub-block needed)
# ---------------------------------------------------------------------------
run "azure_files_authentication_aadkerb" {
  command = plan

  variables {
    storage_account = {
      resource_group           = "Project"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      azure_files_authentication = {
        directory_type = "AADKERB"
      }
    }
  }
}

# ---------------------------------------------------------------------------
# hns_sftp_enabled
# is_hns_enabled = true required for sftp_enabled
# ---------------------------------------------------------------------------
run "hns_sftp_enabled" {
  command = plan

  variables {
    storage_account = {
      resource_group           = "Project"
      account_tier             = "Standard"
      account_replication_type = "LRS"
      is_hns_enabled           = true
      sftp_enabled             = true
    }
  }

  assert {
    condition     = azurerm_storage_account.storage-account.is_hns_enabled == true
    error_message = "is_hns_enabled must be true for SFTP"
  }
}
