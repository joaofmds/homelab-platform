output "kubernetes_nodes" {
  description = "Kubernetes node inventory (merge of both Proxmox hosts)."
  value       = merge(module.kubernetes_nodes_pve1.nodes, module.kubernetes_nodes_pve2.nodes)
}

output "kubernetes_vm_ids" {
  description = "VMIDs for all Kubernetes nodes (pve1 list then pve2 list, each sorted by name)."
  value       = concat(module.kubernetes_nodes_pve1.vm_ids, module.kubernetes_nodes_pve2.vm_ids)
}
