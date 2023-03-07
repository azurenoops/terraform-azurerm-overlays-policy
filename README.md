<!-- markdownlint-configure-file { "MD004": { "style": "consistent" } } -->
<!-- markdownlint-disable MD033 -->
<p align="center">  
  <h1 align="left">Azure NoOps Accelerator Policy as Code Modules</h1>
  <p align="center">
    <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-orange.svg" alt="MIT License"></a>
    <a href="https://registry.terraform.io/modules/azurenoops/overlays-policy/azurerm/"><img src="https://img.shields.io/badge/terraform-registry-blue.svg" alt="Azure NoOps TF Registry"></a></br>
  </p>
</p>
<!-- markdownlint-enable MD033 -->

This Overlay terraform module simplifies the creation of custom and built-in Azure Policies to be used in a [SCCA compliant Mission Enclave](https://registry.terraform.io/modules/azurenoops/overlays-hubspoke/azurerm/latest).

## SCCA Compliance

This module can be SCCA compliant and can be used in a SCCA compliant Mission Enclave. Enable private endpoints and SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation]("https://www.cisa.gov/secure-cloud-computing-architecture").

## Contributing

If you want to contribute to this repository, feel free to to contribute to our Terraform module.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Usage

### [Policy Definitions Module](modules/policyDefinition)

This module creates a policy definition from a policy defination JSON file. The JSON file can be a custom policy definition or a built-in policy definition. The policy definition can be stored locally or remotely. The module can also be used to create a policy definition from a JSON file that is stored in a private GitHub repository.

```hcl
module allowed_regions {
  source              = "azurenoops/overlays-policy/azurerm//modules/policyDefinition"
  version             = ""
  policy_def_name     = "allowed_regions"
  display_name        = "Allow resources only in allowed regions"
  policy_category     = "Custom"
  file_path           = "<file path to json>/allowed_regions.json"
  management_group_id = local.management_group_id
}
```

### [Policy Definitions Module with Built-in Polices](modules/policyDefinition)

This module can use values from the [Built-in Polices library](customPolicies) variables `var.policy_def_name` and `var.policy_category` to match the corresponding custom policy definition `json` file. Other template files and data sources can also be read in at runtime; for examples of acceptable inputs, check the [module readme](modules/policyDefinition).

```hcl
module allowed_regions {
  source              = "azurenoops/overlays-policy/azurerm//modules/policyDefinition"
  version             = ""
  policy_def_name     = "allowed_regions"
  display_name        = "Allow resources only in allowed regions"
  policy_category     = "General"
  management_group_id = local.management_group_id
}
```

> 📘 [Microsoft Docs: Azure Policy definition structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure)

### Built-in Policy Definitions

The following table lists the built-in policy definitions that are available in the [Built-in Polices library](customPolicies) and can be used with the [Policy Definitions Module](modules/policyDefinition).

#### App Service

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| append_appservice_httpsonly | App Service | This policy appends the HTTPSONLY flag to the app service configuration. |
| append_appservice_latesttls | App Service | This policy appends the LATESTTLS flag to the app service configuration. |
| deny_appserviceapiapp_http | App Service | This policy denies HTTP on API App. |
| deny_appservicefunctionapp_http | App Service | This policy denies HTTP on Function App. |
| deny_appservicewebapp_http | App Service | This policy denies HTTP on Web App. |

#### Automation

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| deny_aa_child_resources | Automation | This policy denies Automation Account child resources. |

#### Cache

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| append_redis_disablenonsslport  | Cache | This policy appends the DISABLENONSSLPORT flag to the Redis configuration. |
| append_redis_sslenforcement | Cache | This policy appends the SSLENFORCEMENT flag to the Redis configuration. |
| deny_redis_http | Cache | This policy denies HTTP on Redis. |

