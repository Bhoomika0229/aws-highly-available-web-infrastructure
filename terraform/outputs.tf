output "vpc_id" {
  value = aws_vpc.main.id
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "target_group_arn" {
  value = aws_lb_target_group.web.arn
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.web.name
}