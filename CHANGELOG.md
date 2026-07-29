# Changelog

All notable changes to this module are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This file must be updated as part of every change to this module.

## [1.2.1] - 2026-07-29

### Changed

- Bumped `private_endpoint` child module reference from `v1.1.0` to `v1.2.0` in [module.tf](module.tf). The upstream module now pins `azurerm ~> 5.0` (previously `~> 4.0`), resolving the provider version conflict noted below.
- Regenerated [README.md](README.md) to reflect the `private_endpoint` module version bump.

### Fixed

- Resolved the `terraform init` provider constraint conflict between this module (`azurerm ~> 5.0`) and the `private_endpoint` child module (previously `azurerm ~> 4.0`).

## [1.2.0] - 2026-07-29

### Changed

- Bumped `azurerm` provider requirement from `~> 4.0` to `~> 5.0` in [providers.tf](providers.tf).
- `static_website` is now rendered via a dedicated `azurerm_storage_account_static_website` resource instead of an inline block (removed by azurerm v5). The `storage_account.static_website` tfvars input shape (`true` or `{ index_document?, error_404_document? }`) is unchanged.
- `queue_properties` is now rendered via a dedicated `azurerm_storage_account_queue_properties` resource instead of an inline block (removed by azurerm v5). The `minute_metrics` / `hour_metrics` sub-blocks no longer accept an `enabled` field; for backward compatibility, legacy tfvars that set `enabled = false` suppress those blocks.
- Bumped `private_endpoint` child module reference from `v1.0.2` to `v1.1.0` in [module.tf](module.tf).
- Bumped this module's own `ESLZ/storage-account.tf` example source ref from `v1.1.0` to `v1.2.0`.
- Regenerated [README.md](README.md) (terraform-docs) and updated `ESLZ/storage-account.tfvars` example comments to match the above.

### Removed

- `customer_managed_key.managed_hsm_key_id` support — removed by the provider in azurerm v5. Use `customer_managed_key.key_vault_key_id` only.

### Added

- [.tflint.hcl](.tflint.hcl) and [.gitattributes](.gitattributes) (neither existed previously).
- Test coverage expanded from 14 to 18 runs in [tests/storage_account.tftest.hcl](tests/storage_account.tftest.hcl): `static_website_absent`, `queue_properties`, `queue_properties_absent`, `customer_managed_key`.

### Known issues

- The `private_endpoint` child module (`terraform-azurerm-caf-private_endpoint`, separate repo, latest release `v1.1.0`) still pins `azurerm ~> 4.0`. Combined with this module's `~> 5.0` requirement, `terraform init` will fail for consumers (`no available releases match the given constraints ~> 4.0, ~> 5.0`) until that module is upgraded to azurerm v5 in its own repository.

## [1.1.0] and earlier

Not retroactively documented. See `git log` and git tags (`v1.0.0`–`v1.1.0`) for history prior to this file's introduction.
