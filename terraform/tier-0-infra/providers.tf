terraform {
  required_version = ">= 1.5.0"

  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "~> 0.60"
    }
    freeipa = {
      source  = "camptocamp/freeipa"
      version = "~> 0.8"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://${local.device["proxmox"].socket}/"
  api_token = var.proxmox_api_token
  insecure  = true
}

provider "freeipa" {
  username = "admin"
  password = var.ipa_password
  host     = local.device["ipa"].ip
  insecure = true
}
