variable "keyvault_resource_group" {
    default = ""
}

variable "key_vault_id" {
    default = ""
}

variable "location" {
  default = ""
}

variable "environment_name" {}
variable "subscription_id" {}
variable "tenant_id" {}

variable "additional_tags" {
  default = {}
}

variable "service_principals" {
  default = [
    {
      name = "aks"
    },
    {
      name = "AKSAADClient"
      required_resource_access = [
        {
          resource_app_id = "00000000-0000-0000-0000-000000000000"
          resource_access = [
            {
              id   = "xxxxx-xxx-4xx-axxx-xxxxx"
              type = "Scope"
            },
            {
              id   = "xxx-xxx-4xxx-xx-xxxx"
              type = "Role"
            }
          ]
        }
      ]
    },
    {
      name = "AKSAADServer"
      required_resource_access = [
        {
          resource_app_id = "00000000-0000-0000-c000-000000000000"
          resource_access = [
            {
              id   = "xxxx-xxx-xx-xx-xxxx"
              type = "Role"
            }
          ]
        }
      ]
    },
    {
      name          = "jenkins"
      implicit_flow = true
      reply_urls = [
        "https://jenkins.example.com/securityRealm/finishLogin",
        "https://jenkins.example.com/securityRealm/finishLogin",
        "http://localhost:8080/securityRealm/finishLogin",
        "https://jenkins.internal.example.com/securityRealm/finishLogin",
      ],
      required_resource_access = [
        {
          resource_app_id = "00000000-0000-0000-c000-000000000000"
          resource_access = [
            {
              id   = "xxxxx-xxxx-xxx-xxx-xxx"
              type = "Role"
            },
            {
              id   = "xxxxx-xxxx-xxxxxxxx-xxxxxx"
              type = "Scope"
            }
          ]
        },
        {
          resource_app_id = "00000000-0000-0000-c000-000000000000"
          resource_access = [
            {
              id   = "xxxx-xxx-4xxx-xxx-xxxx"
              type = "Role"
            },
            {
              id   = "xxxx-xxx-xxx-xxx-xxxx"
              type = "Scope"
            }
          ]
        }
      ]
    },
    {
      name       = "vault-k8s-service-principal"
    },

  ]
}

variable "aks_role_name" {
  default = ""
}

variable "project_name" {
  default = ""
}

variable "years" {
  default = 2
}

variable "custom_ip_whitelist" {
  type = list(string)
  default = [
    
  ]
}
