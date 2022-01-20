output "admin-web-lb-listener-arn" {
  value = aws_lb_listener.admin-web-lb-listener.arn
}

output "admin-web-lb-arn" {
  value = aws_lb.admin-web-lb.arn
}
