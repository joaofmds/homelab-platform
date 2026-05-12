variable "proxmox_api_url" {
  type        = string
  description = "Proxmox API URL, e.g. https://proxmox.lan:8006/api2/json. Override for real builds."
  default     = "https://127.0.0.1:8006/api2/json"
}

variable "proxmox_api_token_id" {
  type        = string
  description = "API token ID (user@realm!tokenid). Override for real builds."
  default     = "root@pam!packer-validate"
}

variable "proxmox_api_token_secret" {
  type        = string
  sensitive   = true
  description = "API token secret. Override for real builds."
  default     = "packer-validate-replace-with-pkrvars"
}

variable "proxmox_node" {
  type        = string
  description = "Proxmox node name (e.g. pve). Override if yours differs."
  default     = "pve"
}

variable "template_id" {
  type        = number
  description = "VMID to assign to the Proxmox template (must be unused on the cluster)."
  default     = 9000
}

variable "template_name" {
  type        = string
  description = "Display name of the VM/template in Proxmox."
  default     = "ubuntu-2404-k8s-template"
}

variable "ssh_username" {
  type        = string
  description = "Linux user created by autoinstall; Packer uses this for SSH provisioners."
  default     = "packer"
}

variable "ssh_password" {
  type        = string
  sensitive   = true
  description = "SSH password for the Packer communicator; must match autoinstall user password."
  default     = "packer"
}
