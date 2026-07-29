storageaccounts = {
  example01 = {                           # Key defines the userDefinedString
    resource_group           = "Project"  # Required: Resource group name, i.e Project, Management, DNS, etc, or the resource group ID
    account_tier             = "Standard" # Required: Possible values: Standard, Premium
    account_replication_type = "GRS"      # Required: Possible values: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS

    account_kind                    = "StorageV2" # Optional: possible values: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2. Default: StorageV2
    access_tier                     = "Hot"       # Optional: Possible values: Hot, Cool, Cold, Premium. Default: Hot
    public_network_access_enabled   = false       # Optional: Possible values: true, false. Default: false
    allow_nested_items_to_be_public = false       # Optional: Possible values: true, false. Default: false
    # https_traffic_only_enabled        = true        # Optional: Possible values: true, false. Default: true
    # min_tls_version                  = "TLS1_2"    # Optional: Possible values: TLS1_0, TLS1_1, TLS1_2. Default: TLS1_2
    # shared_access_key_enabled        = false       # Optional: Possible values: true, false. Default: false
    # default_to_oauth_authentication  = false       # Optional: Possible values: true, false. Default: false
    # is_hns_enabled                   = false       # Optional: Possible values: true, false. Default: false. Required for SFTP and Data Lake Gen2
    # nfsv3_enabled                    = false       # Optional: Possible values: true, false. Default: false. Requires is_hns_enabled = true
    # cross_tenant_replication_enabled = true        # Optional: Possible values: true, false. Default: true
    # large_file_share_enabled         = false       # Optional: Possible values: true, false. Default: false
    # local_user_enabled               = true        # Optional: Possible values: true, false. Default: true
    # sftp_enabled                     = false       # Optional: Possible values: true, false. Default: false. Requires is_hns_enabled = true
    # allowed_copy_scope               = "AAD"       # Optional: Possible values: AAD, PrivateLink
    # dns_endpoint_type                = "Standard"  # Optional: Possible values: Standard, AzureDnsZone. Default: Standard. Forces new resource
    # infrastructure_encryption_enabled = false      # Optional: Possible values: true, false. Default: false. Forces new resource
    # provisioned_billing_model_version = "V2"       # Optional: Only valid for FileStorage. Forces new resource
    # queue_encryption_key_type        = "Service"   # Optional: Possible values: Service, Account. Default: Service. Forces new resource
    # table_encryption_key_type        = "Service"   # Optional: Possible values: Service, Account. Default: Service. Forces new resource
    # edge_zone                        = ""          # Optional: Edge Zone name within the Azure Region. Forces new resource

    # Optional: Managed identity for the storage account
    # identity = {
    #   type         = "SystemAssigned"          # Required: Possible values: SystemAssigned, UserAssigned, "SystemAssigned, UserAssigned"
    #   identity_ids = []                        # Optional: Required when type is UserAssigned or "SystemAssigned, UserAssigned"
    # }

    # Optional: Customer managed key encryption (requires UserAssigned identity)
    # customer_managed_key = {
    #   key_vault_key_id          = "<key-vault-key-id>"          # Required: managed_hsm_key_id was removed in azurerm v5, use key_vault_key_id only
    #   user_assigned_identity_id = "<user-assigned-identity-id>" # Required
    # }

    # Optional: Custom domain for the storage account
    # custom_domain = {
    #   name          = "blob.example.com" # Required: Custom domain name
    #   use_subdomain = false              # Optional: Use indirect CNAME validation
    # }

    # Optional: Blob service properties
    # blob_properties = {
    #   versioning_enabled            = false  # Optional: Default: false
    #   change_feed_enabled           = false  # Optional: Default: false
    #   change_feed_retention_in_days = null   # Optional: 1-146000 days. null = infinite
    #   default_service_version       = null   # Optional: e.g. "2020-06-12"
    #   last_access_time_enabled      = false  # Optional: Default: false
    #   cors_rule = [
    #     {
    #       allowed_headers    = ["*"]
    #       allowed_methods    = ["GET", "HEAD"]
    #       allowed_origins    = ["https://example.com"]
    #       exposed_headers    = ["ETag"]
    #       max_age_in_seconds = 3600
    #     }
    #   ]
    #   delete_retention_policy = {
    #     days                     = 7     # Optional: 1-365. Default: 7
    #     permanent_delete_enabled = false # Optional: Default: false
    #   }
    #   restore_policy = {
    #     days = 6 # Required: Must be less than delete_retention_policy.days
    #   }
    #   container_delete_retention_policy = {
    #     days = 7 # Optional: 1-365. Default: 7
    #   }
    # }

    # Optional: Queue service properties (Standard StorageV2 or Storage only)
    # Note: rendered as a dedicated azurerm_storage_account_queue_properties resource (azurerm v5). At least one of
    # logging, minute_metrics, hour_metrics or cors_rule must be set. minute_metrics/hour_metrics no longer accept "enabled"
    # in azurerm v5, but legacy "enabled = false" is still honored to suppress those blocks.
    # queue_properties = {
    #   logging = {
    #     delete                = true   # Required
    #     read                  = true   # Required
    #     version               = "1.0"  # Required
    #     write                 = true   # Required
    #     retention_policy_days = 7      # Optional
    #   }
    #   minute_metrics = {
    #     version               = "1.0"  # Required
    #     include_apis          = true   # Optional
    #     retention_policy_days = 7      # Optional
    #   }
    #   hour_metrics = {
    #     version               = "1.0"  # Required
    #     include_apis          = true   # Optional
    #     retention_policy_days = 7      # Optional
    #   }
    # }

    # Optional: Share (Files) service properties
    # share_properties = {
    #   retention_policy = {
    #     days = 7 # Optional: 1-365. Default: 7
    #   }
    #   smb = {
    #     versions                        = ["SMB3.1.1"]          # Optional: SMB2.1, SMB3.0, SMB3.1.1
    #     authentication_types            = ["Kerberos"]          # Optional: NTLMv2, Kerberos
    #     kerberos_ticket_encryption_type = ["AES-256"]           # Optional: RC4-HMAC, AES-256
    #     channel_encryption_type         = ["AES-256-GCM"]       # Optional: AES-128-CCM, AES-128-GCM, AES-256-GCM
    #     multichannel_enabled            = false                  # Optional: Default: false. Premium only
    #   }
    # }

    # Optional: Azure Files authentication
    # azure_files_authentication = {
    #   directory_type                 = "AD"    # Required: AADDS, AD, AADKERB
    #   default_share_level_permission = "None"  # Optional: StorageFileDataSmbShareReader, StorageFileDataSmbShareContributor, StorageFileDataSmbShareElevatedContributor, None
    #   active_directory = {                     # Required when directory_type = "AD"
    #     domain_name         = "example.com"    # Required
    #     domain_guid         = "<guid>"         # Required
    #     domain_sid          = "<sid>"          # Optional: Required for AD
    #     storage_sid         = "<sid>"          # Optional: Required for AD
    #     forest_name         = "example.com"    # Optional: Required for AD
    #     netbios_domain_name = "EXAMPLE"        # Optional: Required for AD
    #   }
    # }

    # Optional: Routing preferences
    # routing = {
    #   publish_internet_endpoints  = false               # Optional: Default: false
    #   publish_microsoft_endpoints = false               # Optional: Default: false
    #   choice                      = "MicrosoftRouting"  # Optional: InternetRouting, MicrosoftRouting. Default: MicrosoftRouting
    # }

    # Optional: Account-level immutability policy (forces new resource on changes)
    # immutability_policy = {
    #   allow_protected_append_writes = false      # Required
    #   state                         = "Unlocked" # Required: Disabled, Unlocked, Locked
    #   period_since_creation_in_days = 7          # Required
    # }

    # Optional: Static website — set to true for defaults or supply an object for custom documents
    # Note: rendered as a dedicated azurerm_storage_account_static_website resource (azurerm v5)
    # static_website = true
    # static_website = {
    #   index_document     = "index.html"  # Optional: Default: index.html
    #   error_404_document = "404.html"    # Optional
    # }

    # Optional: Set network rules for the storage account. public_network_access_enabled needs to be set to true for this block to properly work
    # network_rules = {
    #   default_action             = "Deny"            # Default: Deny
    #   ip_rules                   = []                # List of public IPs permitted to access the storage account
    #   virtual_network_subnet_ids = ["MAZ", "OZ"]     # List of subnets permitted. Values can be subnet name (MAZ, OZ) or subnet ID
    #   bypass                     = ["AzureServices"] # Default: AzureServices. List of services allowed to bypass firewall
    # }

    # Optional: SAS policy (only valid if shared_access_key_enabled = true)
    # sas_policy = {
    #   expiration_period = "90.00:00:00" # Required: Format is DD.HH:MM:SS
    #   expiration_action = "Log"         # Optional: Log or Block. Default: Log
    # }

    # Optional: Configure blob service properties
    # blob_properties = {
    #   delete_retention_policy = {
    #     days                     = 7     # Optional: Number of days to retain soft-deleted blobs
    #     permanent_delete_enabled = false # Optional: Enable permanent deletion for soft-deleted blobs
    #   }
    # }

    # Optional: Defines a private endpoint for the storage account
    private_endpoint = {
      blob = {                        # Key defines the userDefinedString
        resource_group    = "Project" # Required: Resource group name or ID
        subnet            = "OZ"      # Required: Subnet name or ID
        subresource_names = ["blob"]  # Required: See https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
        # local_dns_zone  = "privatelink.blob.core.windows.net" # Optional: Name of the local DNS zone
      }
    }
  }
}
