provider "rancher2" {
  alias     = "bootstrap"
  api_url   = "https://${var.rancher_domain_prefix}.${var.domain}"
  bootstrap = true
}

# Create a new rancher2_bootstrap using bootstrap provider config
resource "rancher2_bootstrap" "admin" {
  depends_on       = [helm_release.rancher]
  provider         = rancher2.bootstrap
  initial_password = random_password.rancher_init_password.result
}

# Provider config for admin
provider "rancher2" {
  api_url   = rancher2_bootstrap.admin.url
  token_key = rancher2_bootstrap.admin.token
}

resource "rancher2_node_driver" "hetzner_node_driver" {
  active            = true
  builtin           = false
  name              = "hetzner"
  ui_url            = "https://storage.googleapis.com/hcloud-rancher-v2-ui-driver/component.js"
  url               = "https://github.com/JonasProgrammer/docker-machine-driver-hetzner/releases/download/${var.hetzner_node_driver_version}/docker-machine-driver-hetzner_${var.hetzner_node_driver_version}_linux_amd64.tar.gz"
  whitelist_domains = ["storage.googleapis.com"]
}

# test_cluster = {
#   node_pools = [
#     {
#       "server_type"     = "cpx21"
#       "server_location" = "nbg1"
#       "image"           = "ubuntu-20.04"
#     },
#     {
#       "server_type"     = "cpx11"
#       "server_location" = "nbg1"
#       "image"           = "ubuntu-20.04"
#     }
#   ]
# }

locals {
  required_node_templates = merge([for name, cluster in var.cluster_configurations : { for node_pool in cluster.node_pools : "${node_pool.server_type}--${node_pool.server_location}--${node_pool.image}" => node_pool }]...)
  required_node_pools     = merge([for name, cluster in var.cluster_configurations : { for node_pool in cluster.node_pools : "${name}--${index(cluster.node_pools, node_pool)}" => node_pool }]...)
}

resource "rancher2_node_template" "hetzner" {
  for_each  = local.required_node_templates
  name      = each.key
  driver_id = rancher2_node_driver.hetzner_node_driver.id
  hetzner_config {
    api_token           = var.hetzner_token
    image               = each.value.image
    server_location     = each.value.server_location
    server_type         = each.value.server_type
    networks            = module.rke2.management_network_id
    use_private_network = true
  }
}

resource "rancher2_node_pool" "hetzner" {
  for_each         = local.required_node_pools
  cluster_id       = rancher2_cluster.hetzner[split("--", each.key)[0]].id
  name             = each.key
  hostname_prefix  = each.key
  node_template_id = rancher2_node_template.hetzner["${each.value.server_type}--${each.value.server_location}--${each.value.image}"].id
  quantity         = each.value.quantity
  control_plane    = each.value.control_plane
  etcd             = each.value.etcd
  worker           = each.value.worker
}

resource "rancher2_cluster" "hetzner" {
  for_each    = var.cluster_configurations
  name        = each.key
  description = each.value.description
  rke_config {
    addons         = <<EOF
---
apiVersion: v1
stringData:
  token: ${var.hetzner_token}
  network: ${module.rke2.management_network_name}
kind: Secret
metadata:
  name: hcloud
  namespace: kube-system
    EOF
    addons_include = ["https://github.com/hetznercloud/hcloud-cloud-controller-manager/releases/latest/download/ccm-networks.yaml"]
    services {
      kubelet {
        extra_args = {
          "cloud-provider" = "external"
        }
      }
    }
    kubernetes_version = each.value.kubernetes_version
    enable_cri_dockerd = true
    network {
      plugin = "canal"
    }
  }
}

resource "random_password" "admin_user" {
  length  = 16
  special = false
}

resource "rancher2_user" "admin_user" {
  name     = "rancheradmin"
  username = "rancheradmin"
  password = random_password.admin_user.result
  enabled  = true
}

resource "rancher2_global_role_binding" "admin_user" {
  name           = "rancheradmin"
  global_role_id = "admin"
  user_id        = rancher2_user.admin_user.id
}
