provider "azurerm" {
  version = "=2.65.0"
  features {}
}

resource "azurerm_resource_group" "funcdeploy" {
  name     = "rg-${var.prefix}-function"
  location = var.location
}

resource "azurerm_storage_account" "funcdeploy" {
  name                     = "${var.prefix}storage"
  resource_group_name      = azurerm_resource_group.funcdeploy.name
  location                 = azurerm_resource_group.funcdeploy.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "funcdeploy" {
  name                  = "contents"
  storage_account_name  = azurerm_storage_account.funcdeploy.name
  container_access_type = "private"
}

resource "azurerm_application_insights" "funcdeploy" {
  name                = "${var.prefix}-appinsights"
  location            = azurerm_resource_group.funcdeploy.location
  resource_group_name = azurerm_resource_group.funcdeploy.name
  application_type    = "web"

  # https://github.com/terraform-providers/terraform-provider-azurerm/issues/1303
  tags = {
    "hidden-link:${azurerm_resource_group.funcdeploy.id}/providers/Microsoft.Web/sites/${var.prefix}func" = "Resource"
  }

}

resource "azurerm_app_service_plan" "funcdeploy" {
  name                = "${var.prefix}-functions-consumption-asp"
  location            = azurerm_resource_group.funcdeploy.location
  resource_group_name = azurerm_resource_group.funcdeploy.name
  kind                = "FunctionApp"
  reserved            = true

  sku {
    tier = "Dynamic"
    size = "Y1"
  }
}

resource "azurerm_eventhub_namespace" "ehn" {
  name                = "${var.prefix}-eh"
  location            = azurerm_resource_group.funcdeploy.location
  resource_group_name = azurerm_resource_group.funcdeploy.name

  sku      = "Standard"
  capacity = 1

  auto_inflate_enabled     = true
  maximum_throughput_units = 5

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_eventhub" "eh_raw" {
  name                = "iot_events_raw"
  namespace_name      = azurerm_eventhub_namespace.ehn.name
  resource_group_name = azurerm_resource_group.funcdeploy.name

  partition_count   = 3
  message_retention = 1
}

resource "azurerm_function_app" "funcdeploy" {
  name                       = "${var.prefix}func"
  location                   = azurerm_resource_group.funcdeploy.location
  resource_group_name        = azurerm_resource_group.funcdeploy.name
  app_service_plan_id        = azurerm_app_service_plan.funcdeploy.id
  storage_account_name       = azurerm_storage_account.funcdeploy.name
  storage_account_access_key = azurerm_storage_account.funcdeploy.primary_access_key
  https_only                 = true
  version                    = "~3"
  os_type                    = "linux"
  app_settings = {
      "WEBSITE_RUN_FROM_PACKAGE" = "1"
      "FUNCTIONS_WORKER_RUNTIME" = "python"
      "APPINSIGHTS_INSTRUMENTATIONKEY" = "${azurerm_application_insights.funcdeploy.instrumentation_key}"
      "APPLICATIONINSIGHTS_CONNECTION_STRING" = "InstrumentationKey=${azurerm_application_insights.funcdeploy.instrumentation_key};IngestionEndpoint=https://westeurope-0.in.applicationinsights.azure.com/"
      "eventHubName": azurerm_eventhub.eh_raw.name,
      "CloudComputingEventHubConnectionString": azurerm_eventhub_namespace.ehn.default_primary_connection_string,
  }

  site_config {
        linux_fx_version= "Python|3.8"        
        ftps_state = "Disabled"
    }

  # Enable if you need Managed Identity
  # identity {
  #   type = "SystemAssigned"
  # }
}