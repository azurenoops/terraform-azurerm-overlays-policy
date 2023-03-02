package e2e

import (
	"regexp"
	"testing"

	test_helper "github.com/Azure/terraform-module-test-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestExamplesDefinitionWithAssignment(t *testing.T) {
	test_helper.RunE2ETest(t, "../../", "examples/definition_with_assignment", terraform.Options{
		Upgrade: true,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		gotpolicyAssignId, ok := output["policy_assignment_id"].(string)
		assert.True(t, ok)
		assert.Regexp(t, regexp.MustCompile("/providers/Microsoft.Management/managementGroups/anoa/providers/Microsoft.Authorization/policyAssignments/deny_resources_types"), gotpolicyAssignId)
	})
}


func TestExamplesDefinitionSetAssignment(t *testing.T) {
	test_helper.RunE2ETest(t, "../../", "examples/definition_set_assignment", terraform.Options{
		Upgrade: true,
	}, func(t *testing.T, output test_helper.TerraformOutput) {
		gotpolicySetId, ok := output["policy_set_id"].(string)
		assert.True(t, ok)
		assert.Regexp(t, regexp.MustCompile("/providers/Microsoft.Management/managementGroups/anoa/providers/Microsoft.Authorization/policySetDefinitions/configure_asc_initiative"), gotpolicySetId)
	})
}