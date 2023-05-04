# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

##################################################
# OUTPUTS                                        #
##################################################
output id {
  description = "The Policy Assignment Id"
  value       = azurerm_resource_policy_assignment.set.id
}

output principal_id {
  description = "The Principal Id of this Policy Assignment's Managed Identity if type is SystemAssigned"
  value       = try(azurerm_resource_policy_assignment.set.identity[0].principal_id, null)
}

output remediation_tasks {
  description = "The Remediation Task Ids and related Policy Definition Ids"
  value = [
    for rem in local.remediation_tasks :
    tomap({
      "id"                   = rem.id
      "policy_definition_id" = rem.policy_definition_id
    })
  ]
}

output definition_references {
  description = "The Member Definition Reference Ids"
  value       = try(var.initiative.policy_definition_reference, [])
}
