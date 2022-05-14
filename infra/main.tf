data "digitalocean_image" "latest_lts" {
  slug = "ubuntu-22-04-x64"
}

data "digitalocean_ssh_key" "jsj_linux" {
  name = "Linux"
}

data "digitalocean_ssh_key" "jsj_macbook" {
  name = "Macbook"
}

# Used for deployments
data "digitalocean_ssh_key" "nodebeer" {
  name = "nodebeer"
}

resource "digitalocean_vpc" "main" {
  name   = local.name_prefix
  region = var.region
}

resource "digitalocean_database_cluster" "main" {
  name                 = local.name_prefix
  engine               = "pg"
  size                 = "db-s-1vcpu-2gb"
  region               = var.region
  node_count           = 1
  version              = "14"
  private_network_uuid = digitalocean_vpc.main.id
}

resource "digitalocean_droplet" "app_nodes" {
  for_each = local.app_nodes

  image    = data.digitalocean_image.latest_lts.slug
  name     = "${local.name_prefix}-app-${each.key}"
  region   = var.region
  size     = each.value.size
  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [
    data.digitalocean_ssh_key.jsj_linux.id,
    data.digitalocean_ssh_key.jsj_macbook.id,
    data.digitalocean_ssh_key.nodebeer.id,
  ]
  graceful_shutdown = false
}

resource "digitalocean_droplet" "load_tester_node" {
  image    = data.digitalocean_image.latest_lts.slug
  name     = "${local.name_prefix}-load-tester"
  region   = var.region
  size     = "s-1vcpu-1gb-amd"
  vpc_uuid = digitalocean_vpc.main.id
  ssh_keys = [
    data.digitalocean_ssh_key.jsj_linux.id,
    data.digitalocean_ssh_key.jsj_macbook.id,
    data.digitalocean_ssh_key.nodebeer.id,
  ]
  graceful_shutdown = false
}

data "digitalocean_certificate" "lb" {
  name = "nodejs-beer-perf-lb"
}

resource "digitalocean_loadbalancer" "main" {
  name      = local.name_prefix
  region    = var.region
  size_unit = 4 # 250 TLS connections per second each

  forwarding_rule {
    entry_port      = 80
    entry_protocol  = "http"
    target_port     = 3000
    target_protocol = "http"
  }

  forwarding_rule {
    entry_port       = 443
    entry_protocol   = "https"
    target_port      = 3000
    target_protocol  = "http"
    certificate_name = data.digitalocean_certificate.lb.name
  }

  healthcheck {
    protocol                 = "http"
    port                     = 3000
    path                     = "/healthz"
    check_interval_seconds   = 10
    response_timeout_seconds = 5
    unhealthy_threshold      = 3
    healthy_threshold        = 5
  }

  redirect_http_to_https = true
  vpc_uuid               = digitalocean_vpc.main.id
  droplet_ids            = [for k, v in digitalocean_droplet.app_nodes : v.id]
}

data "digitalocean_domain" "main" {
  name = local.root_domain
}

resource "digitalocean_record" "lb" {
  domain = data.digitalocean_domain.main.id
  name   = "${local.domain}."
  type   = "A"
  value  = digitalocean_loadbalancer.main.ip
}

resource "digitalocean_project" "main" {
  name        = local.name_prefix
  description = "A NodeJS performance test."
  environment = "development"

  resources = concat(
    [for k, v in digitalocean_droplet.app_nodes : v.urn],
    [
      digitalocean_loadbalancer.main.urn,
      digitalocean_database_cluster.main.urn,
      digitalocean_droplet.load_tester_node.urn,
  ])
}
