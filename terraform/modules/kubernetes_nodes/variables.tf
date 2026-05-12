variable "nodes" {
  description = <<-EOT
    Kubernetes nodes to create on Proxmox. Map keys are used as the VM name and must be unique.
    Values describe placement, sizing, and networking for each node.
  EOT
  type = map(object({
    proxmox_node = string
    vm_id        = number
    role         = string
    ipv4_address = string
    ipv4_gateway = string
    ipv4_prefix  = optional(number, 24)
    cpu_cores    = number
    memory_mib   = number
    disk_size_gb = number
    extra_tags   = optional(list(string), [])
  }))

  validation {
    condition = alltrue([
      for _, n in var.nodes : contains(["control-plane", "worker"], n.role)
    ])
    error_message = "Each node role must be either \"control-plane\" or \"worker\"."
  }
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key injected via cloud-init for the VM admin user."
}

variable "clone_template_vm_id" {
  type        = number
  description = "VMID of the Proxmox template (or source VM) to full-clone, for example a Packer-built image."
}

variable "full_clone" {
  type        = bool
  description = "When true, performs a full clone of the template. Recommended for independent Kubernetes nodes."
  default     = true
}

variable "datastore_id" {
  type        = string
  description = "Proxmox storage identifier for the primary disk (for example local-lvm)."
  default     = "local-lvm"
}

variable "network_bridge" {
  type        = string
  description = "Host bridge attached to the VM's primary NIC (for example vmbr0)."
  default     = "vmbr0"
}

variable "network_model" {
  type        = string
  description = "NIC model presented to the guest."
  default     = "virtio"
}

variable "dns_servers" {
  type        = list(string)
  description = "DNS servers applied to cloud-init network configuration."
  default     = ["192.168.1.1", "1.1.1.1"]
}

variable "cloud_init_username" {
  type        = string
  description = "Linux account created by cloud-init; must exist on the cloned template or be supported by its cloud-init config."
  default     = "ubuntu"
}

variable "cpu_type" {
  type        = string
  description = "CPU type passed to Proxmox (for example host for nested virt or scheduling affinity to the physical CPU)."
  default     = "host"
}

variable "guest_os_type" {
  type        = string
  description = "Proxmox guest OS type identifier (l26 = Linux 2.6+ kernel)."
  default     = "l26"
}

variable "common_tags" {
  type        = list(string)
  description = "Base tags applied to every VM; each VM also receives its role and any per-node extra_tags."
  default     = ["terraform", "kubernetes"]
}
