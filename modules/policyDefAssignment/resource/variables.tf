##################################################
# VARIABLES                                      #
##################################################
variable definition {
  type        = any
  description = "Policy Definition resource node"
}

variable assignment_scope {
  type        = string
  description = "The scope at which the policy will be assigned. Must be full resource IDs. Changing this forces a new resource to be created"
}

variable assignment_not_scopes {
  type        = list(any)
  description = "A list of the Policy Assignment's excluded scopes. Must be full resource IDs"
  default     = []
}

variable assignment_name {
  type        = string
  description = "The name which should be used for this Policy Assignment, defaults to definition name. Changing this forces a new Policy Assignment to be created"
  default     = ""
}

variable assignment_display_name {
  type        = string
  description = "The policy assignment display name, defaults to definition display_name. Changing this forces a new resource to be created"
  default     = ""
}

variable assignment_description {
  type        = string
  description = "A description to use for the Policy Assignment, defaults to definition description. Changing this forces a new resource to be created"
  default     = ""
}

variable assignment_effect {
  type        = string
  description = "The effect of the policy. Changing this forces a new resource to be created"
  default     = null
}

variable assignment_parameters {
  type        = any
  description = "The policy assignment parameters. Changing this forces a new resource to be created"
  default     = null
}

variable assignment_metadata {
  type        = any
  description = "The optional metadata for the policy assignment."
  default     = null
}

variable assignment_enforcement_mode {
  type        = bool
  description = "Control whether the assignment is enforced"
  default     = true
}

variable assignment_location {
  type        = string
  description = "The Azure location where this policy assignment should exist, required when an Identity is assigned. Defaults to UK South. Changing this forces a new resource to be created"
  default     = "eastus"
}

variable non_compliance_message {
  type        = string
  description = "The optional non-compliance message text."
  default     = ""
}

variable resource_discovery_mode {
  type        = string
  description = "The way that resources to remediate are discovered. Possible values are ExistingNonCompliant or ReEvaluateCompliance. Defaults to ExistingNonCompliant. Applies to subscription scope and below"
  default     = "ExistingNonCompliant"

  validation {
    condition     = var.resource_discovery_mode == "ExistingNonCompliant" || var.resource_discovery_mode == "ReEvaluateCompliance"
    error_message = "Resource Discovery Mode possible values are: ExistingNonCompliant or ReEvaluateCompliance."
  }
}

variable remediation_scope {
  type        = string
  description = "The scope at which the remediation tasks will be created. Must be full resource IDs. Defaults to the policy assignment scope. Changing this forces a new resource to be created"
  default     = ""
}

variable location_filters {
  type        = list(any)
  description = "Optional list of the resource locations that will be remediated"
  default     = []
}

variable failure_percentage {
  type        = number
  description = "(Optional) A number between 0.0 to 1.0 representing the percentage failure threshold. The remediation will fail if the percentage of failed remediation operations (i.e. failed deployments) exceeds this threshold."
  default     = null
}

variable parallel_deployments {
  type        = number
  description = "(Optional) Determines how many resources to remediate at any given time. Can be used to increase or reduce the pace of the remediation. If not provided, the default parallel deployments value is used."
  default     = null
}

variable resource_count {
  type        = number
  description = "(Optional) Determines the max number of resources that can be remediated by the remediation job. If not provided, the default resource count is used."
  default     = null
}

variable role_definition_ids {
  type        = list(any)
  description = "List of Role definition ID's for the System Assigned Identity, defaults to roles included in the definition. Specify a blank array to skip creating role assignments. Changing this forces a new resource to be created"
  default     = []
}

variable role_assignment_scope {
  type        = string
  description = "The scope at which role definition(s) will be assigned, defaults to Policy Assignment Scope. Must be full resource IDs. Changing this forces a new resource to be created"
  default     = null
}

variable skip_remediation {
  type        = bool
  description = "Should the module skip creation of a remediation task for policies that DeployIfNotExists and Modify"
  default     = false
}

variable skip_role_assignment {
  type        = bool
  description = "Should the module skip creation of role assignment for policies that DeployIfNotExists and Modify"
  default     = false
}


