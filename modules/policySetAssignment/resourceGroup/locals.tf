# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  # assignment_name will be trimmed if exceeds 24 characters
  assignment_name = try(lower(substr(coalesce(var.assignment_name, var.initiative.name), 0, 24)), "")
  display_name = try(coalesce(var.assignment_display_name, var.initiative.display_name), "")
  description = try(coalesce(var.assignment_description, var.initiative.description), "")
  metadata = jsonencode(try(coalesce(var.assignment_metadata, jsondecode(var.initiative.metadata)), {}))

  # convert assignment parameters to the required assignment structure
  parameter_values = var.assignment_parameters != null ? {
    for key, value in var.assignment_parameters :
    key => merge({ value = value })
  } : null

  # merge effect and parameter_values if specified, will use definition default effects if omitted
  parameters = local.parameter_values != null ? var.assignment_effect != null ? jsonencode(merge(local.parameter_values, { effect = { value = var.assignment_effect } })) : jsonencode(local.parameter_values) : null

  # create the optional non-compliance message content block(s) if present
  non_compliance_message = var.non_compliance_messages != {} ? {
    for reference_id, message in var.non_compliance_messages :
    reference_id => message
  } : {}

  # determine if a managed identity should be created with this assignment
  identity_type = length(try(coalescelist(var.role_definition_ids, try(var.initiative.role_definition_ids, [])), [])) > 0 ? length(var.identity_ids) > 0 ? { type = "UserAssigned" } : { type = "SystemAssigned" } : {}

  # try to use policy definition roles if explicit roles are ommitted
  role_definition_ids = var.skip_role_assignment == false && try(values(local.identity_type)[0], "") == "SystemAssigned" ? try(coalescelist(var.role_definition_ids, try(var.initiative.role_definition_ids, [])), []) : []

  # evaluate remediation scope from resource identifier
  remediation_scope = try(coalesce(var.remediation_scope, var.assignment_scope), "")

  # retrieve definition references & create a remediation task for policies with DeployIfNotExists and Modify effects
  definitions = var.skip_remediation == false && length(local.identity_type) > 0 ? try(var.initiative.policy_definition_reference, []) : []
  
  # evaluate outputs
  assignment = try(
    azurerm_resource_group_policy_assignment.set,    
  "")
  remediation_tasks = try(
    azurerm_resource_group_policy_remediation.rem,
  {})
}