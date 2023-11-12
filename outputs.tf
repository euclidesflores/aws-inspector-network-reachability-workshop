output "LoadBalancerFullDNS" {
  description = "DNS Name of the Load Balancer for the WebApp Web Server"
  value       = aws_lb.web_app.dns_name
}

output "PoCWebServer1PublicDNS" {
  description = "Public DNS Name of the PoC Server in AZ1"
  value       = aws_instance.poc_server_az1.public_dns
}

output "PoCWebServer2PublicDNS" {
  description = "Public DNS Name of the PoC Server in AZ2"
  value       = aws_instance.poc_server_az2.public_dns
}

output "WebServer1InstanceID" {
  description = "Instance ID for the Web Server in AZ1"
  value       = aws_instance.web_app_server_az1.id
}

output "WebServer2InstanceID" {
  description = "Instance ID for the Web Server in AZ2"
  value       = aws_instance.web_app_server_az2.id
}

output "DatabaseServer1InstanceID" {
  description = "Instance ID for the Database Server in AZ1"
  value       = aws_instance.web_db_server_az1.id
}

output "DatabaseServer2InstanceID" {
  description = "Instance ID for the Database Server in AZ2"
  value       = aws_instance.web_db_server_az2.id
}

output "BastionServer1InstanceID" {
  description = "Instance ID for the Bastion Server in AZ1"
  value       = aws_instance.bastion_az1.id
}

output "BastionServer2InstanceID" {
  description = "Instance ID for the Bastion Server in AZ2"
  value       = aws_instance.bastion_az2.id
}

output "POCServer1InstanceID" {
  description = "Instance ID for the Proof of Concept Server in AZ1"
  value       = aws_instance.poc_server_az1.id
}

output "POCServer2InstanceID" {
  description = "Instance ID for the Proof of Concept Server in AZ2"
  value       = aws_instance.poc_server_az2.id
}