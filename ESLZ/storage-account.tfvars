storageaccounts = {
  example01 = {                           # Key defines the userDefinedString
    resource_group           = "Project"  # Required: Resource group name, i.e Project, Management, DNS, etc, or the resource group ID
    account_tier             = "Standard" # Required: Possible values: Standard,Premium
    account_replication_type = "GRS"      # Required: Possible values: LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS

    account_kind                     = "StorageV2"   # Optional: possible values: BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2. Default: StorageV2
    access_tier                      = "Hot"         # Optional: Possible values: Hot, Cool. Default: Hot
    public_network_access_enabled    = false         # Optional: Possible values: true, false. Default: false
    allow_nested_items_to_be_public  = false         # Optional: Possible values: true, false. Default: false. Can uncomment to set this value
    # https_traffic_only_enabled        = true        # Optional: Possible values: true, false. Default: true. Can uncomment to set this value
    # min_tls_version                  = "TLS1_2"    # Optional: Possible values: TLS1_0, TLS1_1, TLS1_2. Default: TLS1_2. Can uncomment to set this value
    # shared_access_key_enabled        = false       # Optional: Possible values: true, false. Default: false. Can uncomment to set this value
    # default_to_oauth_authentication  = false       # Optional: Possible values: true, false. Default: false. Can uncomment to set this value
    # is_hns_enabled                   = false       # Optional: Possible values: true, false. Default: false. Can uncomment to set this value
    # nfsv3_enabled                    = false       # Optional: Possible values: true, false. Default: false. Can uncomment to set this value
    # cross_tenant_replication_enabled = true        # Optional: Possible values: true, false. Default: true. Can uncomment to set this value

    # static_website = false                         # Optional: Set to true to enable static website with an empty index.html file. Default: false

    # Optional: Set network rules for the storage account. public_network_access_enabled needs to be set to true for this block to properly work
    # Can uncomment to deploy it
    # network_rules = {
    #   default_action             = "Deny"            # Default: Deny
    #   ip_rules                   = []                # List of IP permitted to access the storage account
    #   virtual_network_subnet_ids = ["MAZ", "OZ"]     # List of subnet permitted to access the storage account. Values can either be name, i.e MAZ, OZ, etc, or subnet ID
    #   bypass                     = ["AzureServices"] # Default: AzureServices. List of Services/resources allowed to bypass firewall.
    # }

    # Sets SAS policies, only valid if the shared_access_key_enabled is set to true
    #sas_policy = {
    #   expiration_period = "90.00:00:00"              # Required: Format for the period is DD.HH:MM:SS
    #   expiration_action = "Log"                      # Optional: Only possible value is Log
    # }

    # Optional: Defines a private endpoint for the storage account
    # Can be commented out if no private endpoint is required
    private_endpoint = {
      blob = {                                                  # Key defines the userDefinedstring
        resource_group    = "Project"                           # Required: Resource group name, i.e Project, Management, DNS, etc, or the resource group ID
        subnet            = "OZ"                                # Required: Subnet name, i.e OZ,MAZ, etc, or the subnet ID
        subresource_names = ["blob"]                            # Required: Subresource name determines to what service the private endpoint will connect to. see: https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource for list of subresrouce
        # local_dns_zone    = "privatelink.blob.core.windows.net" # Optional: Name of the local DNS zone for the private endpoint
      }
    }
  }
}
