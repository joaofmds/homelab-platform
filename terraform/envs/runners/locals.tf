locals {
  # Two dedicated runner VMs (adjust VMIDs/IPs to your free addresses).
  github_runners = {
    "gha-runner-pve1" = {
      proxmox_node = "pve1"
      vm_id        = 401
      ipv4_address = "192.168.1.131"
      ipv4_gateway = "192.168.1.1"
      ipv4_prefix  = 24
      cpu_cores    = 2
      memory_mib   = 4096
      disk_size_gb = 32
      extra_tags   = ["pve1-runner"]
    }
    "gha-runner-pve2" = {
      proxmox_node = "pve2"
      vm_id        = 402
      ipv4_address = "192.168.1.132"
      ipv4_gateway = "192.168.1.1"
      ipv4_prefix  = 24
      cpu_cores    = 2
      memory_mib   = 4096
      disk_size_gb = 32
      extra_tags   = ["pve2-runner"]
    }
  }
}
