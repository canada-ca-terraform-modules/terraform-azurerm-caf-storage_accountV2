variable "tags" {
  description = "Tags to be applied to the storage account"
  type = map(string)
  default = {}
}

variable "userDefinedString" {
  description = "(Required) UserDefinedString part of the name of the storage account"
  type = string
}

variable "env" {
  description = "(Required) env value"
  type = string
}

variable "resource_groups" {
  description = "(Required) Resource group object of the storage account"
  type = any
}

variable "location" {
  description = "Azure location where the storage account will be situated"
  type = string
  default = "canadacentral"
}

variable "storage_account" {
  description = " (Required) Object describing the storage account"
  type = any
  default = {}
}

variable "subnets" {
  description = "List of subnets objects"
  type = any
  default = {}
}

variable "private_dns_zone_ids" {
  description = "Object containing the private DNS zone IDs of the subscription. Used to configure private endpoints"
  type = any
  default = {}
}

variable "private_endpoint" {
  description = "Object containing parameter to the private endpoint attached to the storage account"
  type = any
  default = {}
}