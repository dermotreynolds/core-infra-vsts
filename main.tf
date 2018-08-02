#Allow our state to be persisted in blob storage 
terraform {
  backend "azurerm" {
    storage_account_name = "wfinfraprd010103"
    container_name       = "wfinfraprdstate010101"
    key                  = "terraform.core.state"
  }
}

resource "azurerm_resource_group" "wfinit_resource_group" {
  name     = "${var.organisation}-${var.department}-${var.environment}-init"
  location = "${var.azure_location}"

  tags {
    environment  = "${var.environment}"
    department   = "${var.department}"
    organisation = "${var.organisation}"
  }
}

#Create a storage account to put our state files into

resource "azurerm_storage_account" "wfinit_storage_account" {
  name                     = "${var.organisation}${var.department}${var.environment}010101"
  resource_group_name      = "${azurerm_resource_group.wfinit_resource_group.name}"
  location                 = "${azurerm_resource_group.wfinit_resource_group.location}"
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags {
    environment  = "${var.environment}"
    department   = "${var.department}"
    organisation = "${var.organisation}"
  }
}

#Create a container to put our state files into
resource "azurerm_storage_container" "wfinit_storage_container" {
  name                  = "${var.organisation}${var.department}${var.environment}state010101"
  resource_group_name   = "${azurerm_resource_group.wfinit_resource_group.name}"
  storage_account_name  = "${azurerm_storage_account.wfinit_storage_account.name}"
  container_access_type = "private"
}

# #Create a resource group to put our resources into
# resource "azurerm_resource_group" "wfcore_resource_group" {
#   name     = "${var.organisation}-${var.department}-${var.environment}-core"
#   location = "${var.azure_location}"
#   tags {
#     environment  = "${var.environment}"
#     department   = "${var.department}"
#     organisation = "${var.organisation}"
#   }
# }
# data "azurerm_client_config" "current" {}
# resource "azurerm_key_vault" "wfcore_key_vault" {
#   name                = "${var.organisation}${var.department}${var.environment}-core"
#   location            = "${azurerm_resource_group.wfcore_resource_group.location}"
#   resource_group_name = "${azurerm_resource_group.wfcore_resource_group.name}"
#   tenant_id = "${data.azurerm_client_config.current.tenant_id}"
#   access_policy {
#     tenant_id = "${data.azurerm_client_config.current.tenant_id}"
#     object_id = "${data.azurerm_client_config.current.service_principal_object_id}"
#     key_permissions = [
#       "create",
#       "get",
#       "list",
#       "backup",
#       "decrypt",
#       "delete",
#       "encrypt",
#       "get",
#       "import",
#       "list",
#       "purge",
#       "recover",
#       "restore",
#       "sign",
#       "unwrapKey",
#       "update",
#       "verify",
#       "wrapKey",
#     ]
#     secret_permissions = [
#       "backup",
#       "delete",
#       "get",
#       "list",
#       "purge",
#       "recover",
#       "set",
#       "restore",
#     ]
#   }
#   sku {
#     name = "standard"
#   }
# }

