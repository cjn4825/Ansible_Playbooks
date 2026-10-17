locals {
  # IP inventory for the homelab
  device = {

    "ipa" = {
      ip          = "10.10.20.5"
      description = "FreeIPA Domain Controller"
      active      = true
    }

    "vault" = {
      ip          = "10.10.20.6"
      gateway     = "10.10.20.1"
      description = "HashiCorp Vault Server"
      active      = true
    }

    "proxmox" = {
      ip          = "10.10.20.10"
      socket      = "10.10.20.10:8006"
      description = "HashiCorp Vault Server"
      active      = true
    }

    # reserved IPs (not proxmox and physical hosts)
    "musicsrv" = {
      ip          = "10.10.60.5"
      description = "Music Server"
      active      = false
    }
  }
}
