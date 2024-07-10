storageaccounts = {
 example01 = {
    resource_group_name = "Project"
    account_tier = "Standard"
    account_kind = "StorageV2"
    account_replication_type = "GRS"
    allow_nested_items_to_be_public = false
    public_network_access_enabled = false
    static_website = false
    
    private_endpoint = {
      blob = {
        resource_group_name = "Project"
        subnet_name = "OZ"
        subresource_names = ["blob"]
        local_dns_zone = {
          name = "privatelink.blob.core.windows.net"
          # resource_group_name = "DNS"
          # vnetID = "/subscriptions/723c47ad-1a6f-437f-ac31-e21989a464f7/resourceGroups/ScSc-CPMS_MMahdavian_Network-rg/providers/Microsoft.Network/virtualNetworks/ScScCNR-CPMS_MMahdavian-vnet"
          registration_enabled = false
          # soa_record = {
          #   email = "maxime.mahdavianssc-spc.gc.ca"
          # }
        }
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
