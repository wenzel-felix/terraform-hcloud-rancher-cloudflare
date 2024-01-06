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

variable "cloudflare_domain" {
  type        = string
  description = "Cloudflare Domain"  
}

variable "letsencrypt_issuer" {
  type = string
  description = "value for the letsencrypt issuer"
}

variable "generate_ssh_key_file" {
  type        = bool
  default     = true
  description = "Defines whether the generated ssh key should be stored as local file."
}