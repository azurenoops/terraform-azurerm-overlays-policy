# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

locals {
  # collate all definition parameters into a single object
  member_parameters = {
    for d in var.member_definitions :
    d.name => try(jsondecode(d.parameters), {})
  }

  # combine all discovered definition parameters using interpolation
  parameters = merge(values({
    for definition, params in local.member_parameters :
    definition => {
      for parameter_name, parameter_value in params :
      # if do not merge parameters (or only effects) then suffix parameters with definition references
      var.merge_parameters == false || parameter_name == "effect" && var.merge_effects == false ?
      "${parameter_name}_${replace(substr(title(replace(definition, "/-|_|\\s/", " ")), 0, 64), "/\\s/", "")}" :

      parameter_name => {
        for k, v in parameter_value :
        k => (
          # if do not merge parameters (or only effects) then suffix displayNames with definition references
          k == "metadata" && var.merge_parameters == false || var.merge_effects == false && try(v.displayName, "") == "Effect" ?
          merge(v, { displayName = "${v.displayName} For Policy: ${replace(substr(title(replace(definition, "/-|_|\\s/", " ")), 0, 64), "/\\s/", "")}" }) :
          v
        )
      }
    }
  })...)

  # get role definition IDs
  role_definition_ids = {
    for d in var.member_definitions :
    d.name => try(jsondecode(d.policy_rule).then.details.roleDefinitionIds, [])
  }

  # combine all discovered role definition IDs
  all_role_definition_ids = try(distinct([for v in flatten(values(local.role_definition_ids)) : lower(v)]), [])

  metadata = coalesce(null, var.initiative_metadata, merge({ category = var.initiative_category }, { version = var.initiative_version }))

  # manually generate the initiative Id to prevent "Invalid for_each argument" on potential consumer modules
  initiative_id = var.management_group_id != null ? "${var.management_group_id}/providers/Microsoft.Authorization/policySetDefinitions/${var.initiative_name}" : azurerm_policy_set_definition.set.id
}
