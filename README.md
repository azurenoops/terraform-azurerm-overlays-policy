<!-- markdownlint-configure-file { "MD004": { "style": "consistent" } } -->
<!-- markdownlint-disable MD033 -->
<p align="center">  
  <h1 align="left">Azure NoOps Accelerator Policy as Code Overlay Modules</h1>
  <p align="left">
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-orange.svg" alt="MIT License"></a>
    <a href="https://registry.terraform.io/modules/azurenoops/overlays-policy/azurerm/"><img src="https://img.shields.io/badge/terraform-registry-blue.svg" alt="Azure NoOps TF Registry"></a></br>
  </p>
</p>
<!-- markdownlint-enable MD033 -->

This Overlay terraform module simplifies the creation of custom and built-in Azure Policies to be used in a [SCCA compliant Mission Enclave](https://registry.terraform.io/modules/azurenoops/overlays-hubspoke/azurerm/latest).

## Contributing

If you want to contribute to this repository, feel free to to contribute to our Terraform module.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

### [Custom Policy Definitions Module](modules/policyDefinition)

This module depends on populating `var.policy_name` and `var.policy_category` to correspond with the respective custom policy definition `json` file found in the [local library](policyDefinition/custompolicies). You can also parse in other template files and data sources at runtime, see the [module readme](modules/policyDefinition) for examples and acceptable inputs.

```hcl
module allowed_regions {
  source              = "azurenoops/overlays-policy/azurerm//modules/policyDefinition"
  version             = "x.x.x"
  policy_def_name     = "allowed_regions"
  display_name        = "Allow resources only in allowed regions"
  policy_category     = "Custom"
  file_path           = "<file path to json>/allowed_regions.json"
  management_group_id = local.management_group_id
}
```

> **Info:** [Microsoft Docs: Azure Policy definition structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure)

## [Policy Initiative (Set Definitions) Module](modules/policyInitiative)

Dynamically create a policy set based on multiple custom or built-in policy definition references to simplify assignments.


```hcl
module platform_baseline_initiative {
  source                  = "azurenoops/overlays-policy/azurerm//modules/policyinitiative"
  version                 = "x.x.x"
  initiative_name         = "platform_baseline_initiative"
  initiative_display_name = "[Platform]: Baseline Policy Set"
  initiative_description  = "Collection of policies representing the baseline platform requirements"
  initiative_category     = "General"
  management_group_id     = data.azurerm_management_group.root.id

  member_definitions = [
    module.whitelist_resources.definition,
    module.whitelist_regions.definition
  ]
}
```

> **Info:** [Microsoft Docs: Azure Policy initiative definition structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/initiative-definition-structure)

## [Policy Definition Assignment Module](modules/policyDefAssignment)

```hcl
module org_mg_whitelist_regions {
  source            = "azurenoops/overlays-policy/azurerm//modules/policyDefAssignment"
  version           = "x.x.x"
  definition        = module.whitelist_regions.definition
  assignment_scope  = data.azurerm_management_group.root.id
  assignment_effect = "Deny"

  assignment_parameters = {
    listOfRegionsAllowed = [
      "East US",
      "West US",
      "Global"
    ]
  }
}
```

> **Info:** [Microsoft Docs: Azure Policy assignment structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure)

## [Policy Initiative Assignment Module](modules/polictSetAssignment)

```hcl
module org_mg_platform_diagnostics_initiative {
  source                  = "azurenoops/overlays-policy/azurerm//modules/policySetAssignment"
  version                 = "x.x.x"
  initiative              = module.platform_diagnostics_initiative.initiative
  assignment_scope        = data.azurerm_management_group.root.id
  assignment_effect       = "DeployIfNotExists"

  # optional resource remediation inputs
  re_evaluate_compliance  = false
  skip_remediation        = false
  skip_role_assignment    = false
  remediation_scope       = data.azurerm_subscription.current.id

  assignment_parameters = {
    workspaceId                 = data.azurerm_log_analytics_workspace.workspace.id
    storageAccountId            = data.azurerm_storage_account.sa.id
    eventHubName                = data.azurerm_eventhub_namespace.ehn.name
    eventHubAuthorizationRuleId = data.azurerm_eventhub_namespace_authorization_rule.ehnar.id
    metricsEnabled              = "True"
    logsEnabled                 = "True"
  }

  assignment_not_scopes = [
    data.azurerm_management_group.platforms.id
  ]

  non_compliance_messages = {
    null                                      = "The Default non-compliance message for all member definitions"
    DeployApplicationGatewayDiagnosticSetting = "The non-compliance message for the deploy_application_gateway_diagnostic_setting definition"
  }
}
```

## [Policy Exemption Module](modules/exemption)

Use the exemption module in favour of `not_scopes` to create an auditable time-sensitive Policy exemption

```hcl
module exemption_team_a_mg_deny_nic_public_ip {
  source               = "azurenoops/overlays-policy/azurerm//modules/policyExemption"
  version              = "x.x.x"
  name                 = "Deny NIC Public IP Exemption"
  display_name         = "Exempted while testing"
  description          = "Allows NIC Public IPs for testing"
  scope                = data.azurerm_management_group.platforms.id
  policy_assignment_id = module.platforms_mg_deny_nic_public_ip.id
  exemption_category   = "Waiver"
  expires_on           = "2023-05-25" # optional

  # optional
  metadata = {
    requested_by  = "Team A"
    approved_by   = "Mr Smith"
    approved_date = "2021-11-30"
    ticket_ref    = "1923"
  }
}
```

> [Microsoft Docs: Azure Policy exemption structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure)

### Role Assignments

Role assignments and remediation tasks will be automatically created if the Policy Definition contains a list of [Role Definitions](custompolicies/tags/inherit_resource_group_tags_modify.json#L46). You can override these with explicit ones, by specifing `skip_role_assignment=true` to omit creation, this is also skipped when using User Managed Identities. By default role assignment scopes will match the policy assignment but can be changed by setting `role_assignment_scope`.

### Remediation Tasks

Unless you specify `skip_remediation=true`, the `*_assignment` modules will automatically create [remediation tasks](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources) for policies containing effects of `DeployIfNotExists` and `Modify`. The task name is suffixed with a `timestamp()` to ensure a new one gets created on each `terraform apply`.

### On-demand evaluation scan

To trigger an on-demand [compliance scan](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data) with terraform, set `re_evaluate_compliance = true` on `*_assignment` modules, defaults to `false (ExistingNonCompliant)`.

> **Note:** `ReEvaluateCompliance` only applies to remediation at Subscription scope and below and will take longer depending on the size of your environment.

## Custom Policy Definitions

The following table lists the Custom policy definitions that are available in the [Custom Polices library](customPolicies) and can be used with the [Policy Definitions Module](modules/policyDefinition). The table also includes the Policy Category and Description for each policy definition. The policy definitions are grouped by category.

### App Service

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| append_appservice_httpsonly | App Service | This policy appends the HTTPSONLY flag to the app service configuration. |
| append_appservice_latesttls | App Service | This policy appends the LATESTTLS flag to the app service configuration. |
| deny_appserviceapiapp_http | App Service | This policy denies HTTP on API App. |
| deny_appservicefunctionapp_http | App Service | This policy denies HTTP on Function App. |
| deny_appservicewebapp_http | App Service | This policy denies HTTP on Web App. |

### Automation

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| deny_aa_child_resources | Automation | This policy denies Automation Account child resources. |

### Cache

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| append_redis_disablenonsslport  | Cache | This policy appends the DISABLENONSSLPORT flag to the Redis configuration. |
| append_redis_sslenforcement | Cache | This policy appends the SSLENFORCEMENT flag to the Redis configuration. |
| deny_redis_http | Cache | This policy denies HTTP on Redis. |

### Compute

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| deploy_linux_log_analytics_vm_agent | Compute | This policy deploys linux log analytics vm agent on deployed VM |
| deploy_linux_vm_agent | Compute | This policy deploys linux vm agent on deployed VM |
<!-- | deploy_windows_log_analytics_vm_agent | Compute | This policy deploys windows log analytics vm agent on deployed VM |
| deploy_windows_vm_agent | Compute | This policy deploys windows vm agent on deployed VM| -->

### Cost Management

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| audit_disks_unused_resources | Cost Management | This policy audits disks unused resources. |
| audit_publicIp_addresses_unused_resources | Cost Management | This policy audits public IP addresses unused resources. |
| audit_serverfarms_unused_resources | Cost Management | This policy audits serverfarms unused resources. |
| deny_machinelearning_compute_vmsize | Cost Management | This policy denies machine learning with compute vm size. |
| deploy_budget | Cost Management | This policy deploys a budget. |

### Databricks

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| deny_databricks_nopublicip | Databricks | This policy denies public IP addresses on Databricks. |
| deny_databricks_sku | Databricks | This policy denies Databricks with certain SKU. |
| deny_databricks_virtualnetwork | Databricks | This policy denies Databricks with certain virtual network. |

### Deny Action

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| deny_action_activity_logs | Deny Action | This policy denies delete action activity logs. |
| deny_action_diagnostic_logs | Deny Action | This policy denies delete action diagnostic logs. |

### General

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| allowed_tags | General | This policy ensures that resources are tagged with allowed tags.

### Key Vault

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| append_kv_softdelete | Key Vault | This policy appends the SOFTDELETE flag to the key vault configuration. |
| audit_key_vault_location | Key Vault | This policy audits key vault location. |

### Machine Learning

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| audit_ml_privateendpointid | Machine Learning | This policy audits machine learning private endpoint id. |
| deny_machinelearning_aks | Machine Learning | This policy denies machine learning with AKS. |
| deny_ml_compute_subnetid | Machine Learning | This policy denies machine learning with compute subnet id. |
| deny_ml_compute_vmsize | Machine Learning | This policy denies machine learning with compute vm size. |
| deny_ml_pubicaccess | Machine Learning | This policy denies machine learning with compute cluster remote login port public access. |
| deny_ml_computecluster_scale | Machine Learning | This policy denies machine learning with compute cluster scale. |

### Monitoring

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
audit_log_analytics_workspace_retention | Monitoring | This policy audits Log Analytics Workspace retention. |
audit_subscription_diagnostic_setting_should_exist | Monitoring | This policy audits if a diagnostic setting exists for a subscription. |
deploy_api_mgmt_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for API Management. |
deploy_acr_diagnostic_settings | Monitoring | This policy deploys diagnostic settings for ACR. |
deploy_activitylog_keyvault_del | Monitoring |  This policy deploys activity log key vault delete. |
deploy_activityLogs_to_la_workspace | Monitoring | This policy deploys activity logs to a Log Analytics workspace. |
deploy_application_gateway_diagnostic_settings | Monitoring | This policy deploys diagnostic settings for Application Gateway. |
deploy_bastion_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Bastion. |
deploy_expressroute_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Express Route. |
deploy_eventhub_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Event Hub. |
deploy_firewall_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Firewall. |
deploy_frontdoor_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Front Door. |
deploy_function_diagnostics_setting | Monitoring | This policy deploys diagnostic settings for Function App. |
deploy_key_vault_diagnostic_settings | Monitoring | This policy deploys diagnostic settings for Key Vault. |
deploy_loadbalancer_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Load Balancer. |
deploy_logAnalytics_diagnostics_setting | Monitoring | This policy deploys diagnostic settings for Log Analytics Workspace. |
deploy_network_interface_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Network Interface. |
deploy_public_ip_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Public IP. |
deploy_redis_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Redis. |
deploy_storage_account_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Storage Account. |
deploy_subscription_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for a subscription. |
deploy_virtual_machine_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Virtual Machine. |
deploy_vmss_diagnostics_setting | Monitoring | This policy deploys diagnostic settings for VMSS. |
deploy_vnet_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Virtual Network. |
deploy_virtual_network_gateway_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Virtual Network Gateway. |
deploy_webapp_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Web App. |

### Network

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| deny_appgw_without_waf | Network | This policy denies Application Gateway without WAF. |  
| deny_mgmt_ports_from_internet | Network | This policy denies management ports from the internet. |
| deny_nic_public_ip_on_specific_subnets | Network | This policy denies public IP addresses on specific subnets. |
| deny_nic_public_ip | Network | This policy denies public IP addresses on network interfaces. |
| deny_private_dns_zones | Network | This policy denies private DNS zones. |
| deny_publicip | Network | This policy denies public IP addresses. |
| deny_rdp_from_internet  | Network | This policy denies RDP from the internet. |
| deny_subnet_without_nsg  | Network | This policy denies subnets without network security groups. |
| deny_unapproved_udr_hop_type | Network | This policy denies unapproved UDR hop types. |
| deny_vnet_peer_cross_sub | Network | This policy denies VNET peering across subscriptions. |
| deny_vnet_peering_to_non_approved_vnets | Network | This policy denies VNET peering to non-approved VNETs. |
| deploy_custom_route_table | Network | This policy deploys custom route table. |
| deploy_ddosprotection | Network | This policy deploys DDoS protection. |
| deploy_firewallpolicy | Network | This policy deploys firewall policy. |
| require_nsg_on_vnet | Network | This policy requires NSG on VNET |
| restrict_vnet_peering | Network | This policy restricts VNET peering |

### Security Center

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| deploy_asc_security_contacts | Security Center | This policy auto-sets contact details for Security Center. |

### SQL

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| deploy_sql_auditingsettings | SQL | This policy deploys SQL auditing settings. |
| deny_sql_mintls | SQL | This policy denies SQL minimum TLS version. |
| deploy_sql_security_alert_policies | SQL | This policy deploys SQL security alert policies. |

### Storage

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
deny_storage_mintls | Storage | This policy denies storage minimum TLS version. |
deny_storage_sftp | Storage | This policy denies storage SFTP. |
storage_enforce_https | Storage | This policy enforces HTTPS for storage accounts. |

### Tags

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
add_replace_resource_group_tag_key_modify | Tags | This policy adds or replaces a tag key on a resource group and modifies the value. |
inherit_resource_group_tags_append | Tags | This policy inherits tags from a resource group and appends them to a resource. |
inherit_resource_group_tags_modify | Tags | This policy inherits tags from a resource group and modifies them on a resource. |
require_resource_group_tags | Tags | This policy requires tags on a resource group. |
