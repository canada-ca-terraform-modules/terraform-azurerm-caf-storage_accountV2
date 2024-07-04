storageaccounts = [
  {
    deploy                          = true
    userDefinedString               = "example01"
    account_tier                    = "Standard"
    account_kind                    = "StorageV2"
    account_replication_type        = "GRS"
    allow_nested_items_to_be_public = false
    public_network_access_enabled   = false
    static_website                  = true

    private_endpoint = {
      deploy           = true
      subnet_name      = "OZ"
      subresource_name = ["blob"]
    }
  },
  {
    deploy                          = true
    userDefinedString               = "example02"
    account_tier                    = "Standard"
    account_kind                    = "StorageV2"
    account_replication_type        = "GRS"
    allow_nested_items_to_be_public = false
    public_network_access_enabled   = true

    private_endpoint = {
      deploy           = true
      subnet_name      = "MAZ"
      subresource_name = ["blob"]
    }

    network_rules = {
      default_action         = "Deny"
      ip_rules               = ["20.116.129.177"]
      virtual_network_subnet = []
      bypass                 = ["AzureServices"]
    }
  }
]
