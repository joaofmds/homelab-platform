# Garante que locals.kubernetes_nodes continua a representar 1 master + 2 workers.
check "kubernetes_one_control_plane" {
  assert {
    condition = length([
      for _, n in local.kubernetes_nodes : n if n.role == "control-plane"
    ]) == 1
    error_message = "Expected exactly 1 node with role \"control-plane\" in locals.kubernetes_nodes."
  }
}

check "kubernetes_two_workers" {
  assert {
    condition = length([
      for _, n in local.kubernetes_nodes : n if n.role == "worker"
    ]) == 2
    error_message = "Expected exactly 2 nodes with role \"worker\" in locals.kubernetes_nodes."
  }
}

check "kubernetes_proxmox_node_names" {
  assert {
    condition = alltrue([
      for _, n in local.kubernetes_nodes : contains(["pve1", "pve2"], n.proxmox_node)
    ])
    error_message = "Each kubernetes_nodes entry must use proxmox_node \"pve1\" or \"pve2\" (matches provider aliases in providers.tf)."
  }
}
