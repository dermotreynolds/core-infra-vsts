Allow our state to be persisted in blob storage terraform {
  backend "azurerm" {
    storage_account_name = "wfinfraprd010101"
    container_name       = "wfinfraprdstate010101"
    key                  = "terraform.core.state"
  }
}

#Create a resource group to put our resources into
resource "azurerm_resource_group" "wfcore_resource_group" {
  name     = "${var.organisation}-${var.department}-${var.environment}-core"
  location = "${var.azure_location}"

  tags {
    environment  = "${var.environment}"
    department   = "${var.department}"
    organisation = "${var.organisation}"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "nft_key_vault" {
  name                = "${var.organisation}${var.department}${var.environment}-core"
  location            = "${azurerm_resource_group.wfcore_resource_group.location}"
  resource_group_name = "${azurerm_resource_group.wfcore_resource_group.name}"

  tenant_id = "${data.azurerm_client_config.current.tenant_id}"

  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "5014aa70-8762-4899-b586-3e548732a78a"

    key_permissions = [
      "create",
      "get",
      "list",
      "backup",
      "decrypt",
      "delete",
      "encrypt",
      "get",
      "import",
      "list",
      "purge",
      "recover",
      "restore",
      "sign",
      "unwrapKey",
      "update",
      "verify",
      "wrapKey",
    ]

    secret_permissions = [
      "backup",
      "delete",
      "get",
      "list",
      "purge",
      "recover",
      "set",
      "restore",
    ]
  }

  sku {
    name = "standard"
  }
}
