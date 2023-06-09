module "rke2" {
  source                               = "wenzel-felix/rke2/hcloud"
  version                              = "0.3.0"
  hetzner_token                        = var.hetzner_token
  use_cluster_managed_tls_certificates = false
  master_node_count                    = 3
  worker_node_count                    = 1
  additional_lb_service_ports          = ["80", "443"]
  rke2_version                         = var.rke2_version
}
