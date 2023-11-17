##################################################
# VARIABLES                                      #
##################################################
variable "name" {
  type        = string
  description = "Name for the Policy Exemption"
}

variable "display_name" {
  type        = string
  description = "Display name for the Policy Exemption"
}

variable "description" {
  type        = string
  description = "Description for the Policy Exemption"
}

variable "scope" {
  type        = string
  description = "Scope for the Policy Exemption"
}

variable "policy_assignment_id" {
  type        = string
  description = "The ID of the policy assignment that is being exempted"
}

variable "policy_definition_reference_ids" {
  type        = list(string)
  description = "The optional policy definition reference ID list when the associated policy assignment is an assignment of a policy set definition. Omit to exempt all member definitions"
  default     = []
}

variable "member_definition_names" {
  type        = list(string)
  description = "Generate the definition reference Ids from the member definition names when 'policy_definition_reference_ids' are unknown. Omit to exempt all member definitions"
  default     = []
}

variable "exemption_category" {
  type        = string
  description = "The policy exemption category. Possible values are Waiver or Mitigated. Defaults to Waiver"
  default     = "Waiver"

  validation {
    condition     = var.exemption_category == "Waiver" || var.exemption_category == "Mitigated"
    error_message = "Exemption category possible values are: Waiver or Mitigated."
  }
}

variable "expires_on" {
  type        = string
  description = "Optional expiration date (format yyyy-mm-dd) of the policy exemption. Defaults to no expiry"
  default     = null
}

variable "metadata" {
  type        = any
  description = "Optional policy exemption metadata. For example but not limited to; requestedBy, approvedBy, approvedOn, ticketRef, etc"
  default     = null
}
