storageaccounts = {
 example01 = {
    account_tier = "Standard"
    account_kind = "StorageV2"
    account_replication_type = "GRS"
    allow_nested_items_to_be_public = false
    public_network_access_enabled = false
    static_website = true
    
    private_endpoint = {
      blob = {
        subnet_name = "OZ"
        subresource_names = ["blob"]
      }
      file = {
        subnet_name = "MAZ"
        subresource_names = ["file"]
      }
    }
  }, 
  example02 = {
    account_tier = "Standard"
    account_kind = "StorageV2"
    account_replication_type = "GRS"
    allow_nested_items_to_be_public = false
    public_network_access_enabled = true
    
    # private_endpoint = {
    #   deploy = true
    #   subnet_name = "MAZ"
    #   subresource_name = ["blob"]
    # }

    network_rules = {
      default_action = "Deny"
      ip_rules = []
      virtual_network_subnet = ["MAZ", 
      "/subscriptions/723c47ad-1a6f-437f-ac31-e21989a464f7/resourceGroups/ScSc-CPMS_MMahdavian_Network-rg/providers/Microsoft.Network/virtualNetworks/ScScCNR-CPMS_MMahdavian-vnet/subnets/ScScCNR-CPMS_MMahdavian_OZ-snet"]
      bypass = ["AzureServices"]
    }
  }
}
