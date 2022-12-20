data "vsphere_datastore" "datastore" {
  count         = length(var.vms)
  name          = var.vms[count.index].datastore_name
  datacenter_id = var.datacenter_id
}

data "vsphere_resource_pool" "pool" {
  count         = length(var.vms)
  name          = var.vms[count.index].resource_pool_name
  datacenter_id = var.datacenter_id
}

data "vsphere_network" "network" {
  count         = length(var.vms)
  name          = var.vms[count.index].network_name
  datacenter_id = var.datacenter_id
}

data "vsphere_virtual_machine" "template" {
  count         = length(var.vms)
  name          = var.vms[count.index].template_name
  datacenter_id = var.datacenter_id
}

data "vsphere_host" "host" {
  count         = length(var.vms)
  name          = var.vms[count.index].host_name
  datacenter_id = var.datacenter_id
}

resource "vsphere_virtual_machine" "vms" {
  count = length(var.vms)

  name   = "${var.vm_name_prefix}-${count.index + 1}"
  folder = var.folder_path

  annotation       = var.vms[count.index].description
  resource_pool_id = data.vsphere_resource_pool.pool[count.index].id
  datastore_id     = data.vsphere_datastore.datastore[count.index].id
  host_system_id   = data.vsphere_host.host[count.index].id

  num_cpus                   = var.vms[count.index].num_cpus
  memory                     = var.vms[count.index].memory
  wait_for_guest_net_timeout = 0
  guest_id                   = var.vms[count.index].guest_id

  disk {
    label            = "disk0"
    size             = var.vms[count.index].disk_capacity
    thin_provisioned = false
  }

  network_interface {
    network_id = data.vsphere_network.network[count.index].id
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template[count.index].id
  }

  cdrom {
    client_device = true
  }

  vapp {
    properties = {
      "user-data"   = "${base64encode(var.vms[count.index].user_data)}",
      "hostname"    = "${var.vm_name_prefix}-${count.index + 1}",
      "instance-id" = "${var.vm_name_prefix}-${count.index + 1}"
    }
  }

  tags = var.vms[count.index].tags
}
