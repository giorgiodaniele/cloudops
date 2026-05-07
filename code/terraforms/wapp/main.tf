provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-wapp-dev-weu-01"
  location = "norwayeast"
}

resource "azurerm_service_plan" "plan" {
  name                = "asp-wapp-dev-weu-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = "Linux"
  sku_name            = "B1"
}

#
# Create a new workspace where application insights is going
# to write
#

resource "azurerm_log_analytics_workspace" "law" {
  name                = "law-wapp-dev-weu-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_application_insights" "ai" {
  name                = "appi-wapp-dev-weu-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_id        = azurerm_log_analytics_workspace.law.id
  application_type    = "web"
}

#
# Create webapp
#

resource "azurerm_linux_web_app" "webapp" {
  name                = "app-wapp-dev-weu-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.plan.id

  site_config {}

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = azurerm_application_insights.ai.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"      = azurerm_application_insights.ai.connection_string
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~3"
  }
}