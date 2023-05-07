# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

# Org Management Group
data "azurerm_management_group" "org" {
  name = "anoa"
}

# Org Management Group
data "azurerm_management_group" "team_dev" {
  name = "internal"
}

# Contributor role
data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

##################
# Security Center - Management Group
##################

# create definitions by calling them explicitly from a local (as above)
module "configure_asc" {
  source = "../../modules/policyDefinition"
  for_each = toset([
    "auto_enroll_subscriptions",
    "auto_provision_log_analytics_agent_custom_workspace",
    "auto_set_contact_details",
    "export_asc_alerts_and_recommendations_to_eventhub",
    "export_asc_alerts_and_recommendations_to_log_analytics",
  ])
  policy_def_name     = each.value
  policy_category     = "Security"
  management_group_id = data.azurerm_management_group.org.id
}

################## 
# Security Center - Management Group
##################
module "configure_asc_initiative" {
  source                  = "../../modules/policyInitiative"
  initiative_name         = "configure_asc_initiative"
  initiative_display_name = "[Security]: Configure Azure Security Center"
  initiative_description  = "Deploys and configures Azure Security Center settings and defines exports"
  initiative_category     = "Security"
  management_group_id     = data.azurerm_management_group.org.id

  # Populate member_definitions with a for loop (explicit)
  member_definitions = [
    module.configure_asc["auto_enroll_subscriptions"].definition,
    module.configure_asc["auto_provision_log_analytics_agent_custom_workspace"].definition,
    module.configure_asc["auto_set_contact_details"].definition,
    module.configure_asc["export_asc_alerts_and_recommendations_to_eventhub"].definition,
    module.configure_asc["export_asc_alerts_and_recommendations_to_log_analytics"].definition,
  ]
}

##################
# Security Center
##################
module "org_mg_configure_asc_initiative" {
  source               = "../../modules/policySetAssignment/managementGroup"
  initiative           = module.configure_asc_initiative.initiative
  assignment_scope     = data.azurerm_management_group.org.id
  assignment_effect    = "DeployIfNotExists"
  skip_remediation     = false
  skip_role_assignment = false

  role_assignment_scope = data.azurerm_management_group.team_dev.id # using explicit scopes
  role_definition_ids = [
    data.azurerm_role_definition.contributor.id # using explicit roles
  ]

  assignment_parameters = {
    workspaceId           = "/uri/log-analytics-workspace-diagnostics"
    eventHubDetails       = "/uri/event-hub-namespace-diagnostics"
    securityContactsEmail = "admin@cloud.com"
    securityContactsPhone = "44897654987"
  }
}
