# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# Contributor role
data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

data "azurerm_policy_definition" "deploy_a_flow_log_resource_with_target_virtual_network" {
  name = "cd6f7aff-2845-4dab-99f2-6d1754a754b0"
}

module "org_mg_deploy_a_flow_log_resource_with_target_virtual_network_assignment" {
  source                = "../../modules/policyDefAssignment/managementGroup"
  definition            = data.azurerm_policy_definition.deploy_a_flow_log_resource_with_target_virtual_network
  assignment_scope      = "/providers/Microsoft.Management/managementGroups/anoa"
  skip_remediation      = true
  skip_role_assignment  = true
  assignment_parameters = { 
    vnetRegion = "usgovvirginia", 
    storageId = "/subscriptions/aac8c731-82a5-47c3-9327-d6d0ea273dd4/resourceGroups/rg-anoa/providers/Microsoft.Storage/storageAccounts/anoausgva9625b51a28devst" 
    networkWatcherRG = "/subscriptions/aac8c731-82a5-47c3-9327-d6d0ea273dd4/resourceGroups/NetworkWatcherRG" 
    networkWatcherName = "NetworkWatcher_usgovvirginia"
    }
}
