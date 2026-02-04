terraform {
  required_version = ">= 1.0"

  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.93"
    }

    talos = {
      source  = "siderolabs/talos"
      version = "~> 0.10"
    }
  }
}

provider "proxmox" {
  endpoint = "https://10.2.1.102:8006/"
  insecure = true # connection uses self-signed cert
  # username = $PROXMOX_VE_USERNAME
  # password = $PROXMOX_VE_PASSWORD
}
