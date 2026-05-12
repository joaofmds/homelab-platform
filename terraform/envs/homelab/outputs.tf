output "kubernetes_nodes" {
  description = "Kubernetes node inventory from the kubernetes_nodes module."
  value       = module.kubernetes_nodes.nodes
}

output "kubernetes_vm_ids" {
  description = "Sorted VMIDs for all Kubernetes nodes."
  value       = module.kubernetes_nodes.vm_ids
}
