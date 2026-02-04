# ideally just call outs to modules in `modules/` setting env-specific config

# download talos image .iso
resource "talos_image_factory_schematic" "main" {
  schematic = yamlencode(
    {
      customization = {
        bootloader = "grub"
        systemExtensions = {
          officialExtensions = [
            "siderolabs/glibc",
            "siderolabs/gvisor",
            "siderolabs/i915",
            "siderolabs/intel-ucode",
            "siderolabs/iscsi-tools",
            # "siderolabs/nfs-utils",
            "siderolabs/qemu-guest-agent",
            "siderolabs/util-linux-tools",
          ]
        }
      }
    }
  )
}

resource "proxmox_virtual_environment_download_file" "talos_nocloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.node_name

  file_name               = "talos-${var.talos_version}-nocloud-amd64.img"
  url                     = "https://factory.talos.dev/image/${talos_image_factory_schematic.main.id}/${var.talos_version}/nocloud-amd64.raw.gz"
  decompression_algorithm = "gz"
  overwrite               = false
}

# TODO: talos control plane VM
resource "proxmox_virtual_environment_vm" "talos_controlplane" {
  count = 1

  name        = "talos-ctrl-${var.talos_version}-${count.index}"
  description = "Talos Node - Control Plane ${count.index}"
  tags        = ["talos", "talos-ctrl", var.talos_version]

  node_name = var.node_name
  vm_id     = 301

  cpu {
    cores = 4
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 4096 # or 8192 for 8GiB
    floating  = 4096 # set equal to dedicated to enable ballooning
  }

  disk {
    import_from  = proxmox_virtual_environment_download_file.talos_nocloud_image.id
    datastore_id = "MMS03" # ZFS datastore created on Hera from external drive
    interface    = "scsi0"
    ssd          = true
    discard      = "on"
    size         = "100" # size in GiB
  }

  initialization {
    datastore_id = "local-lvm"

    ip_config {
      ipv4 {
        address = "dhcp" # TODO: assign static IP for control plane VMs
      }
    }

    # user_account {
    #   keys = [trimspace(var.ssh_pub_key)]
    # }

    # user_data_file_id = proxmox_virtual_environment_file.talos_controlplane_cloud_config.id
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
    # vlan_id = var.network_vlan_id
  }

  operating_system {
    type = "l26"
  }

  tpm_state {
    version = "v2.0"
  }

  agent {
    enabled = true
  }
}

# TODO: talos worker node
