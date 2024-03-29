# Description: Module to create policy definition and assignment
# Credit: gettek
##################################################
# RESOURCES                                      #
##################################################

resource "azurerm_resource_policy_assignment" "def" {
  name                 = local.assignment_name
  display_name         = local.display_name
  description          = local.description
  metadata             = local.metadata
  parameters           = local.parameters
  resource_id          = var.assignment_scope
  not_scopes           = var.assignment_not_scopes
  enforce              = var.assignment_enforcement_mode
  policy_definition_id = var.definition.id
  location             = var.assignment_location

  dynamic "non_compliance_message" {
    for_each = local.non_compliance_message
    content {
      content = non_compliance_message.value
    }
  }

  dynamic "identity" {
    for_each = local.identity_type
    content {
      type         = identity.value
      identity_ids = var.identity_ids
    }
  }

  dynamic "resource_selectors" {
    for_each = var.resource_selectors
    content {
      name = try(resource_selectors.value.name, null)
      selectors {
        kind   = resource_selectors.value.selectors.kind
        in     = try(resource_selectors.value.selectors.in, null)
        not_in = try(resource_selectors.value.selectors.not_in, null)
      }
    }
  }
}

## role assignments ##
resource "azurerm_role_assignment" "rem_role" {
  for_each                         = toset(local.role_definition_ids)
  scope                            = local.role_assignment_scope
  role_definition_id               = each.value
  principal_id                     = azurerm_resource_policy_assignment.def.identity[0].principal_id
  skip_service_principal_aad_check = true
}

## remediation tasks ##
resource "azurerm_resource_policy_remediation" "rem" {
  count                   = local.create_remediation + local.remediate.resource > 1 ? 1 : 0
  name                    = lower("${var.definition.name}-${formatdate("DD-MM-YYYY-hh:mm:ss", timestamp())}")
  resource_id             = local.remediation_scope
  policy_assignment_id    = azurerm_resource_policy_assignment.def.id
  resource_discovery_mode = local.resource_discovery_mode
  location_filters        = var.location_filters
  failure_percentage      = var.failure_percentage
  parallel_deployments    = var.parallel_deployments
  resource_count          = var.resource_count
}
