module "github_runner_vm" {
  source = "../../modules/github_runner_vm"

  runners              = local.github_runners
  ssh_public_key       = var.ssh_public_key
  clone_template_vm_id = var.runner_template_vm_id
  dns_servers          = var.runner_dns_servers
  datastore_id         = var.runner_datastore_id
  network_bridge       = var.runner_network_bridge
}
