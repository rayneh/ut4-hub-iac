terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "<proxmox-api>"
  pm_user         = var.username
  pm_password     = var.password
  pm_tls_insecure = true
  pm_debug        = false
  pm_log_enable   = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}

resource "proxmox_vm_qemu" "ut4-vm1" {
  # Required The name of the VM within Proxmox.
  name = "ut4-hub"

  # Required The name of the Proxmox Node on which to place the VM.
  target_node = "srv7"

  # The ID of the VM in Proxmox. The default value of 0 indicates it should use the next available ID in the sequence.
  # vmid = 0

  # The description of the VM. Shows as the 'Notes' field in the Proxmox GUI.
  desc = "UnrealPugs Island Hub"

  # Whether to let terraform define the (SSH) connection parameters for preprovisioners, see config block below.
  define_connection_info = true

  # The BIOS to use, options are seabios or ovmf for UEFI.
  bios = "seabios"

  # Whether to have the VM startup after the PVE node starts.
  onboot = true

  # Whether to have the VM startup after the VM is created.
  oncreate = true

  # Enable/disable the USB tablet device. This device is usually needed to allow absolute mouse positioning with VNC.
  tablet = true

  # The boot order for the VM. Ordered string of characters denoting boot order. Options: floppy (a), hard disk (c),
  # CD-ROM (d), or network (n).
  boot = "cd"

  # Enable booting from specified disk. You shouldn't need to change it under most circumstances.
  # bootdisk = ""

  # Set to 1 to enable the QEMU Guest Agent. Note, you must run the qemu-guest-agent daemon in the quest for this to
  # have any effect.
  agent = 1

  # The name of the ISO image to mount to the VM. Only applies when clone is not set. Either clone or iso needs to be
  # set.
  # iso = "debian-11.1.0-amd64-netinst.iso"

  # The base VM from which to clone to create the new VM.
  clone = "debian-11"

  # Requested HA state for the resource. One of "started", "stopped", "enabled", "disabled", or "ignored". See the docs
  # about HA for more info.
  # hastate = "disabled"

  # The HA group identifier the resource belongs to (requires hastate to be set!). See the docs about HA for more info.
  # hagroup =

  # The type of OS in the guest. Set properly to allow Proxmox to enable optimizations for the appropriate guest OS. It
  # takes the value from the source template and ignore any changes to resource configuration parameter.
  #
  # | type    | name                                    |
  # |---------|-----------------------------------------|
  # | other   | unspecified OS                          |
  # | wxp     | Microsoft Windows XP                    |
  # | w2k     | Microsoft Windows 2000                  |
  # | w2k3    | Microsoft Windows 2003                  |
  # | w2k8    | Microsoft Windows 2008                  |
  # | wvista  | Microsoft Windows Vista                 |
  # | win7    | Microsoft Windows 7                     |
  # | win8    | Microsoft Windows 8/2012/2012r2         |
  # | win10   | Microsoft Windows 10/2016/2019          |
  # | win11   | Microsoft Windows 11/2022               |
  # | l24     | Linux 2.4 Kernel                        |
  # | l26     | Linux 2.6 - 5.X Kernel                  |
  # | solaris | Solaris/OpenSolaris/OpenIndiania kernel |
  qemu_os = "l26"

  # The amount of memory to allocate to the VM in Megabytes.
  memory = 32768

  # The minimum amount of memory to allocate to the VM in Megabytes, when Automatic Memory Allocation is desired.
  # Proxmox will enable a balloon device on the guest to manage dynamic allocation. See the docs about memory for more
  # info.
  balloon = 0

  # The number of CPU sockets to allocate to the VM.
  sockets = 1

  # The number of CPU cores per CPU socket to allocate to the VM.
  cores = 6

  # The number of vCPUs plugged into the VM when it starts. If 0, this is set automatically by Proxmox to
  # sockets * cores.
  vcpus = 0

  # The type of CPU to emulate in the Guest. See the docs about CPU Types for more info.
  cpu = "host"

  # Whether to enable Non-Uniform Memory Access in the guest.
  numa = false

  # Comma delimited list of hotplug features to enable. Options: network, disk, cpu, memory, usb. Set to 0 to disable
  # hotplug.
  hotplug = "0"

  # The SCSI controller to emulate. Options: lsi, lsi53c810, megasas, pvscsi, virtio-scsi-pci, virtio-scsi-single.
  scsihw = "virtio-scsi-pci"

  # The resource pool to which the VM will be added.
  pool = "ut4"

  # Tags of the VM. This is only meta information.
  tags = "ut4;hub"

  # If false, and a vm of the same name, on the same node exists, terraform will attempt to reconfigure that VM with
  # these settings. Set to true to always create a new VM (note, the name of the VM must still be unique, otherwise an
  # error will be produced.)
  force_create = false

  # Which provisioning method to use, based on the OS type. Options: ubuntu, centos, cloud-init.
  os_type = "cloud-init"

  # The first IP address to assign to the guest.
  # Format: [gw=<GatewayIPv4>] [,gw6=<GatewayIPv6>] [,ip=<IPv4Format/CIDR>] [,ip6=<IPv6Format/CIDR>].
  ipconfig0 = ""

  # Override the default cloud-init user for provisioning.
  ciuser = "upugs"

  sshkeys = <<EOF
  ADD SSH KEYS HERE
  EOF

  # Sets default DNS server for guest.
  nameserver = "8.8.8.8"

  # Sets default DNS search domain suffix.
  searchdomain = ""


  vga {
    # The type of display to virtualize. Options: cirrus, none, qxl, qxl2, qxl3, qxl4, serial0, serial1, serial2,
    # serial3, std, virtio, vmware.
    type = "serial0"

    # Sets the VGA memory (in MiB). Has no effect with serial display type.
    # memory = 0
  }

  network {
    # Required Network Card Model. The virtio model provides the best performance with very low CPU overhead. If your
    # guest does not support this driver, it is usually best to use e1000. Options: e1000, e1000-82540em, e1000-82544gc,
    # e1000-82545em, i82551, i82557b, i82559er, ne2k_isa, ne2k_pci, pcnet, rtl8139, virtio, vmxnet3.
    model = "virtio"

    # Override the randomly generated MAC Address for the VM.
    # macaddr =

    # Bridge to which the network device should be attached. The Proxmox VE standard bridge is called vmbr0.
    bridge = "vmbr0"

    # The VLAN tag to apply to packets on this device. -1 disables VLAN tagging.
    tag = -1

    # Whether to enable the Proxmox firewall on this network device.
    firewall = false

    # Network device rate limit in mbps (megabytes per second) as floating point number. Set to 0 to disable rate limiting.
    rate = 0

    # Number of packet queues to be used on the device. Requires virtio model to have an effect.
    queues = 1

    # Whether this interface should be disconnected (like pulling the plug).
    link_down = false
  }

  disk {
    # Required The type of disk device to add. Options: ide, sata, scsi, virtio.
    type = "scsi"

    # Required The name of the storage pool on which to store the disk.
    storage = "reduced"

    # Required The size of the created disk, format must match the regex \d+[GMK], where G, M, and K represent Gigabytes, Megabytes, and Kilobytes respectively.
    size = "100G"

    # The drive’s backing file’s data format.
    # format = "raw"

    # The drive’s cache mode. Options: directsync, none, unsafe, writeback, writethrough
    cache = "none"

    # Whether the drive should be included when making backups.
    backup = 0

    # The drive’s media type. Options: cdrom, disk.
    # media = "disk"
  }
}
