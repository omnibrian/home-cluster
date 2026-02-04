resource "proxmox_virtual_environment_vm" "talos_node" {
  name        = var.name
  description = "Talos Node - ${var.name}"
  tags        = concat(["talos"], var.tags)

  node_name = var.node_name
  vm_id     = var.vm_id

  # clone {
  #   vm_id = var.template_vm_id
  #   full  = var.full_clone
  # }

  cpu {
    cores = var.cpu_cores
    type  = var.cpu_type
  }

  memory {
    dedicated = var.memory_mb
  }

  disk {
    datastore_id = var.storage_pool
    interface    = "scsi0"
    ssd          = true
    discard      = "on"
    size         = var.disk_size_gb
  }

  network_device {
    bridge  = var.network_bridge
    model   = "virtio"
    vlan_id = var.network_vlan_id
  }

  operating_system {
    type = "l26"
  }

  agent {
    enabled = false
  }
}
