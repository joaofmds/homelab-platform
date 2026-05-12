output "runners" {
  description = "Runner VM metadata from Proxmox."
  value       = module.github_runner_vm.runners
}

output "ansible_host_vars" {
  description = "Suggested ansible_host per VM name; merge with inventory in ansible/inventory/."
  value       = module.github_runner_vm.ansible_host_vars
}
