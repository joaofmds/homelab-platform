variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox API URL, for example https://192.168.1.10:8006/api2/json (use one cluster endpoint)."
}

variable "proxmox_api_token" {
  type        = string
  sensitive   = true
  description = "API token in the form USER@REALM!TOKEN_ID=SECRET"
}

variable "proxmox_tls_insecure" {
  type        = bool
  description = "Skip TLS verification when calling the Proxmox API."
  default     = true
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key for the runner VM admin user (must match Ansible ssh identity)."
}

variable "runner_template_vm_id" {
  type        = number
  description = "VMID of the template to clone (same as Packer output / kubernetes stack)."
  default     = 9000
}

variable "runner_dns_servers" {
  type    = list(string)
  default = ["192.168.1.1", "1.1.1.1"]
}

variable "runner_datastore_id" {
  type    = string
  default = "local-lvm"
}

variable "runner_network_bridge" {
  type    = string
  default = "vmbr0"
}
