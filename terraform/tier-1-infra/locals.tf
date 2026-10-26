locals {
  # IP inventory for the homelab tier 1 services
  device = {
    "ipa" = {
      name        = "ipa.home.lab"
      ip          = "10.10.20.5"
      address     = "10.10.20.5/24"
      gateway     = "10.10.20.1"
      description = "FreeIPA Domain Controller"
      active      = true
    }

    "vault" = {
      name        = "vault.home.lab"
      ip          = "10.10.20.6"
      address     = "10.10.20.6/24"
      gateway     = "10.10.20.1"
      description = "HashiCorp Vault Server"
      active      = true
    }

    "proxmox" = {
      ip          = "10.10.20.10"
      socket      = "10.10.20.10:8006"
      description = "Proxmox Server"
      active      = true
    }
  }
}
