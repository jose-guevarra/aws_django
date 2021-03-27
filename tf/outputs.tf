


output "clb_dns_name" {
  value       = aws_elb.elb.dns_name
  description = "DNS name of the load balancer"
}


output "asg_id" {
  value       = aws_autoscaling_group.asg.id
  description = "Autoscale Group id."
}


output "db_dns_name" {
  value       = aws_db_instance.maindb.address
  description = "DNS Address of db."
}


