locals {
  # Uma linha por chave; trim e ignora linhas vazias (evita erro de validação no Proxmox).
  cloud_init_ssh_keys = compact([
    for line in split("\n", replace(var.ssh_public_key, "\r", "")) : trimspace(line)
    if length(trimspace(line)) > 0
  ])
}

resource "proxmox_virtual_environment_vm" "node" {
  for_each = var.nodes

  name      = each.key
  node_name = each.value.proxmox_node
  vm_id     = each.value.vm_id

  description = "Kubernetes ${each.value.role} node (${each.key})"

  clone {
    vm_id = var.clone_template_vm_id
    full  = var.full_clone
  }

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = each.value.memory_mib
  }

  disk {
    datastore_id = var.datastore_id
    interface    = "scsi0"
    size         = each.value.disk_size_gb
  }

  network_device {
    bridge = var.network_bridge
    model  = var.network_model
  }

  initialization {
    user_account {
      username = var.cloud_init_username
      keys     = local.cloud_init_ssh_keys
    }

    ip_config {
      ipv4 {
        address = "${each.value.ipv4_address}/${each.value.ipv4_prefix}"
        gateway = each.value.ipv4_gateway
      }
    }

    dns {
      servers = var.dns_servers
    }
  }

  operating_system {
    type = var.guest_os_type
  }

  tags = concat(var.common_tags, [each.value.role], each.value.extra_tags)
}
