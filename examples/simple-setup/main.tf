module "rancher" {
  source                       = "../.."
  hetzner_token                = var.hetzner_token
  cloudflare_token             = var.cloudflare_token
  cloudflare_zone_id           = var.cloudflare_zone_id
  management_master_node_count = 3
  letsencrypt_issuer           = var.letsencrypt_issuer
  rke2_version                 = "v1.24.15+rke2r1"
  domain                       = var.cloudflare_domain
}

output "rancher_admin_username" {
  value = module.rancher.rancher_admin_username
}

output "rancher_admin_password" {
  value = nonsensitive(module.rancher.rancher_admin_password)
}

resource "local_file" "management_kube_config" {
  content  = module.rancher.management_kube_config
  filename = "kubeconfig"
}
