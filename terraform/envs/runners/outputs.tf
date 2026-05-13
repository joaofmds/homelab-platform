output "runners" {
  description = "Metadados das VMs runner nos dois Proxmox."
  value = merge(
    module.github_runner_vm_pve1.runners,
    module.github_runner_vm_pve2.runners,
  )
}

output "ansible_host_vars" {
  description = "ansible_host sugerido por nome de VM (para o inventário Ansible)."
  value = merge(
    module.github_runner_vm_pve1.ansible_host_vars,
    module.github_runner_vm_pve2.ansible_host_vars,
  )
}
