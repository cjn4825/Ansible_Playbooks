resource "proxmox_virtual_environment_vm" "vault_server" {
  name      = "vault.home.lab"
  node_name = "lab"
  vm_id     = 101

  boot_order = ["ide2", "scsi0"]

  cdrom {
    file_id = "local:iso/Rocky-9.8-x86_64-minimal.iso"
    interface = "ide2"
  }
  cpu {
    cores = 2
    type  = "host"
  }
  memory {
    dedicated = 2048
  }

  initialization {
    datastore_id = "vm_pool"
    user_account {
      username = "ansible"
      keys = [trimspace(file("~/.ssh/id_rsa.pub"))]
    }
    ip_config {
      ipv4 {
        address = local.device["vault"].ip
        gateway = local.device["vault"].gateway
      }
    }
  }

  on_boot = true
  startup {
    order = "2"
  }
  disk {
    datastore_id = "vm_pool"
    size         = 20
    interface    = "scsi0"
  }
  network_device {
    bridge = "vmbr0"
  }
}

resource "freeipa_dns_record" "vault_dns" {
  dnszoneidnsname = "home.lab"
  idnsname        = "vault"
  records         = [local.device["vault"].ip]
  type            = "A"
}
