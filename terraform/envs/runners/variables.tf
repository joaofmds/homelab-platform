variable "proxmox_pve1_endpoint" {
  type        = string
  description = "API do Proxmox no primeiro servidor (ex.: https://192.168.1.10:8006/api2/json)."
}

variable "proxmox_pve1_api_token" {
  type        = string
  sensitive   = true
  description = "Token API do primeiro Proxmox (USER@REALM!ID=SECRET)."
}

variable "proxmox_pve2_endpoint" {
  type        = string
  description = "API do Proxmox no segundo servidor (ex.: https://192.168.1.20:8006/api2/json)."
}

variable "proxmox_pve2_api_token" {
  type        = string
  sensitive   = true
  description = "Token API do segundo Proxmox."
}

variable "proxmox_tls_insecure" {
  type        = bool
  description = "Ignorar verificação TLS nas duas APIs."
  default     = true
}

variable "ssh_public_key" {
  type        = string
  description = "Uma linha OpenSSH pública (ex.: conteúdo de ~/.ssh/id_ed25519.pub). Proxmox valida o formato; placeholders falham."

  validation {
    condition = (
      length(trimspace(var.ssh_public_key)) > 60 &&
      can(regex("^(ssh-rsa|ssh-ed25519|ssh-ed448|ecdsa-sha2-nistp256|ecdsa-sha2-nistp384|ecdsa-sha2-nistp521)\\s+.+\\s+", trimspace(var.ssh_public_key))) &&
      !can(regex("(?i)CHANGE_ME|EXAMPLE|placeholder", var.ssh_public_key))
    )
    error_message = "Define ssh_public_key com uma chave pública real (uma linha, tipo ssh-ed25519 AAAA... comentário). Copia de ~/.ssh/*.pub."
  }
}

variable "runner_template_vm_id" {
  type        = number
  description = "VMID do template em **cada** Proxmox (usa o mesmo ID se replicares a imagem nos dois)."
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
