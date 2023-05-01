# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

# Org Management Group
data "azurerm_management_group" "org" {
  name = "anoa"
}

##################
# General - Management Group
##################
module "deny_resources_types" {  
  source              = "../../modules/policyDefinition"
  policy_def_name     = "deny_resources_types" # Name of the policy definition to create from the custom policy definition file
  display_name        = "Deny Azure Resource types"
  policy_category     = "General"
  management_group_id = data.azurerm_management_group.org.id
}

##################
# General - Management Group
##################
module "team_dev_mg_deny_resource_types" {
  depends_on = [
    module.deny_resources_types
  ]
  source            = "../../modules/policyDefAssignment/managementGroup"
  definition        = module.deny_resources_types.definition
  assignment_scope  = data.azurerm_management_group.org.id
  assignment_effect = "Audit" # Audit, Deny

  assignment_parameters = {
    listOfResourceTypesNotAllowed = [
      "Microsoft.Storage/operations",
      "Microsoft.Storage/storageAccounts",
      "Microsoft.Storage/storageAccounts/blobServices",
      "Microsoft.Storage/storageAccounts/blobServices/containers",
      "Microsoft.Storage/storageAccounts/listAccountSas",
      "Microsoft.Storage/storageAccounts/listServiceSas",
      "Microsoft.Storage/usages",
    ]
  }
}
