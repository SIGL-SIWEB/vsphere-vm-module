variable "datacenter_id" {
  type = string
}

variable "folder_path" {
  type = string
}

variable "vm_name_prefix" {
  type = string
}

variable "vms" {
  type = list(object({
    description   = string
    num_cpus      = number
    memory        = number
    disk_capacity = number
    user_data     = string

    host_name          = string
    datastore_name     = string
    resource_pool_name = string
    networks = list(object({
      id = string
    }))
    template_name = string
    guest_id      = string

    tags = list(string)
  }))
}
