output "alb_security_group_id" {
  value = aws_security_group.lb.id
}

output "alb_target_group_id" {
  value = aws_alb_target_group.app.id
}
