resource "proxmox_virtual_environment_file" "ipa_cloud_config" {
  content_type = "snippets"
  node_name    = "lab"
  datastore_id = "local"

  source_raw {
    file_name = "ipa-cloud-init.yaml"
    data      = <<-EOF
      #cloud-config
      package_update: false
      package_upgrade: false
      manage_etc_hosts: false
      hostname: ${local.device["ipa"].name}

      users:
        - name: ansible
          ssh_authorized_keys:
            - ${file(pathexpand("~/.ssh/id_rsa.pub"))}
          sudo: ['ALL=(ALL) NOPASSWD:ALL']
          shell: /bin/bash
      EOF
  }
}

resource "proxmox_virtual_environment_vm" "freeipa_server" {
  name      = local.device["ipa"].name
  node_name = "lab"
  vm_id     = 100

  agent {
    enabled = true
  }

  startup {
    order       = 1
    up_delay    = 60
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
    user_data_file_id = proxmox_virtual_environment_file.ipa_cloud_config.id

    ip_config {
      ipv4 {
        address = local.device["ipa"].address
        gateway = local.device["ipa"].gateway
      }
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
