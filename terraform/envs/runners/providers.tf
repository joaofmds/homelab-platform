# Dois Proxmox independentes: um provider por API (notebook aplica uma vez; cada módulo usa o seu alias).
provider "proxmox" {
  alias     = "pve1"
  endpoint  = var.proxmox_pve1_endpoint
  api_token = var.proxmox_pve1_api_token
  insecure  = var.proxmox_tls_insecure
}

provider "proxmox" {
  alias     = "pve2"
  endpoint  = var.proxmox_pve2_endpoint
  api_token = var.proxmox_pve2_api_token
  insecure  = var.proxmox_tls_insecure
}
