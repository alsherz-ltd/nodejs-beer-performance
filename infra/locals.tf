locals {
  name_prefix = "nodejs-beer-perf-${var.env}"

  app_nodes = {
    "01" = {
      size = "s-1vcpu-1gb-amd",
    },
  }

  root_domain = "nodebeer.asz.jsherz.com"
  domain      = "lb-${var.env}.${local.root_domain}"
}
