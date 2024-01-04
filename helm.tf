provider "helm" {
  kubernetes {
    host = module.rke2.cluster_host

    client_certificate     = module.rke2.client_cert
    client_key             = module.rke2.client_key
    cluster_ca_certificate = module.rke2.cluster_ca
  }
}

resource "random_password" "rancher_init_password" {
  length  = 16
  special = false
}

resource "helm_release" "rancher" {
  name       = "rancher"
  namespace  = "cattle-system"
  chart      = "rancher"
  version    = var.rancher_version
  repository = "https://releases.rancher.com/server-charts/stable"
  depends_on = [helm_release.cert_manager]

  wait             = true
  create_namespace = true

  set {
    name  = "hostname"
    value = "${var.rancher_domain_prefix}.${var.domain}"
  }

  set {
    name  = "bootstrapPassword"
    value = random_password.rancher_init_password.result
  }

  set {
    name  = "ingress.tls.source"
    value = "letsEncrypt"
  }

  set {
    name  = "letsEncrypt.email"
    value = var.letsencrypt_issuer
  }
}
