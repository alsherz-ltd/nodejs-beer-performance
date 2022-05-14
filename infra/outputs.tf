output "app_node_ips" {
  description = "IP addresses of droplets that run the Node code."
  value       = join("\n", [for k, v in digitalocean_droplet.app_nodes : v.ipv4_address])
}

output "load_tester_node_ip" {
  description = "IP address of droplets that runs Gatling."
  value       = digitalocean_droplet.load_tester_node.ipv4_address
}

output "url" {
  description = "Load balance URL."
  value       = "https://${local.domain}"
}

output "db_host" {
  value = digitalocean_database_cluster.main.private_host
}

output "db_external_host" {
  value = digitalocean_database_cluster.main.host
}

output "db_port" {
  value = digitalocean_database_cluster.main.port
}

output "db_user" {
  value = digitalocean_database_cluster.main.user
}

output "db_name" {
  value = digitalocean_database_cluster.main.database
}

output "db_pass" {
  value     = digitalocean_database_cluster.main.password
  sensitive = true
}
