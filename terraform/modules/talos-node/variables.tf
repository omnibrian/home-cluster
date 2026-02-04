variable "name" {}
variable "tags" {
  default = []
}

variable "node_name" {}
variable "vm_id" {}

variable "template_vm_id" {}
variable "full_clone" {}

variable "cpu_cores" {}
variable "cpu_type" {}

variable "memory_mb" {}

variable "storage_pool" {}
variable "disk_size_gb" {}

variable "network_bridge" {}
variable "network_vlan_id" {}
