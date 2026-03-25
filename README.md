## Requirements

Terraform >= 1.9 (terragrunt 0.68.4+) · azurerm provider `~> 4.0`

## Providers

| Name |
|------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_private_endpoint"></a> [private\_endpoint](#module\_private\_endpoint) | github.com/canada-ca-terraform-modules/terraform-azurerm-caf-private_endpoint | v1.0.2 |

## Resources

| Name | Type |
|------|------|
| [azurerm_storage_account.storage-account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_userDefinedString"></a> [userDefinedString](#input\_userDefinedString) | UserDefinedString part of the name of the storage account | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | env value used in name generation | `string` | n/a | yes |
| <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups) | Resource group object map provided by ESLZ | `any` | `{}` | no |
| <a name="input_storage_account"></a> [storage\_account](#input\_storage\_account) | Object describing the storage account (see TFVars Parameters below) | `any` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Azure location | `string` | `"canadacentral"` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnet object map provided by ESLZ | `any` | `{}` | no |
| <a name="input_private_dns_zone_ids"></a> [private\_dns\_zone\_ids](#input\_private\_dns\_zone\_ids) | Private DNS zone IDs for private endpoints | `any` | `{}` | no |
| <a name="input_private_endpoint"></a> [private\_endpoint](#input\_private\_endpoint) | Private endpoint parameters | `any` | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags applied to all resources (merged with storage_account.tags) | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | ID of the storage account |
| <a name="output_name"></a> [name](#output\_name) | Name of the storage account |
| <a name="output_storage-account-object"></a> [storage-account-object](#output\_storage-account-object) | Full storage account object (sensitive) |

## TFVars Parameters

For full provider documentation see: <https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/storage_account>

All parameters are set inside the `storage_account` object key in your tfvars.

### Required

| Name | Possible values | Notes |
|------|----------------|-------|
| `resource_group` | RG name (e.g. `Project`) or full resource ID | |
| `account_tier` | `Standard`, `Premium` | |
| `account_replication_type` | `LRS`, `GRS`, `RAGRS`, `ZRS`, `GZRS`, `RAGZRS` | Some changes force new resource |

### Optional — simple values

| Name | Possible values | Default |
|------|----------------|---------|
| `account_kind` | `BlobStorage`, `BlockBlobStorage`, `FileStorage`, `Storage`, `StorageV2` | `StorageV2` |
| `access_tier` | `Hot`, `Cool`, `Cold`, `Premium` | `Hot` |
| `https_traffic_only_enabled` | `true`, `false` | `true` |
| `min_tls_version` | `TLS1_0`, `TLS1_1`, `TLS1_2` | `TLS1_2` |
| `allow_nested_items_to_be_public` | `true`, `false` | `false` |
| `shared_access_key_enabled` | `true`, `false` | `false` |
| `public_network_access_enabled` | `true`, `false` | `false` |
| `default_to_oauth_authentication` | `true`, `false` | `false` |
| `is_hns_enabled` | `true`, `false` | `false` |
| `nfsv3_enabled` | `true`, `false` | `false` |
| `cross_tenant_replication_enabled` | `true`, `false` | `true` |
| `large_file_share_enabled` | `true`, `false` | `null` |
| `local_user_enabled` | `true`, `false` | `null` (provider default: `true`) |
| `sftp_enabled` | `true`, `false` | `null` — requires `is_hns_enabled = true` |
| `allowed_copy_scope` | `AAD`, `PrivateLink` | `null` |
| `dns_endpoint_type` | `Standard`, `AzureDnsZone` | `null` — forces new resource |
| `infrastructure_encryption_enabled` | `true`, `false` | `null` — forces new resource |
| `provisioned_billing_model_version` | `V2` | `null` — FileStorage only, forces new resource |
| `queue_encryption_key_type` | `Service`, `Account` | `null` — forces new resource |
| `table_encryption_key_type` | `Service`, `Account` | `null` — forces new resource |
| `edge_zone` | Edge Zone name | `null` — forces new resource |

### Optional — blocks

| Name | Description |
|------|-------------|
| `identity` | Managed Identity — `{ type, identity_ids? }` |
| `custom_domain` | Custom DNS domain — `{ name, use_subdomain? }` |
| `customer_managed_key` | CMK encryption — `{ key_vault_key_id?, managed_hsm_key_id?, user_assigned_identity_id }` |
| `blob_properties` | Blob service settings — versioning, change feed, soft delete, CORS, restore policy |
| `queue_properties` | Queue service settings — logging, minute/hour metrics, CORS |
| `share_properties` | Files service settings — retention, SMB config, CORS |
| `azure_files_authentication` | AD/AADDS/AADKERB auth — `{ directory_type, default_share_level_permission?, active_directory? }` |
| `routing` | Routing preferences — `{ publish_internet_endpoints?, publish_microsoft_endpoints?, choice? }` |
| `immutability_policy` | Account-level WORM — `{ allow_protected_append_writes, state, period_since_creation_in_days }` — forces new resource |
| `static_website` | `true` for defaults, or `{ index_document?, error_404_document? }` |
| `network_rules` | `{ default_action, ip_rules?, virtual_network_subnet?, bypass? }` |
| `sas_policy` | `{ expiration_period, expiration_action? }` — only when `shared_access_key_enabled = true` |
| `private_endpoint` | Map of private endpoints — see `ESLZ/storage-account.tfvars` for full example |

See [ESLZ/storage-account.tfvars](ESLZ/storage-account.tfvars) for a complete commented example.

