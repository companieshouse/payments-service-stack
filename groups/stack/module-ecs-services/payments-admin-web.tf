locals {
  service_name = "payments-admin-web"
  pay_admin_proxy_port = 11000 # local port number defined for proxy target of payments service sitting behind eric
}

resource "aws_ecs_service" "payments-admin-web-ecs-service" {
  name            = "${var.environment}-${local.service_name}"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.payments-admin-web-task-definition.arn
  desired_count   = 1
  depends_on      = [var.admin-web-lb-arn]
  load_balancer {
    target_group_arn = aws_lb_target_group.payments-admin-web-target_group.arn
    container_port   = var.pay_admin_application_port
    container_name   = "eric" # [ALB -> target group -> eric -> payments admin] so eric container named here
  }
}

locals {
  definition = merge(
    {
      service_name               : local.service_name
      environment                : var.environment
      name_prefix                : var.name_prefix
      aws_region                 : var.aws_region
      external_top_level_domain  : var.external_top_level_domain
      account_subdomain_prefix   : var.account_subdomain_prefix
      log_level                  : var.log_level
      docker_registry            : var.docker_registry
      cookie_domain              : var.cookie_domain
      cookie_name                : var.cookie_name

      # eric specific configs
      eric_port                      : var.pay_admin_application_port # eric needs to be the first service in the chain from ALB
      eric_version                   : var.eric_version
      eric_cache_url                 : var.eric_cache_url
      eric_cache_max_connections     : var.eric_cache_max_connections
      eric_cache_max_idle            : var.eric_cache_max_idle
      eric_cache_idle_timeout        : var.eric_cache_idle_timeout
      eric_cache_ttl                 : var.eric_cache_ttl
      eric_flush_interval            : var.eric_flush_interval
      eric_graceful_shutdown_period  : var.eric_graceful_shutdown_period
      eric_default_rate_limit        : var.eric_default_rate_limit
      eric_default_rate_limit_window : var.eric_default_rate_limit_window

      # api configs      
      internal_api_url                   : var.internal_api_url
      api_url                            : var.api_url

      # pay_admin specific configs
      pay_admin_release_version          : var.pay_admin_release_version
      pay_admin_proxy_port               : local.pay_admin_proxy_port
      pay_api_url                        : var.pay_api_url
      pay_web_oauth2_redirect_uri        : var.pay_web_oauth2_redirect_uri
      pay_web_oauth2_token_uri           : var.pay_web_oauth2_token_uri
      pay_web_cdn_host                   : var.pay_web_cdn_host
      pay_web_chs_url                    : var.pay_web_chs_url
      pay_web_account_url                : var.pay_web_account_url
      pay_web_monitor_url                : var.pay_web_monitor_url
      pay_web_cache_pool_size            : var.pay_web_cache_pool_size
      pay_web_cache_server               : var.pay_web_cache_server
      pay_web_default_session_expiration : var.pay_web_default_session_expiration
    },
      var.secrets_arn_map
  )
}

resource "aws_ecs_task_definition" "payments-admin-web-task-definition" {
  family                = "${var.environment}-${local.service_name}"
  execution_role_arn    = var.task_execution_role_arn
  container_definitions = templatefile(
    "${path.module}/${local.service_name}-task-definition.tmpl", local.definition
  )
}

resource "aws_lb_target_group" "payments-admin-web-target_group" {
  name     = "${var.environment}-${local.service_name}"
  port     = var.pay_admin_application_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  health_check {
    healthy_threshold   = "5"
    unhealthy_threshold = "2"
    interval            = "30"
    matcher             = "200"
    path                = "/admin/payments/healthcheck"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = "5"
  }
}

resource "aws_lb_listener_rule" "payments-admin-web" {
  listener_arn = var.admin-web-lb-listener-arn
  priority     = 1
  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.payments-admin-web-target_group.arn
  }
}
