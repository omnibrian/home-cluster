variable "talos_version" {
  type        = string
  description = "Talos version to install in the deployed cluster"
  default     = "v1.12.2"
}

variable "node_name" {
  type        = string
  decsription = "Name of the Proxmox Node to deploy Talos cluster on"
  default     = "hera"
}
