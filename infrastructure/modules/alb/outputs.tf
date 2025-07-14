output "lb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.app_tg.arn
}

output "ecs_service_sg_id" {
  value = aws_security_group.ecs_service_sg.id
}