#### Compute

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| deploy_linux_log_analytics_vm_agent | Compute | This policy deploys linux log analytics vm agent on deployed VM |
| deploy_linux_vm_agent | Compute | This policy deploys linux vm agent on deployed VM |
<!-- | deploy_windows_log_analytics_vm_agent | Compute | This policy deploys windows log analytics vm agent on deployed VM |
| deploy_windows_vm_agent | Compute | This policy deploys windows vm agent on deployed VM| -->

#### Databricks

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| deny_databricks_nopublicip | Databricks | This policy denies public IP addresses on Databricks. |
| deny_databricks_sku | Databricks | This policy denies Databricks with certain SKU. |
| deny_databricks_virtualnetwork | Databricks | This policy denies Databricks with certain virtual network. |

#### General

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| allowed_locations | General | This policy ensures that resources are deployed in allowed locations. |
| allowed_resource_types | General | This policy ensures that only allowed resource types are deployed. |
| allowed_tags | General | This policy ensures that resources are tagged with allowed tags. |
| deploy_budget | General | This policy deploys a budget. |

#### Key Vault

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| append_kv_softdelete | Key Vault | This policy appends the SOFTDELETE flag to the key vault configuration. |
| audit_key_vault_location | Key Vault | This policy audits key vault location. |

#### Machine Learning

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| audit_machinelearning_privateendpointid | Machine Learning | This policy audits machine learning private endpoint id. |
| deny_machinelearning_aks | Machine Learning | This policy denies machine learning with AKS. |
| deny_machinelearning_compute_subnetid | Machine Learning | This policy denies machine learning with compute subnet id. |
| deny_machinelearning_compute_vmsize | Machine Learning | This policy denies machine learning with compute vm size. |
| deny_machinelearning_computecluster_remoteloginportpublicaccess | Machine Learning | This policy denies machine learning with compute cluster remote login port public access. |
| deny_machinelearning_computecluster_scale | Machine Learning | This policy denies machine learning with compute cluster scale. |

#### Monitoring

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
audit_log_analytics_workspace_retention | Monitoring | This policy audits Log Analytics Workspace retention. |
audit_subscription_diagnostic_setting_should_exist | Monitoring | This policy audits if a diagnostic setting exists for a subscription. |
deploy_api_mgmt_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for API Management. |
deploy_application_gateway_diagnostic_settings | Monitoring | This policy deploys diagnostic settings for Application Gateway. |
deploy_bastion_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Bastion. |
deploy_eventhub_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Event Hub. |
deploy_firewall_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Firewall. |
deploy_key_vault_diagnostic_settings | Monitoring | This policy deploys diagnostic settings for Key Vault. |
deploy_loadbalancer_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Load Balancer. |
deploy_network_interface_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Network Interface. |
deploy_network_security_group_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Network Security Group. |
deploy_public_ip_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Public IP. |
deploy_storage_account_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Storage Account. |
deploy_subscription_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for a subscription. |
deploy_virtual_machine_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Virtual Machine. |
deploy_vnet_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Virtual Network. |
deploy_virtual_network_gateway_diagnostic_setting | Monitoring | This policy deploys diagnostic settings for Virtual Network Gateway. |

#### Network

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| deny_appgw_without_waf | Network | This policy denies Application Gateway without WAF. |
| deny_nic_public_ip | Network | This policy denies public IP addresses on network interfaces. |
| deny_private_dns_zones | Network | This policy denies private DNS zones. |
| deny_publicip | Network | This policy denies public IP addresses. |
| deny_rdp_from_internet  | Network | This policy denies RDP from the internet. |
| deny_subnet_without_nsg  | Network | This policy denies subnets without network security groups. |
| deny_unapproved_udr_hop_type | Network | This policy denies unapproved UDR hop types. |
| deploy_ddosprotection | Network | This policy deploys DDoS protection. |
| deploy_firewallpolicy | Network | This policy deploys firewall policy. |
| require_nsg_on_vnet | Network | This policy requires NSG on VNET |
| restrict_vnet_peering | Network | This policy restricts VNET peering |

