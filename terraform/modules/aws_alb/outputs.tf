output "alb_arn" {
  value = aws_lb.web-app.arn
}

output "target_arn" {
  value = aws_lb_target_group.app.arn
}