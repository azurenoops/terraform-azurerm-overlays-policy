<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_policy_set_definition.set](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_set_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_initiative_category"></a> [initiative\_category](#input\_initiative\_category) | The category of the initiative | `string` | `"General"` | no |
| <a name="input_initiative_description"></a> [initiative\_description](#input\_initiative\_description) | Policy initiative description | `string` | `""` | no |
| <a name="input_initiative_display_name"></a> [initiative\_display\_name](#input\_initiative\_display\_name) | Policy initiative display name | `string` | n/a | yes |
| <a name="input_initiative_metadata"></a> [initiative\_metadata](#input\_initiative\_metadata) | The metadata for the policy initiative. This is a JSON object representing additional metadata that should be stored with the policy initiative. Omitting this will default to merge var.initiative\_category and var.initiative\_version | `any` | `null` | no |
| <a name="input_initiative_name"></a> [initiative\_name](#input\_initiative\_name) | Policy initiative name. Changing this forces a new resource to be created | `string` | n/a | yes |
| <a name="input_initiative_version"></a> [initiative\_version](#input\_initiative\_version) | The version for this initiative, defaults to 1.0.0 | `string` | `"1.0.0"` | no |
| <a name="input_management_group_id"></a> [management\_group\_id](#input\_management\_group\_id) | The management group scope at which the initiative will be defined. Defaults to current Subscription if omitted. Changing this forces a new resource to be created. Note: if you are using azurerm\_management\_group to assign a value to management\_group\_id, be sure to use name or group\_id attribute, but not id. | `string` | `null` | no |
| <a name="input_member_definitions"></a> [member\_definitions](#input\_member\_definitions) | Policy Defenition resource nodes that will be members of this initiative | `any` | n/a | yes |
| <a name="input_merge_effects"></a> [merge\_effects](#input\_merge\_effects) | Should the module merge all member definition effects? Defauls to true | `bool` | `true` | no |
| <a name="input_merge_parameters"></a> [merge\_parameters](#input\_merge\_parameters) | Should the module merge all member definition parameters? Defauls to true | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The Id of the Policy Set Definition |
| <a name="output_initiative"></a> [initiative](#output\_initiative) | The combined Policy Initiative resource node |
| <a name="output_metadata"></a> [metadata](#output\_metadata) | The metadata of the Policy Set Definition |
| <a name="output_name"></a> [name](#output\_name) | The name of the Policy Set Definition |
| <a name="output_parameters"></a> [parameters](#output\_parameters) | The combined parameters of the Policy Set Definition |
| <a name="output_role_definition_ids"></a> [role\_definition\_ids](#output\_role\_definition\_ids) | Role definition IDs for remediation |
<!-- END_TF_DOCS -->