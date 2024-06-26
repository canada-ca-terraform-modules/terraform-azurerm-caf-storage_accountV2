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

variable "resource_group" {
  description = "(Required) Resource group object of the storage account"
  type = any
}

variable "location" {
  description = "Azure location where the storage account will be situated"
  type = string
  default = "canadacentral"
}

variable "storage_account" {
  description = "Object describing the storage account"
  type = any
  default = {}
}

variable "subnet_id" {
  description = "Subnet IDs for network rules if applicable"
  type = any
  default = {}
}
