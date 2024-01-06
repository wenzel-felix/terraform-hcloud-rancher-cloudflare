variable "hetzner_token" {
  type        = string
  description = "Hetzner Cloud API Token"
}

variable "cloudflare_token" {
  type        = string
  description = "Cloudflare API Token"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "rancher_domain_prefix" {
  type        = string
  description = "Domain prefix for the Rancher server"
  default     = "rancher"
}

variable "domain" {
  type        = string
  description = "The domain for the cluster."
}

variable "management_master_node_count" {
  type        = number
  default     = 1
  description = "value for the number of master nodes"
}

variable "rancher_version" {
  type        = string
  default     = "2.7.9"
  description = "rancher_version"
}

variable "management_worker_node_count" {
  type        = number
  default     = 0
  description = "value for the number of worker nodes"
}

variable "letsencrypt_issuer" {
  type        = string
  description = "value for the letsencrypt issuer"
}

variable "rke2_version" {
  type        = string
  default     = ""
  description = "value for the rke2 version"
}

variable "hetzner_node_driver_version" {
  type        = string
  default     = "5.0.2"
  description = "value for the hetzner node driver version"
}

variable "cluster_configurations" {
  description = "value for the cluster configurations"
  type = map(object({
    description = string
    kubernetes_version = string
    node_pools = list(object({
      server_type     = string
      server_location = string
      image           = string
      quantity        = number
      control_plane   = bool
      etcd            = bool
      worker          = bool
    }))
  }))
  default = {
    testcluster = {
      description        = "Test Cluster"
      kubernetes_version = "v1.24.13-rancher2-2"
      node_pools = [
        {
          server_type     = "cpx21"
          server_location = "nbg1"
          image           = "ubuntu-20.04"
          quantity        = 3
          control_plane   = true
          etcd            = true
          worker          = false
        },
        {
          server_type     = "cpx11"
          server_location = "nbg1"
          image           = "ubuntu-20.04"
          quantity        = 1
          control_plane   = false
          etcd            = false
          worker          = true
        }
      ]
    }
  }
}

variable "generate_ssh_key_file" {
  type        = bool
  default     = false
  description = "Defines whether the generated ssh key should be stored as local file."
}
