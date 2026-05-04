provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-foo-dev-weu-01"
  location = "norwayeast"
}

resource "azurerm_storage_account" "sa" {
  name                     = "stfoodevweu01"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "dev"
    workload    = "foo"
  }
}

resource "azurerm_storage_container" "cnt_foo" {
  name                  = "cnt-foo-dev-weu-01"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "cnt_logs" {
  name                  = "cnt-logs-dev-weu-01"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "cnt_data" {
  name                  = "cnt-data-dev-weu-01"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "cnt_backup" {
  name                  = "cnt-backup-dev-weu-01"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}

resource "azurerm_storage_container" "cnt_temp" {
  name                  = "cnt-temp-dev-weu-01"
  storage_account_name  = azurerm_storage_account.sa.name
  container_access_type = "private"
}