locals {
  # IP inventory for the homelab core services
  device = {
    "ipa" = {
      name        = "ipa.home.lab"
      ip          = "10.10.20.5"
      address     = "10.10.20.5/24"
      gateway     = "10.10.20.1"
      description = "FreeIPA Domain Controller"
      active      = true
    }

    "proxmox" = {
      ip          = "10.10.20.10"
      socket      = "10.10.20.10:8006"
      description = "HashiCorp Vault Server"
      active      = true
    }

  }
}
