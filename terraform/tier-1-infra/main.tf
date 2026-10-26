resource "proxmox_virtual_environment_file" "vault_cloud_config" {
  content_type = "snippets"
  node_name    = "lab"
  datastore_id = "local"

  source_raw {
    file_name = "vault-cloud-init.yaml"
    data      = <<-EOF
      #cloud-config
      package_update: false
      package_upgrade: false
      manage_etc_hosts: false
      hostname: ${local.device["vault"].name}

      users:
        - name: ansible
          ssh_authorized_keys:
            - ${file(pathexpand("~/.ssh/id_rsa.pub"))}
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          shell: /bin/bash
      EOF
  }
}

resource "proxmox_virtual_environment_vm" "vault_server" {
  name      = local.device["vault"].name
  node_name = "lab"
  vm_id     = 101

  agent {
    enabled = true
  }

  startup {
    order       = 2
    up_delay    = 30
    down_delay  = 30
  }

  disk {
    datastore_id = "vm_pool"
    import_from  = "local:import/Rocky-9-GenericCloud-Base.latest.x86_64.qcow2"
    size         = 32
    interface    = "scsi0"
  }

  initialization {
    datastore_id = "local"
    user_data_file_id = proxmox_virtual_environment_file.vault_cloud_config.id

    ip_config {
      ipv4 {
        address = local.device["vault"].address
        gateway = local.device["vault"].gateway
      }
    }

    dns {
      domain  = "home.lab"
      servers = [local.device["ipa"].ip]
    }
  }

  cpu {
    cores = 2
    type  = "host"
  }

  memory {
    dedicated = 2048
  }

  on_boot = true

  network_device {
    bridge = "vmbr0"
  }
}
