locals {
  # This creates a list of subnet IDs that will be accepted in the network rules block
  # We can get an abritrarily long list of both IDs and names, so we need to leave the IDs as is and transform the names to IDs with the subnet list provided by ESLZ
  virtual_network_subnet_ids = [
    for subnet in try(var.storage_account.network_rules.virtual_network_subnet, []) : 
        strcontains(subnet, "providers") ? subnet : var.subnets[subnet].id
  ]
  
  # If we received an RG ID, then the ID must have /resourceGroups/ in the string. In that case we leave it as is, if not we can get the ID with the RG list provided with ESLZ
  # ID will be used to create the name of the Storage account to create a unique string
  resource_group_id = strcontains(var.storage_account.resource_group, "/resourceGroups/") ? var.storage_account.resource_group : var.resource_groups[var.storage_account.resource_group].id

  # If we received an RG ID, then the name of the RG will be everything after the last / and is mapped by the regex. If we received the name then we still need to get the complete name
  resource_group_name = strcontains(var.storage_account.resource_group, "/resourceGroups/") ? regex("[^\\/]+$", var.storage_account.resource_group) :  var.resource_groups[var.storage_account.resource_group].name
}