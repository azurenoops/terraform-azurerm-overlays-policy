// https://github.com/terraform-linters/tflint/blob/master/docs/guides/config.md
config {
  module = false
  force  = false
}

plugin "azurerm" {
    enabled = true
    version = "0.25.1"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}