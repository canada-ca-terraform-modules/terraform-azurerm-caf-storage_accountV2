## Requirements

No requirements.

## Providers

| Name | 
|------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_endpoint"></a> [private\_endpoint](#module\_private\_endpoint) | /home/max/devops/modules/terraform-azurerm-caf-private-endpoint | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_account.storage-account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
|<a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | (Required) UserDefinedString part of the name of the storage account | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | (Required) env value | `string` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | (Required) Resource group object of the storage account | `any` | n/a | yes |
| <a name="input_storage_account"></a> [storage\_account](#input\_storage\_account) | (Required) Object describing the storage account | `any` | `{}` | yes |
| <a name="input_location"></a> [location](#input\_location) | Azure location where the storage account will be situated | `string` | `"canadacentral"` | no |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | Object containing the private DNS zone IDs of the subscription. Used to configure private endpoints | `any` | `{}` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | Object containing parameter to private endpoint | `any` | `{}` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of subnets objects | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to be applied to the storage account | `map(string)` | `{}` | no |
| 

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Returns the ID of the storage account |
| <a name="output_name"></a> [name](#output\_name) | Returns the name of the storage account |
| <a name="output_storage-account-object"></a> [storage-account-object](#output\_storage-account-object) | Returns the Azure Storage Account object |

## TFVars Parameters

For more information about storage account parameters, refer to the terraform docs: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account
| Name | Possible values | Default | Required |
|------|----------|----------------|---------|
| <a name="resource_group"></a> [resource_group](#resource\_group) | Resource group name, i.e Project, Managment, DNS, etc, or resource group ID | n/a | yes |
| <a name="account_tier"></a> [account tier](#account\_tier) | Standard, Premium | n/a | yes |
| <a name="account_replication_type"></a> [account_replication_type](#account\_replication\_type)  | LRS, GRS, RAGRS, ZRS, GZRS, RAGZRS | n/a | yes |
| <a name="account_kind"></a> [account_kind](#account\_kind) | BlobStorage, BlockBlobStorage, FileStorage, Storage, StorageV2 | StorageV2 | no |
| <a name="access_tier"></a> [access_tier](#access\_tier) | Hot, Cool | Hot | no |
| <a name="enable_https_traffic_only"></a> [enable_https_traffic_only](#enable\_https\_traffic\_only) | true, false | true | no |
| <a name="min_tls_version"></a> [min_tls_version](#min\_tls\_version) | TLS1_0, TLS1_1, TLS1_2 | TLS1_2 | no |
| <a name="allow_nested_items_to_be_public"></a> [allow_nested_items_to_be_public](#allow\_nested\_items\_to\_be\_public) | true, false | false | no |
| <a name="shared_access_key_enabled"></a> [shared_access_key_enabled](#shared\_access\_key\_enabled) | true, false | true | no |
| <a name="public_network_access_enabled"></a> [public_network_access_enabled](#public\_network\_access\_enabled) | true, false | false | no |
| <a name="default_to_oauth_authentication"></a> [default_to_oauth_authentication](#default\_to\_oauth\_authentication) | true, false | false | no |
| <a name="is_hns_enabled"></a> [is_hns_enabled](#is\_hns\_enabled) | true, false | false | no |
| <a name="nfsv3_enabled"></a> [nfsv3_enabled](#nfsv3\_enabled) | true, false | false | no |
| <a name="cross_tenant_replication_enabled"></a> [cross_tenant_replication_enabled](#cross\_tenant\_replication\_enabled) | true, false | true | no |
| <a name="static_website"></a> [static_website](#static\_website) | true, false | false | no |
| <a name="network_rules"></a> [network_rules](#network\_rules) | See terraform docs | null | no |
| <a name="private_endpoint"></a> [private_endpoint](#private\_endpoint) | See private_endpoint module docs | null | no |