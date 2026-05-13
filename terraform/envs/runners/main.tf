module "github_runner_vm_pve1" {
  source = "../../modules/github_runner_vm"

  providers = { proxmox = proxmox.pve1 }

  runners              = local.github_runners_pve1
  ssh_public_key       = var.ssh_public_key
  clone_template_vm_id = var.runner_template_vm_id
  dns_servers          = var.runner_dns_servers
  datastore_id         = var.runner_datastore_id
  network_bridge       = var.runner_network_bridge
}

module "github_runner_vm_pve2" {
  source = "../../modules/github_runner_vm"

  providers = { proxmox = proxmox.pve2 }

  runners              = local.github_runners_pve2
  ssh_public_key       = var.ssh_public_key
  clone_template_vm_id = var.runner_template_vm_id
  dns_servers          = var.runner_dns_servers
  datastore_id         = var.runner_datastore_id
  network_bridge       = var.runner_network_bridge
}
