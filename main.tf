terraform {
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

  tenant_id = "74f9ac2f-c1d2-412f-8435-6e60efdad5e1"
  location  = "australiasoutheast"
}


provider "azurerm" {
  tenant_id       = "${local.tenant_id}"
  subscription_id = "${local.subscription}"
  version         = "~> 1.0"
}

resource "azurerm_resource_group" "workspace-rg" {
  location = "${local.location}"
  name     = "${local.prefix}-${var.TERRAFORM_WORKSPACE}"
  tags     = "${local.tags}"
}

# module "sqldw" {
#   source  = "app.terraform.io/agl-experiment/sqldw/azurerm"
#   version = "1.0.0"

#   resource_group_name = "${azurerm_resource_group.workspace-rg.name}"
#   location = "${local.location}"
#   tags = "${local.tags}"
#   sql_dw_name = "sql_dw_name"
#   db_name = "db_name"
#   sql_admin_user_name = "sql_admin_user_name"
#   sql_admin_password = "sql_admin_password"
#   dwuname = "DW100c"
#   aad_admin_user_id = "aad_admin_user_id"
#   aad_admin_user_name = "aad_admin_user_name"
#   azure_tenant_id = "azure_tenant_id"
#   whitelisted_networks = "whitelisted_networks"
#   whitelisted_subnets = "whitelisted_subnets"
# }