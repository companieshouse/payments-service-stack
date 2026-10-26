locals {
  stack_name     = "payments-service"
  stack_fullname = "${local.stack_name}-stack"
  name_prefix    = "${local.stack_name}-${var.environment}"

  stack_secrets              = jsondecode(data.vault_generic_secret.secrets.data_json)

  application_subnet_pattern   = local.stack_secrets["application_subnet_pattern"]
  application_subnet_ids       = join(",", data.aws_subnets.application.ids)
  vpc_name                     = local.stack_secrets["vpc_name"]
  notify_topic_slack_endpoints = local.stack_secrets["notify_topic_slack_endpoint"]

  default_tags = merge(module.owner_tags.tags, module.iac_tags.tags, {
    StackName          = local.stack_name
    Environment        = var.environment
    ManagedByTerraform = "true"
  }
)
}
