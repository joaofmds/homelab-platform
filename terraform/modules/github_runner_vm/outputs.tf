output "runners" {
  description = "Runner VMs keyed by name with networking for Ansible inventory."
  value = {
    for name, vm in proxmox_virtual_environment_vm.runner : name => {
      vm_id        = vm.vm_id
      proxmox_node = vm.node_name
      ipv4         = "${var.runners[name].ipv4_address}/${var.runners[name].ipv4_prefix}"
      gateway      = var.runners[name].ipv4_gateway
    }
  }
}

output "ansible_host_vars" {
  description = "Suggested host vars keyed by VM name (merge into Ansible inventory)."
  value = {
    for name, r in var.runners : name => {
      ansible_host = r.ipv4_address
    }
  }
}
