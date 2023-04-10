<div align="center" width="100%">
    <h2>hcloud rancher module</h2>
    <p>Simple and fast deployment and configuration of a rancher environment running on a rke2 Kubernetes cluster on Hetzner Cloud.</p>
    <a target="_blank" href="https://github.com/wenzel-felix/terraform-hcloud-rancher-cloudflare/stargazers"><img src="https://img.shields.io/github/stars/wenzel-felix/terraform-hcloud-rancher-cloudflare" /></a>
    <a target="_blank" href="https://github.com/wenzel-felix/terraform-hcloud-rancher-cloudflare/releases"><img src="https://img.shields.io/github/v/release/wenzel-felix/terraform-hcloud-rancher-cloudflare?display_name=tag" /></a>
    <a target="_blank" href="https://github.com/wenzel-felix/terraform-hcloud-rancher-cloudflare/commits/master"><img src="https://img.shields.io/github/last-commit/wenzel-felix/terraform-hcloud-rancher-cloudflare" /></a>
</div>

## ✨ Features

- Utilizing the [rke2 cluster module on hcloud](https://github.com/wenzel-felix/terraform-hcloud-rke2) allows a straigforward custom rancher cluster deployment
- cert-manager integration for custom domain usage
- installing hetzner related kubernetes addons on the provisioned rancher clusters

## 🤔 Why?

Often times you have to manage multiple clusters and need to build PoCs to check certain requirements. This module allows to deploy custom configured rancher clusters integrated into the Hetzner environment, which allows fast and cheap testing.

## 🔧 Prerequisites

There are no special prerequirements in order to take advantage of this module. Only things required are:
* a Hetzner Cloud account
* access to Terraform

## 🚀 Usage

### Standalone

``` bash
terraform init
terraform apply
```

### As module

Refer to the module registry documentation [here](https://registry.terraform.io/modules/wenzel-felix/rancher-cloudflare/hcloud/latest).