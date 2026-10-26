terraform {
  required_version = ">= 1.5.0"

  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.117.0"
    }
    freeipa = {
      source  = "rework-space-com/freeipa"
      version = "5.6.0"
    }
  }
}

provider "proxmox" {
  endpoint  = "https://${local.device["proxmox"].socket}/"
  api_token = var.proxmox_api_token
  insecure  = true

  ssh {
    username = "root"
    agent = true
  }
}
