# Policy Set Assignment -  Resource

Assignments can be scoped to individual resources. This is useful for assigning policies to resources that are not yet managed by a management group.

> 💡 A role assignment and remediation task will be automatically created if any member definitions contain a list of `roleDefinitionIds`. This can be omitted with `skip_role_assignment = true`, or to assign roles at a different scope to that of the policy assignment use: `role_assignment_scope`. To successfully create Role-assignments (or group memberships) the deployment account may require the [User Access Administrator](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#user-access-administrator) role at the `assignment_scope` or preferably the `definition_scope` to simplify workflows.
