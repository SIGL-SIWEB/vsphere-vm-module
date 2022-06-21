# vSphere Virtual Machine module

This Terraform module can be used to create multiple virtual machines at once
on VMware vSphere.

## Example usage

```hcl
module "vms" {
  source = "https://github.com/SIGL-SIWEB/vsphere-vm-module.git?tag=1.0.0

  datacenter_id = data.vsphere_datacenter.dc.id
  folder_path = "my/vms/folder"

  vm_name_prefix = "k8s-prod" # will output VM names like "k8s-prod-1"

  vms = [
    {
      description   = "Kubernetes Master 1"
      num_cpus      = 2
      memory        = 512
      disk_capacity = 50
      user_data     = file("cloud-init.yml")

      host_name          = "my-esxi-1.example.org"
      datastore_name     = "datastore"
      resource_pool_name = "resources"
      network_name       = "default_network"
      template_name      = "ubuntu_20"
    },
    {
      annotation    = "Kubernetes Worker 1"
      num_cpus      = 2
      memory        = 512
      disk_capacity = 50
      user_data     = file("cloud-init.yml")

      host_name          = "my-esxi-2.example.org"
      datastore_name     = "datastore"
      resource_pool_name = "resources"
      network_name       = "default_network"
      template_name      = "ubuntu_20"
    }
  ]
}
```
