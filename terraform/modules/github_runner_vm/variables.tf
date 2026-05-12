variable "runners" {
  description = <<-EOT
    Self-hosted GitHub Actions runner VMs. Map keys become the VM name in Proxmox.
    Use extra_tags for per-host labels (for example pve1-runner) mirrored in Proxmox for visibility.
  EOT
  type = map(object({
    proxmox_node = string
    vm_id        = number
    ipv4_address = string
    ipv4_gateway = string
    ipv4_prefix  = optional(number, 24)
    cpu_cores    = number
    memory_mib   = number
    disk_size_gb = number
    extra_tags   = optional(list(string), [])
  }))
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for the cloud-init admin user (Ansible connects here)."
}

variable "clone_template_vm_id" {
  type        = number
  description = "VMID of the golden template to full-clone (same image as Kubernetes nodes is fine)."
}

variable "full_clone" {
  type        = bool
  description = "Full clone so each runner disk is independent."
  default     = true
}

variable "datastore_id" {
  type        = string
  description = "Primary disk datastore id."
  default     = "local-lvm"
}

variable "network_bridge" {
  type        = string
  description = "Host bridge for the runner NIC."
  default     = "vmbr0"
}

variable "network_model" {
  type    = string
  default = "virtio"
}

variable "dns_servers" {
  type    = list(string)
  default = ["192.168.1.1", "1.1.1.1"]
}

variable "cloud_init_username" {
  type    = string
  default = "ubuntu"
}

variable "cpu_type" {
  type    = string
  default = "host"
}

variable "guest_os_type" {
  type    = string
  default = "l26"
}

variable "common_tags" {
  type        = list(string)
  description = "Base Proxmox tags on every runner VM."
  default     = ["terraform", "github-runner", "homelab"]
}
