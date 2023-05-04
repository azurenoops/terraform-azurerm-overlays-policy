# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurerm_client_config" "current" {}

data "azurerm_subscription" "current" {}

# Org Management Group
data "azurerm_management_group" "org" {
  name = "anoa"
}

# Contributor role
data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

##################
# Monitoring - Policy Definitions
##################

# create definitions by looping around all files found under the local Monitoring category folder
module "deploy_resource_diagnostic_setting" {
  source              = "../../modules/policyDefinition"
  # Use the for_each meta-argument to iterate over the list of files found in the built-in Monitoring category folder
  for_each            = toset([for p in fileset(path.cwd, "../custom/policies/monitoring/*.json") : trimsuffix(basename(p), ".json")])
  policy_def_name     = each.key
  policy_category     = "Monitoring"
  management_group_id = data.azurerm_management_group.org.id
}

##################
# Monitoring: Resource & Activity Log Forwarders
##################
module "platform_diagnostics_initiative" {
  depends_on = [
    module.deploy_resource_diagnostic_setting
  ]
  source                  = "../../modules/policyInitiative"
  initiative_name         = "platform_diagnostics_initiative"
  initiative_display_name = "[Platform]: Diagnostics Settings Policy Initiative"
  initiative_description  = "Collection of policies that deploy resource and activity log forwarders to logging core resources"
  initiative_category     = "Monitoring"
  merge_effects           = false # will not merge "effect" parameters
  management_group_id     = data.azurerm_management_group.org.id

  # Populate member_definitions with a for loop (not explicit)
  member_definitions = [for mon in module.deploy_resource_diagnostic_setting : mon.definition]
}

##################
# Monitoring - Policy Set Assignment
##################
module "org_mg_platform_diagnostics_initiative" {
  source               = "../../modules/policySetAssignment/managementGroup"
  initiative           = module.platform_diagnostics_initiative.initiative
  assignment_scope     = data.azurerm_management_group.org.id

  # resource remediation options
  re_evaluate_compliance = false
  skip_remediation       = false
  skip_role_assignment   = false
  role_definition_ids    = [data.azurerm_role_definition.contributor.id] # using explicit roles

  non_compliance_messages = {
    null                                        = "The Default non-compliance message for all member definitions"
    "DeployApplicationGatewayDiagnosticSetting" = "The non-compliance message for the deploy_application_gateway_diagnostic_setting definition"
  }

  assignment_parameters = {
    workspaceId                                        = "/uri/log-analytics-workspace-workspaceId"
    storageAccountId                                   = "/uri/log-analytics-workspace-storageAccountId"
    eventHubName                                       = "/uri/log-analytics-workspace-eventHubName"
    eventHubAuthorizationRuleId                        = "/uri/log-analytics-workspace-eventHubAuthorizationRuleId"
    metricsEnabled                                     = "True"
    logsEnabled                                        = "True"
    effect_DeployApplicationGatewayDiagnosticSetting   = "DeployIfNotExists"
    effect_DeployEventhubDiagnosticSetting             = "DeployIfNotExists"
    effect_DeployFirewallDiagnosticSetting             = "DeployIfNotExists"
    effect_DeployKeyvaultDiagnosticSetting             = "AuditIfNotExists"
    effect_DeployLoadbalancerDiagnosticSetting         = "AuditIfNotExists"
    effect_DeployNetworkInterfaceDiagnosticSetting     = "AuditIfNotExists"
    effect_DeployNetworkSecurityGroupDiagnosticSetting = "AuditIfNotExists"
    effect_DeployPublicIpDiagnosticSetting             = "AuditIfNotExists"
    effect_DeployStorageAccountDiagnosticSetting       = "DeployIfNotExists"
    effect_DeploySubscriptionDiagnosticSetting         = "DeployIfNotExists"
    effect_DeployVnetDiagnosticSetting                 = "AuditIfNotExists"
    effect_DeployVnetGatewayDiagnosticSetting          = "AuditIfNotExists"
  }
}

##################
# Monitoring Exemption - Management Group
##################
# Subscription Scope Resource Exemption
module "exemption_subscription_diagnostics_settings" {
  source               = "../../modules/policyExemption/subscription"
  name                 = "Subscription Diagnostic Settings Exemption"
  display_name         = "Exempted while testing"
  description          = "Excludes subscription from configuring diagnostics settings"
  scope                = data.azurerm_subscription.current.id
  policy_assignment_id = module.org_mg_platform_diagnostics_initiative.id
  exemption_category   = "Waiver"
  expires_on           = "2023-05-25"

  # use member_definition_names for simplicity when policy_definition_reference_ids are unknown
  member_definition_names = [
    "deploy_subscription_diagnostic_setting"
  ]
}
