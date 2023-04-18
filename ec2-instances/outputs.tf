output "instance_id_master" {
  description = "IDs of EC2 master instance"
  value       = aws_instance.locust-master.id
}

output "instance_ids_workers" {
  description = "IDs of EC2 locust worker instances"
  value       = aws_instance.locust-workers.*.id
}

output "instance_ip_master" {
  description = "public ip address of locust master instance"
  value = aws_instance.locust-master.public_ip
}
output "instance_ips_workers" {
  description = "public ip address of locust worker nodes"
  value = aws_instance.locust-workers.*.public_ip 
}

output "instance_private_ip_master" {
  description = "private ip address of locust master instance"
  value = aws_instance.locust-master.private_ip 
}
output "instance_private_ips_workers" {
  description = "private ip address of locust worker nodes"
  value = aws_instance.locust-workers.*.private_ip 
}

