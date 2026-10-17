resource "proxmox_virtual_environment_vm" "freeipa_server" {
  name      = local.device["ipa"].name
  node_name = "lab"
  vm_id     = 100

  disk {
    datastore_id = "vm_pool"
    import_from  = "local:import/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
    size         = 32
    interface    = "scsi0"
  }

  initialization {
    datastore_id = "vm_pool"

    ip_config {
      ipv4 {
        address = local.device["ipa"].address
        gateway = local.device["ipa"].gateway
      }
    }

    user_account {
      username = "ansible"
      keys     = [file("~/.ssh/id_rsa.pub")]
    }
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 8192
  }

  on_boot = true

  network_device {
    bridge = "vmbr0"
  }
}