#### Security Center

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
auto_enroll_subscriptions | Security Center | This policy auto-enrolls subscriptions to Security Center. |
| auto_provision_log_analytics_agent_custom_workspace | Security Center | This policy auto-provisions the Log Analytics agent to a custom workspace. |
| auto_set_contact_details | Security Center | This policy auto-sets contact details for Security Center. |
| enable_vulnerability_vm_assessments | Security Center | This policy enables vulnerability assessments for virtual machines. |
| export_asc_alerts_and_recommendations_to_eventhub | Security Center | This policy exports ASC alerts and recommendations to an event hub. |
| export_asc_alerts_and_recommendations_to_log_analytics | Security Center | This policy exports ASC alerts and recommendations to a Log Analytics workspace. |

#### SQL

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
| deny_publicendpoint_mariadb | SQL | This policy denies public endpoint for MariaDB. |
| deny_sql_mintls | SQL | This policy denies SQL minimum TLS version. |
| deploy_sql_auditingsettings | SQL | This policy deploys SQL auditing settings. |

#### Storage

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
storage_enforce_https | Storage | This policy enforces HTTPS for storage accounts. |
storage_enforce_minimum_tls1_2 | Storage | This policy enforces minimum TLS 1.2 for storage accounts. |
storage_enforce_network_rules | Storage | This policy enforces network rules for storage accounts. |
storage_enforce_public_access | Storage | This policy enforces public access for storage accounts. |

#### Tags

| Policy Definition Name | Policy Category | Description |
| ---------------------- | --------------- | ----------- |
add_replace_resource_group_tag_key_modify | Tags | This policy adds or replaces a tag key on a resource group and modifies the value. |
inherit_resource_group_tags_append | Tags | This policy inherits tags from a resource group and appends them to a resource. |
inherit_resource_group_tags_modify | Tags | This policy inherits tags from a resource group and modifies them on a resource. |
require_resource_group_tags | Tags | This policy requires tags on a resource group. |

### [Policy Initiative (Set Definitions) Module](modules/initiative)

Dynamically create a policy set based on multiple custom or built-in policy definition references to simplify assignments.

```hcl
module platform_baseline_initiative {
  source                  = "azurenoops/overlays-policy/azurerm//modules/policyInitiative"
  initiative_name         = "platform_baseline_initiative"
  initiative_display_name = "[Platform]: Baseline Policy Set"
  initiative_description  = "Collection of policies representing the baseline platform requirements"
  initiative_category     = "General"
  management_group_id     = local.management_group_id
  member_definitions = [
    module.allowed_resources.definition,
    module.allowed_regions.definition
  ]
}
```

> 📘 [Microsoft Docs: Azure Policy initiative definition structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/initiative-definition-structure)

### [Policy Definition Assignment Module](modules/def_assignment)

Assign a policy definition to a management group, subscription, resouce group or resource. The assignment can be set to `DeployIfNotExists` or `Deny`. The assignment can also be set to `DeployIfNotExists` and remediate the non-compliant resources.

```hcl
module org_mg_whitelist_regions {
  source            = "azurenoops/overlays-policy/azurerm//modules/policyDefAssignment/managmentGroup"
  definition        = module.allowed_regions.definition
  assignment_scope  = local.management_group_id
  assignment_effect = "Deny"
  assignment_parameters = {
    listOfRegionsAllowed = [
      "UK South",
      "UK West",
      "Global"
    ]
  }
}
```

> 📘 [Microsoft Docs: Azure Policy assignment structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/assignment-structure)

### [Policy Initiative Assignment Module](modules/set_assignment)

Assign a policy set to a management group.

