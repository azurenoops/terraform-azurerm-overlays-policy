# Description: Module to create a policy exemption
# Credit: gettek
##################################################
# RESOURCES                                      #
##################################################

resource "azurerm_subscription_policy_exemption" "subscription_exemption" {
  name                            = var.name
  display_name                    = var.display_name
  description                     = var.description
  subscription_id                 = var.scope
  policy_assignment_id            = var.policy_assignment_id
  exemption_category              = var.exemption_category
  expires_on                      = local.expires_on
  policy_definition_reference_ids = local.policy_definition_reference_ids
  metadata                        = local.metadata
}
