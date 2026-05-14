# Dois servidores Proxmox independentes: um provider por API. O nome do nó em
# locals.kubernetes_nodes.*.proxmox_node (pve1 / pve2) escolhe em qual host a VM é criada.
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
