variable "proxmox_pve1_endpoint" {
  type        = string
  description = "API do primeiro Proxmox (ex.: https://192.168.1.10:8006/api2/json). VMs com proxmox_node = pve1 em locals.tf."
}

variable "proxmox_pve1_api_token" {
  type        = string
  sensitive   = true
  description = "Token API do primeiro Proxmox (USER@REALM!TOKEN_ID=SECRET)."
}

variable "proxmox_pve2_endpoint" {
  type        = string
  description = "API do segundo Proxmox (ex.: https://192.168.1.20:8006/api2/json). VMs com proxmox_node = pve2 em locals.tf."
}

variable "proxmox_pve2_api_token" {
  type        = string
  sensitive   = true
  description = "Token API do segundo Proxmox."
}

variable "proxmox_tls_insecure" {
  type        = bool
  description = "Skip TLS verification when calling the Proxmox API. Prefer false when a proper CA or certificate is configured."
  default     = true
}

variable "ssh_public_key" {
  type        = string
  description = "Uma ou mais linhas OpenSSH públicas (ex.: conteúdo de ~/.ssh/id_ed25519.pub). O Proxmox devolve HTTP 500 \"SSH public key validation error\" se for placeholder ou formato inválido."

  validation {
    condition = (
      !can(regex("(?i)CHANGE_ME|EXAMPLE|placeholder", var.ssh_public_key)) &&
      anytrue([
        for line in split("\n", replace(var.ssh_public_key, "\r", "")) :
        length(trimspace(line)) > 40 &&
        can(regex("^(ssh-rsa|ssh-ed25519|ssh-ed448|ecdsa-sha2-nistp256|ecdsa-sha2-nistp384|ecdsa-sha2-nistp521)\\s+\\S+", trimspace(line)))
        if length(trimspace(line)) > 0
      ])
    )
    error_message = "Define ssh_public_key com pelo menos uma linha OpenSSH válida (ex.: saída de cat ~/.ssh/id_ed25519.pub). Evita placeholders; o Proxmox rejeita chaves inválidas com HTTP 500."
  }
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

variable "kubernetes_cloud_init_username" {
  type        = string
  description = "Linux user for cloud-init SSH keys; must exist on the cloned template (Packer autoinstall in this repo uses packer)."
  default     = "packer"
}
