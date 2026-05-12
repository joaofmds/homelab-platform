packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "ubuntu_2404" {
  proxmox_url              = var.proxmox_api_url
  username                 = var.proxmox_api_token_id
  token                    = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true

  node                 = var.proxmox_node
  vm_id                = var.template_id
  vm_name              = var.template_name
  template_description = "Ubuntu 24.04 Kubernetes base image built with Packer"

  iso_url          = "https://releases.ubuntu.com/releases/24.04/ubuntu-24.04.3-live-server-amd64.iso"
  iso_checksum     = "none"
  iso_storage_pool = "local"

  http_directory = "http"

  boot_wait = "5s"

  boot_command = [
    "e<wait>",
    "<down><down><down><end>",
    " autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/",
    "<f10>"
  ]

  cores   = 2
  memory  = 2048
  sockets = 1

  scsi_controller = "virtio-scsi-pci"

  disks {
    type         = "scsi"
    disk_size    = "20G"
    storage_pool = "local-lvm"
    format       = "raw"
  }

  network_adapters {
    model  = "virtio"
    bridge = "vmbr0"
  }

  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"

  qemu_agent = true

  ssh_username = var.ssh_username
  ssh_password = var.ssh_password
  ssh_timeout  = "30m"

  unmount_iso = true
}

build {
  name = "ubuntu-2404-k8s-template"

  sources = [
    "source.proxmox-iso.ubuntu_2404"
  ]

  provisioner "shell" {
    inline = [
      "echo 'Waiting for cloud-init...'",
      "sudo cloud-init status --wait"
    ]
  }

  provisioner "shell" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y qemu-guest-agent cloud-init curl ca-certificates gnupg",
      "sudo systemctl enable qemu-guest-agent",
      "sudo apt-get clean",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo rm -f /var/lib/dbus/machine-id",
      "sudo ln -sf /etc/machine-id /var/lib/dbus/machine-id"
    ]
  }

  provisioner "shell" {
    script = "http/scripts/cleanup.sh"
  }
}
