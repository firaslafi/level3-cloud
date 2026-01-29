output "server_id" {
  value       = stackit_server.example_server.id
  description = "The unique ID of the provisioned server."
}

output "server_private_ip" {
  value       = stackit_server.example_server.network_interfaces
  description = "The network interface details including IP addresses."
}