locals {
  talos_image_schematic_id = "cd7b20f9f86cf04710834e40a33085639ffc237376d173072cb449ed74e16ef5"
}

resource "proxmox_virtual_environment_download_file" "talos_nocloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = var.node_name

  file_name               = "talos-${var.talos_version}-nocloud-amd64.img"
  url                     = "https://factory.talos.dev/image/${local.talos_image_schematic_id}/${var.talos_version}/nocloud-amd64.raw.gz"
  decompression_algorithm = "gz"
  overwrite               = false
}
