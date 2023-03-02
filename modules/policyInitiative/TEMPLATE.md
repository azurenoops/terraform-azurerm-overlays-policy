# Azure NoOps Policy Set Module

This module creates a Policy Set Initiative in Azure. It is designed to be used with the [policyInitiative](module.tf) module. Dynamically creates a policy set based on multiple custom or built-in policy definitions

> **Warning:** If you don't specify `merge effects = false` or `merge parameters = false` as shown in the second example below, assignments will be merged to make them simpler if any `member definitions` have the same parameter names. This will result in the same parameter being used for multiple definitions and will cause the policy set to fail validation. This is a known issue and will be fixed in a future release.

> **Note:** If you need the same definition to appear more than once, use this module to build the initiative json, which you can then change to include unique parameter and definition references. Multiple entries of the same `member definitions` are not presently supported.

## Examples

### Create an Initiative with the Builtin Policy definitions

```hcl
module configure_asc_initiative {
  source                  = "azurenoops/overlays-policy/azurerm//modules/policyInitiative"
  version                = "0.0.1"
  initiative_name         = "configure_asc_initiative"
  initiative_display_name = "[Security]: Configure Azure Security Center"
  initiative_description  = "Deploys and configures Azure Security Center settings and defines exports"
  initiative_category     = "Security Center"
  management_group_id     = data.azurerm_management_group.org.id
  member_definitions = [
    module.configure_asc["auto_enroll_subscriptions"].definition,
    module.configure_asc["auto_provision_log_analytics_agent_custom_workspace"].definition,
    module.configure_asc["auto_set_contact_details"].definition,
    module.configure_asc["export_asc_alerts_and_recommendations_to_eventhub"].definition,
    module.configure_asc["export_asc_alerts_and_recommendations_to_log_analytics"].definition,
  ]
}
```

### Create an Initiative with a mix of custom & built-in Policy definitions without merging effects

When setting `merge_effects = false` each definition effect parameter will be suffixed with its respective policy definition reference Id e.g. `"effect_AutoEnrollSubscriptions"`.

```hcl
data azurerm_policy_definition deploy_law_on_linux_vms {
  display_name = "Deploy Log Analytics extension for Linux VMs"
}
module configure_asc_initiative {
  source                  = "gettek/policy-as-code/azurerm//modules/initiative"
  initiative_name         = "configure_asc_initiative"
  initiative_display_name = "[Security]: Configure Azure Security Center"
  initiative_description  = "Deploys and configures Azure Security Center settings and defines exports"
  initiative_category     = "Security Center"
  management_group_id     = data.azurerm_management_group.org.id
  merge_effects           = false
  member_definitions = [
    module.configure_asc["auto_enroll_subscriptions"].definition,
    module.configure_asc["auto_provision_log_analytics_agent_custom_workspace"].definition,
    module.configure_asc["auto_set_contact_details"].definition,
    module.configure_asc["export_asc_alerts_and_recommendations_to_eventhub"].definition,
    module.configure_asc["export_asc_alerts_and_recommendations_to_log_analytics"].definition,
    data.azurerm_policy_definition.deploy_law_on_linux_vms,
  ]
}
```

### Populate member_definitions with a for loop (not explicit)

```hcl
locals {
  guest_config_prereqs = [
    "add_system_identity_when_none_prerequisite",
    "add_system_identity_when_user_prerequisite",
    "deploy_extension_linux_prerequisite",
    "deploy_extension_windows_prerequisite",
  ]
}
module guest_config_prereqs {
  source                = "..//modules/definition"
  for_each              = toset(local.guest_config_prereqs)
  policy_name           = each.value
  policy_category       = "Guest Configuration"
  management_group_id   = data.azurerm_management_group.org.id
}
module guest_config_prereqs_initiative {
  source                  = "..//modules/initiative"
  initiative_name         = "guest_config_prereqs_initiative"
  initiative_display_name = "[GC]: Deploys Guest Config Prerequisites"
  initiative_description  = "Deploys and configures Windows and Linux VM Guest Config Prerequisites"
  initiative_category     = "Guest Configuration"
  management_group_id     = data.azurerm_management_group.org.id
  member_definitions = [
    for gcp in module.guest_config_prereqs :
    gcp.definition
  ]
}
```