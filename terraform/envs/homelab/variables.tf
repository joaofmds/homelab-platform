variable "proxmox_endpoint" {
  type        = string
  description = "Proxmox API URL, for example https://pve.example.com:8006/api2/json"
}

variable "proxmox_api_token" {
  type        = string
  sensitive   = true
  description = "API token in the form USER@REALM!TOKEN_ID=SECRET"
}

variable "proxmox_tls_insecure" {
  type        = bool
  description = "Skip TLS verification when calling the Proxmox API. Prefer false when a proper CA or certificate is configured."
  default     = true
}

variable "ssh_public_key" {
  type        = string
  description = "SSH public key passed to the kubernetes_nodes module for cloud-init."
}

variable "kubernetes_template_vm_id" {
  type        = number
  description = "VMID of the template to clone for every Kubernetes node (match your Packer or golden image)."
  default     = 9000
}

variable "kubernetes_dns_servers" {
  type        = list(string)
  description = "DNS servers for all nodes unless you split environments later."
  default     = ["192.168.1.1", "1.1.1.1"]
}

variable "kubernetes_datastore_id" {
  type        = string
  description = "Default Proxmox datastore for node disks."
  default     = "local-lvm"
}

variable "kubernetes_network_bridge" {
  type        = string
  description = "Host bridge for node NICs."
  default     = "vmbr0"
}
