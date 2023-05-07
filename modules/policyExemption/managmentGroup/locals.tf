

locals {
  expires_on = var.expires_on != null ? "${var.expires_on}T23:00:00Z" : null

  metadata = var.metadata != null ? jsonencode(var.metadata) : null

  # generate reference Ids when unknown, assumes the set was created with the initiative module
  policy_definition_reference_ids = length(var.member_definition_names) > 0 ? [for name in var.member_definition_names :
    replace(substr(title(replace(name, "/-|_|\\s/", " ")), 0, 64), "/\\s/", "")
  ] : var.policy_definition_reference_ids

  exemption_id = try(
    azurerm_management_group_policy_exemption.management_group_exemption.id,
  "")
}