```hcl
module org_mg_platform_diagnostics_initiative {
  source                  = "azurenoops/overlays-policy/azurerm//modules/policySetAssignment"
  initiative              = module.platform_diagnostics_initiative.initiative
  assignment_scope        = data.azurerm_management_group.org.id
  assignment_effect       = "DeployIfNotExists"
  skip_remediation        = false
  skip_role_assignment    = false
  remediation_scope       = data.azurerm_subscription.current.id
  resource_discovery_mode = "ReEvaluateCompliance"
  assignment_parameters = {
    workspaceId                 = data.azurerm_log_analytics_workspace.workspace.id
    storageAccountId            = data.azurerm_storage_account.sa.id
    eventHubName                = data.azurerm_eventhub_namespace.ehn.name
    eventHubAuthorizationRuleId = data.azurerm_eventhub_namespace_authorization_rule.ehnar.id
    metricsEnabled              = "True"
    logsEnabled                 = "True"
  }
  assignment_not_scopes = [
    data.azurerm_management_group.team_dev.id
  ]
  non_compliance_messages = {
    null                                        = "The Default non-compliance message for all member definitions"
    "DeployApplicationGatewayDiagnosticSetting" = "The non-compliance message for the deploy_application_gateway_diagnostic_setting definition"
  }
}
```

### [Policy Exemption Module](modules/exemption)

Use the exemption module in favour of `not_scopes` to create an auditable time-sensitive Policy exemption

```hcl
module exemption_team_dev_mg_deny_nic_public_ip {
  source               = "azurenoops/overlays-policy/azurerm//modules/policyExemption"
  name                 = "Deny NIC Public IP Exemption"
  display_name         = "Exempted while testing"
  description          = "Allows NIC Public IPs for testing"
  scope                = data.azurerm_management_group.team_dev.id
  policy_assignment_id = module.team_dev_mg_deny_nic_public_ip.id
  exemption_category   = "Waiver"
  expires_on           = "2023-05-25" # optional
  # optional
  metadata = {
    requested_by  = "Team Development"
    approved_by   = "Jim Developer"
    approved_date = "2021-11-30"
  }
}
```

> 📘 [Microsoft Docs: Azure Policy exemption structure](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/exemption-structure)

## Building out Continuous Governance

### Assignment Effects

Azure Policy supports the following types of effect:

![Types Policy Effects from least to most restrictive](img/effects.svg)

> **Note:** If you're managing tags, it's recommended to use `Modify` instead of `Append` as Modify provides additional operation types and the ability to remediate existing resources. However, Append is recommended if you aren't able to create a managed identity or Modify doesn't yet support the alias for the resource property.
> 📘 [Microsoft Docs: Understand how effects work](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effects)

### Role Assignments

Role assignments and remediation tasks will be automatically created if the Policy Definition contains a list of [Role Definitions](policies/Tags/inherit_resource_group_tags_modify.json#L46). You can override these with explicit ones, [as seen here](examples/assignments_org.tf#L40), or specify `skip_role_assignment=true` to omit creation, this is also skipped when using User Managed Identities. By default role assignment scopes will match the policy assignment but can be changed by setting `role_assignment_scope`.

### Remediation Tasks

Unless you specify `skip_remediation=true`, the `*_assignment` modules will automatically create [remediation tasks](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/remediate-resources) for policies containing effects of `DeployIfNotExists` and `Modify`. The task name is suffixed with a `timestamp()` to ensure a new one gets created on each `terraform apply`.

### On-demand evaluation scan

To trigger an on-demand [compliance scan](https://learn.microsoft.com/en-us/azure/governance/policy/how-to/get-compliance-data) with terraform, set `resource_discovery_mode=ReEvaluateCompliance` on `*_assignment` modules, defaults to `ExistingNonCompliant`.

> **Note:** `ReEvaluateCompliance` only applies to remediation at Subscription scope and below and will take longer depending on the size of your environment.

### Definition and Assignment Scopes

- Should be Defined as **high up** in the hierarchy as possible.
- Should be Assigned as **low down** in the hierarchy as possible.
- Multiple scopes can be exempt from policy inheritance by specifying `assignment_not_scopes` or using the [exemption module](modules/exemption).
- Policy **overrides RBAC** so even resource owners and contributors fall under compliance enforcements assigned at a higher scope (unless the policy is assigned at the ownership scope).
