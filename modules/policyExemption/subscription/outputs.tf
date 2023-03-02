##################################################
# OUTPUTS                                        #
##################################################
output subscription_exemption {
  description = "The Policy Exemption Details for the Subscription"
  value = {
    name                     = var.name
    id                       = local.exemption_id
    category                 = var.exemption_category
    scope                    = var.scope
    metadata                 = var.metadata
    definition_reference_ids = local.policy_definition_reference_ids
    expires_on               = local.expires_on
  }
}