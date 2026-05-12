locals {
  # Homelab topology: edit here or move to a dedicated tfvars file as your workflow matures.
  kubernetes_nodes = {
    "k8s-cp-01" = {
      proxmox_node = "pve1"
      vm_id        = 301
      role         = "control-plane"
      ipv4_address = "192.168.1.111"
      ipv4_gateway = "192.168.1.1"
      ipv4_prefix  = 24
      cpu_cores    = 2
      memory_mib   = 8192
      disk_size_gb = 40
    }

    "k8s-worker-01" = {
      proxmox_node = "pve1"
      vm_id        = 311
      role         = "worker"
      ipv4_address = "192.168.1.121"
      ipv4_gateway = "192.168.1.1"
      ipv4_prefix  = 24
      cpu_cores    = 4
      memory_mib   = 8192
      disk_size_gb = 80
    }

    "k8s-worker-02" = {
      proxmox_node = "pve2"
      vm_id        = 312
      role         = "worker"
      ipv4_address = "192.168.1.122"
      ipv4_gateway = "192.168.1.1"
      ipv4_prefix  = 24
      cpu_cores    = 4
      memory_mib   = 8192
      disk_size_gb = 80
    }
  }
}
