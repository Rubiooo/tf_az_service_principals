#
# Create a custom service principal to use for this cluster
# #
resource "azurerm_key_vault_secret" "service_principal_secret" {
  count        = length(var.service_principals)
  name         = lookup(element(var.service_principals, count.index), "name")
  value        = random_string.password.result
  key_vault_id = data.azurerm_key_vault.project_vault.id
}

resource "azuread_application" "aks_service_principal" {
  count                      = length(var.service_principals)
  name                       = format("%s-%s",lookup(element(var.service_principals, count.index), "name"),var.environment_name)
  reply_urls                 = lookup(element(var.service_principals, count.index), "reply_urls", [])
  available_to_other_tenants = false
  oauth2_allow_implicit_flow = lookup(element(var.service_principals, count.index), "implicit_flow", false)
  group_membership_claims    = lookup(element(var.service_principals, count.index), "group_membership_claims", "SecurityGroup")
  
  dynamic "required_resource_access" {
    for_each = lookup(element(var.service_principals, count.index), "required_resource_access", [])
    content {
      resource_app_id = required_resource_access.value.resource_app_id
      dynamic "resource_access" {
        for_each = required_resource_access.value.resource_access
        content {
          id   = resource_access.value.id
          type = resource_access.value.type
        }
      }
    }
  }
}

resource "azuread_service_principal" "aks_service_principal" {
  count          = length(azuread_application.aks_service_principal)
  application_id = lookup(element(azuread_application.aks_service_principal, count.index), "application_id")
}

resource "azuread_service_principal_password" "aks_service_principal" {
  count                = length(azuread_service_principal.aks_service_principal)
  service_principal_id = lookup(element(azuread_service_principal.aks_service_principal, count.index), "id")
  value                = lookup(element(azurerm_key_vault_secret.service_principal_secret, count.index), "value")
  end_date_relative    = "${24 * 365}h"

  depends_on = [
    azuread_service_principal.aks_service_principal,
  ]
}

