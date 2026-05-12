output "nodes" {
  description = "Map of created VMs keyed by name, including addressing and placement."
  value = {
    for name, vm in proxmox_virtual_environment_vm.node : name => {
      vm_id        = vm.vm_id
      proxmox_node = vm.node_name
      role         = var.nodes[name].role
      ipv4         = "${var.nodes[name].ipv4_address}/${var.nodes[name].ipv4_prefix}"
      gateway      = var.nodes[name].ipv4_gateway
    }
  }
}

output "vm_ids" {
  description = "Ordered VMIDs for scripting or external integrations."
  value       = [for name in sort(keys(var.nodes)) : proxmox_virtual_environment_vm.node[name].vm_id]
}
