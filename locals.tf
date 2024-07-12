locals {
  virtual_network_subnet_ids = [
    for subnet in try(var.storage_account.network_rules.virtual_network_subnet, []) : 
        strcontains(subnet, "providers") ? subnet : var.subnets[subnet].id
  ]

  resource_group_id = strcontains(var.storage_account.resource_group, "/resourceGroups/") ? var.storage_account.resource_group : var.resource_groups[var.storage_account.resource_group].id
  resource_group_name = strcontains(var.storage_account.resource_group, "/resourceGroups/") ? regex("[^\\/]+$", var.storage_account.resource_group) :  var.resource_groups[var.storage_account.resource_group].name
}