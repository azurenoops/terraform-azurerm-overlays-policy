# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  # assignment_name will be trimmed if exceeds 24 characters
  assignment_name = try(lower(substr(coalesce(var.assignment_name, var.definition.name), 0, 24)), "")
  display_name = try(coalesce(var.assignment_display_name, var.definition.display_name), "")
  description = try(coalesce(var.assignment_description, var.definition.description), "")
  metadata = jsonencode(try(coalesce(var.assignment_metadata, jsondecode(var.definition.metadata)), {}))

  # convert assignment parameters to the required assignment structure
  parameter_values = var.assignment_parameters != null ? {
    for key, value in var.assignment_parameters :
    key => merge({ value = value })
  } : null

  # merge effect with parameter_values if specified, will use definition defaults if omitted
  parameters = var.assignment_effect != null ? jsonencode(merge(local.parameter_values, { effect = { value = var.assignment_effect } })) : jsonencode(local.parameter_values)

  # create the optional non-compliance message contents block if present
  non_compliance_message = var.non_compliance_message != "" ? { content = var.non_compliance_message } : {}

  # determine if a managed identity should be created with this assignment
  identity_type = length(try(coalescelist(var.role_definition_ids, lookup(jsondecode(var.definition.policy_rule).then.details, "roleDefinitionIds", [])), [])) > 0 ? { type = "SystemAssigned" } : {}

  # try to use policy definition roles if explicit roles are ommitted
  role_definition_ids = var.skip_role_assignment == false ? try(coalescelist(var.role_definition_ids, lookup(jsondecode(var.definition.policy_rule).then.details, "roleDefinitionIds", [])), []) : []

  # policy assignment scope will be used if omitted
  role_assignment_scope = try(coalesce(var.role_assignment_scope, var.assignment_scope), "")

  # evaluate remediation scope from resource identifier
  remediation_scope = try(coalesce(var.remediation_scope, var.assignment_scope), "")  

  # evaluate assignment outputs
  assignment = try(
    azurerm_subscription_policy_assignment.def,    
  "")
  remediation_id = try(
    azurerm_subscription_policy_remediation.rem[0].id,
  "")
}
