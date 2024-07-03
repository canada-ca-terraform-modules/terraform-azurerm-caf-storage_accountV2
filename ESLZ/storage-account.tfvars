storageaccounts = [
  {
    deploy = true 
    userDefinedString = "maxTest"
    account_tier = "Standard"
    account_kind = "StorageV2"
    account_replication_type = "GRS"
    allow_nested_items_to_be_public = false
    
    private_endpoint = {
      deploy = false
      subnet_name = "OZ"
      subresource_name = ["file"]
    }

    # network_rules = {
    #   default_action = "Deny"
    #   ip_rules = []
    #   virtual_network_subnet = ["OZ", "MAZ"]
    #   bypass = ["AzureServices"]
    # }
  }, 
  {
    deploy = true
    userDefinedString = "testetst"
    account_tier = "Standard"
    account_kind = "StorageV2"
    account_replication_type = "GRS"
    allow_nested_items_to_be_public = false
    
    private_endpoint = {
      deploy = true
      subnet_name = "MAZ"
      subresource_name = ["file"]
    }
    # network_rules = {
    #   default_action = "Deny"
    #   ip_rules = []
    #   virtual_network_subnet = ["OZ"]
    #   bypass = ["AzureServices"]
    # }
  },
  {
    deploy = false 
    userDefinedString = "something"
    account_tier = "Standard"
    account_kind = "BlobStorage"
    account_replication_type = "GRS"
    allow_nested_items_to_be_public = false

    network_rules = {
      default_action = "Deny"
      ip_rules = []
      virtual_network_subnet = ["PAZ", "MAZ"]
      bypass = ["AzureServices"]
    }
  }
]
