output "payments-admin-web-lb-listener-arn" {
  value = aws_lb_listener.payments-admin-web-lb-listener.arn
}

output "payments-admin-web-lb-arn" {
  value = aws_lb.payments-admin-web-lb.arn
}
