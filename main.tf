terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.3"
    }
    rancher2 = {
      source  = "rancher/rancher2"
      version = "~> 2.0.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

resource "cloudflare_record" "rancher" {
  zone_id = var.cloudflare_zone_id
  name    = var.rancher_domain_prefix
  type    = "A"
  proxied = false
  value   = module.rke2.management_lb_ipv4
}
