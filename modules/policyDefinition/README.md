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
| [azurerm_policy_definition.def](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/policy_definition) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display Name to be used for this policy | `string` | `""` | no |
| <a name="input_file_path"></a> [file\_path](#input\_file\_path) | The filepath to the custom policy. Omitting this assumes the policy is located in the module library | `any` | `null` | no |
| <a name="input_management_group_id"></a> [management\_group\_id](#input\_management\_group\_id) | The management group scope at which the policy will be defined. Defaults to current Subscription if omitted. Changing this forces a new resource to be created. | `string` | `null` | no |
| <a name="input_policy_category"></a> [policy\_category](#input\_policy\_category) | The category of the policy, when using the module library this should correspond to the correct category folder under /policies/var.policy\_category | `string` | `null` | no |
| <a name="input_policy_def_description"></a> [policy\_def\_description](#input\_policy\_def\_description) | Policy definition description | `string` | `""` | no |
| <a name="input_policy_def_metadata"></a> [policy\_def\_metadata](#input\_policy\_def\_metadata) | The metadata for the policy definition. This is a JSON object representing additional metadata that should be stored with the policy definition. Omitting this will fallback to meta in the definition or merge var.policy\_category and var.policy\_version | `any` | `null` | no |
| <a name="input_policy_def_name"></a> [policy\_def\_name](#input\_policy\_def\_name) | Name to be used for this policy, when using the module library this should correspond to the correct category folder under /policies/policy\_category/policy\_name. Changing this forces a new resource to be created. | `string` | `""` | no |
| <a name="input_policy_def_parameters"></a> [policy\_def\_parameters](#input\_policy\_def\_parameters) | Parameters for the policy definition. This field is a JSON object that allows you to parameterise your policy definition. Omitting this assumes the parameters are located in /policies/var.policy\_category/var.policy\_name.json | `any` | `null` | no |
| <a name="input_policy_def_rule"></a> [policy\_def\_rule](#input\_policy\_def\_rule) | The policy rule for the policy definition. This is a JSON object representing the rule that contains an if and a then block. Omitting this assumes the rules are located in /policies/var.policy\_category/var.policy\_name.json | `any` | `null` | no |
| <a name="input_policy_mode"></a> [policy\_mode](#input\_policy\_mode) | The policy mode that allows you to specify which resource types will be evaluated, defaults to All. Possible values are All and Indexed | `string` | `"All"` | no |
| <a name="input_policy_version"></a> [policy\_version](#input\_policy\_version) | The version for this policy, if different from the one stored in the definition metadata, defaults to 1.0.0 | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_definition"></a> [definition](#output\_definition) | The combined Policy Definition resource node |
| <a name="output_id"></a> [id](#output\_id) | The Id of the Policy Definition |
| <a name="output_metadata"></a> [metadata](#output\_metadata) | The metadata of the Policy Definition |
| <a name="output_name"></a> [name](#output\_name) | The name of the Policy Definition |
| <a name="output_parameters"></a> [parameters](#output\_parameters) | The parameters of the Policy Definition |
| <a name="output_rules"></a> [rules](#output\_rules) | The rules of the Policy Definition |
<!-- END_TF_DOCS -->