## Variables responsible for formatting the name of the storage account using the userDefinedString input variable
## unique_8 is needed to ensure that storage accounts have a unique name
locals {
  unique_8                                             = substr(sha1(local.resource_group_id), 0, 8)
  storage_account-regex                                = "/[^0-9a-z]/" # Anti-pattern to match all characters not in: 0-9 a-z
  env-regex_compliant_4                                = replace(lower(substr(var.env, 0, 4)), local.storage_account-regex, "")
  storage_account-userDefinedString-regex_compliant_16 = replace(lower(substr(var.userDefinedString, 0, 16)), local.storage_account-regex, "")
  storage_account-name                                 = substr("${local.env-regex_compliant_4}${local.storage_account-userDefinedString-regex_compliant_16}${local.unique_8}", 0, 24)
}