locals {
  virtual_network_subnet_ids = [
    for subnet in try(var.storage_account.network_rules.virtual_network_subnet, []) : 
        strcontains(subnet, "providers") ? subnet : var.subnets[subnet].id
  ]
}