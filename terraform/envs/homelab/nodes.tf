locals {
  kubernetes_nodes_pve1 = {
    for name, n in local.kubernetes_nodes : name => n
    if n.proxmox_node == "pve1"
  }
  kubernetes_nodes_pve2 = {
    for name, n in local.kubernetes_nodes : name => n
    if n.proxmox_node == "pve2"
  }
}

module "kubernetes_nodes_pve1" {
  source = "../../modules/kubernetes_nodes"

  providers = {
    proxmox = proxmox.pve1
  }

  nodes                = local.kubernetes_nodes_pve1
  ssh_public_key       = var.ssh_public_key
  clone_template_vm_id = var.kubernetes_template_vm_id
  dns_servers          = var.kubernetes_dns_servers
  datastore_id         = var.kubernetes_datastore_id
  network_bridge       = var.kubernetes_network_bridge
  cloud_init_username  = var.kubernetes_cloud_init_username
}

module "kubernetes_nodes_pve2" {
  source = "../../modules/kubernetes_nodes"

  providers = {
    proxmox = proxmox.pve2
  }

  nodes                = local.kubernetes_nodes_pve2
  ssh_public_key       = var.ssh_public_key
  clone_template_vm_id = var.kubernetes_template_vm_id
  dns_servers          = var.kubernetes_dns_servers
  datastore_id         = var.kubernetes_datastore_id
  network_bridge       = var.kubernetes_network_bridge
  cloud_init_username  = var.kubernetes_cloud_init_username
}
