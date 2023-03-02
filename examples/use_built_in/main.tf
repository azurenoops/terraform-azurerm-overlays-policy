# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

# Org Management Group
data "azurerm_management_group" "org" {
  name = "anoa"
}

##################
# Built-In Definition
##################
data "azurerm_policy_definition" "allowed_virtual_machine_size_SKUs" {
  display_name = "Allowed virtual machine size SKUs"
}

##################
# Built-In Definition Assignment - Management Group
##################
module "org_mg_allowed_virtual_machine_size_SKUs_assignment" {
  source            = "../../modules/policyDefAssignment/managementGroup"
  definition        = data.azurerm_policy_definition.allowed_virtual_machine_size_SKUs
  assignment_scope  = data.azurerm_management_group.org.id

  assignment_parameters = {
    listOfAllowedSKUs = [
      "Standard_B1ls",
      "Standard_B1ms",
      "Standard_B1s",
      "Standard_B2ms",
      "Standard_B2s",
    ]
  }
}