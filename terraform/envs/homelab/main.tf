module "kubernetes_nodes" {
  source = "../../modules/kubernetes_nodes"

  nodes                = local.kubernetes_nodes
  ssh_public_key       = var.ssh_public_key
  clone_template_vm_id = var.kubernetes_template_vm_id
  dns_servers          = var.kubernetes_dns_servers
  datastore_id         = var.kubernetes_datastore_id
  network_bridge       = var.kubernetes_network_bridge
}
