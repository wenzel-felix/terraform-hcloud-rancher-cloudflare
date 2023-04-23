output "rancher_admin_password" {
  value = rancher2_user.admin_user.password
}

output "rancher_admin_username" {
  value = rancher2_user.admin_user.username
}

output "management_kube_config" {
  value = module.rke2.kube_config
}