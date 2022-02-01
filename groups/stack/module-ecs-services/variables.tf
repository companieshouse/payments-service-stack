# Environment
variable "environment" {
  type        = string
  description = "The environment name, defined in environments vars."
}
variable "aws_region" {
  type        = string
  description = "The AWS region for deployment."
}

# Networking
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC for the target group and security group."
}
variable "payments-admin-web-lb-arn" {
  type        = string
  description = "The ARN of the load balancer created in the ecs-stack module."
}
variable "payments-admin-web-lb-listener-arn" {
  type        = string
  description = "The ARN of the lb listener created in the ecs-stack module."
}
variable "subnet_ids" {
  type        = string
  description = "Subnet IDs of application subnets from aws-mm-networks remote state."
}
variable "web_access_cidrs" {
  type        = list(string)
  description = "Subnet CIDRs for web ingress rules in the security group."
}

# DNS
variable "external_top_level_domain" {
  type        = string
  description = "The type levelel of the DNS domain for external access."
}
variable "internal_top_level_domain" {
  type        = string
  description = "The type levelel of the DNS domain for internal access."
}
variable "account_subdomain_prefix" {
  type = string
}

# ECS Service
variable "name_prefix" {
  type        = string
  description = "The name prefix to be used for stack / environment name spacing."
}
variable "ecs_cluster_id" {
  type        = string
  description = "The ARN of the ECS cluster to deploy the service to."
}

# Docker Container
variable "docker_registry" {
  type        = string
  description = "The FQDN of the Docker registry."
}
variable "task_execution_role_arn" {
  type        = string
  description = "The ARN of the task execution role that the container can assume."
}
variable "log_level" {
  type        = string
  description = "The log level to be set in the environment variables for the container."
}

# Certificates
variable "ssl_certificate_id" {
  type        = string
  description = "The ARN of the certificate for https access through the ALB."
}

# Secrets
variable "secrets_arn_map" {
  type = map(string)
  description = "The ARNs for all secrets"
}

# ------------------------------------------------------------------------------

# Services

# eric
variable "eric_version" {
  type        = string
  description = "The version of the eric service/container to run as a reverse proxy in front of pay_admin service."
}
variable "eric_cache_url" {
  type = string
}
variable "eric_cache_max_connections" {
  type = string
}
variable "eric_cache_max_idle" {
  type = string
}
variable "eric_cache_idle_timeout" {
  type = string
}
variable "eric_cache_ttl" {
  type = string
}
variable "eric_flush_interval" {
  type = string
}
variable "eric_graceful_shutdown_period" {
  type = string
}
variable "eric_default_rate_limit" {
  type = string
}
variable "eric_default_rate_limit_window" {
  type = string
}

# payments-admin-web
variable "pay_admin_release_version" {
  type        = string
  description = "The release version for the payments-admin-web service."
}
variable "pay_admin_application_port" {
  type        = string
  description = "The port number for the payments-admin-web service."
}
