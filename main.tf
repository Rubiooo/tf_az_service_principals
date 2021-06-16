data "azurerm_key_vault" "project_vault" {
  name                = var.key_vault_id
  resource_group_name = var.keyvault_resource_group
}

resource "random_string" "password" {
  length  = 30
  upper   = false
  number  = false
  special = false
}