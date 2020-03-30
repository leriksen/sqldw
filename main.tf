terraform {
  required_version = ">= 0.12"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "agl-experiment"

    workspaces {
      name = "sqldw"
    }
  }
}

locals {
  tags = {
    BusinessOwner  = "SLQDW"
    TechnicalOwner = "DevOps"
    CostCentre     = "CCC001"
    CreatedBy      = "DevOps Angel"
    Project        = "OneCodeBase"
  }

  tenant_id       = "74f9ac2f-c1d2-412f-8435-6e60efdad5e1"
  subscription    = "Staging"
  subscription_id = "40371827-837f-4329-a4c1-1000a8a29725"
  location        = "australiasoutheast"

  aad_admin      = "24a210e1-db99-4fe1-a7f8-35d1d3813e26" # me
  aad_admin_name = "AAD_ADMIN"
}

provider "azurerm" {
  tenant_id       = local.tenant_id
  subscription_id = local.subscription_id
  version         = "~> 2.0"
  features {}
}

resource "azurerm_resource_group" "workspace-rg" {
  location = local.location
  name     = "sqldw-rg"
  tags     = local.tags
}

provider "random" {
  version = "~> 2.2"
}

resource "random_string" "sqldw-password" {
  length           = 16
  special          = true
  min_upper        = 3
  min_numeric      = 3
  override_special = "@"
}

module "sqldw" {
  source  = "app.terraform.io/agl-experiment/tf12-sqldw/azurerm"
  version = "1.4.0"

  resource_group_name  = azurerm_resource_group.workspace-rg.name
  location             = local.location
  tags                 = local.tags
  sql_dw_name          = "sql-dw-name"
  db_name              = "db_name"
  sql_admin_user_name  = "dataplat"
  sql_admin_password   = random_string.sqldw-password.result
  dwuname              = "DW100c"
  aad_admin_user_id    = local.aad_admin
  aad_admin_user_name  = local.aad_admin_name
  azure_tenant_id      = local.tenant_id
  whitelisted_networks = []
  whitelisted_subnets  = []
}
