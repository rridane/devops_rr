#resource "esxi_virtual_disk" "vdisks" {
#  for_each = var.node_list
#  virtual_disk_disk_store = "datastore1"
#  virtual_disk_dir = each.key
#  virtual_disk_name = each.key
#  virtual_disk_size = each.value.disk_size
#  virtual_disk_type = "eagerzeroedthick"
#}
#
#data "template_file" "userdata_default" {
#  template = file("template.tpl")
#}
#
#resource "esxi_guest" "k8s-cluster-vms" {
#  for_each       = var.node_list
#  guest_name     = each.key
#  disk_store     = each.value.disk_store
#  boot_disk_type = "eagerzeroedthick"
#  power = "on"
#  numvcpus = each.value.numvcpus
#  memsize = each.value.memsize
#
#  network_interfaces {
#    virtual_network = each.value.virtual_network
#    nic_type        = "vmxnet3"
#  }
#
#  virtual_disks {
#    virtual_disk_id = esxi_virtual_disk.vdisks[each.key].id
#    slot = "0:1"
#  }
#
#  ovf_source = "/home/rridane/ova/Ubuntu.ovf"
#
#  ovf_properties_timer = 300
#
#  ovf_properties {
#    key = "password"
#    value = "Passw0rd1"
#  }
#
#  ovf_properties {
#    key = "hostname"
#    value = "HelloWorld"
#  }
#
#  ovf_properties {
#    key = "user-data"
#    value = base64gzip(data.template_file.userdata_default.rendered)
#  }
#
##  ovf_properties {
##    key = "user-data"
##    value = base64encode(data.template_file.userdata_default[each.key].rendered)
##  }
##
#  guestinfo = {
#      userdata = base64gzip(data.template_file.userdata_default.rendered)
#      "userdata.encoding" = "gzip+base64"
##      metadata = base64encode(data.template_file.userdata_default[each.key].rendered)
##      "metadata.encoding" = "base64"
#
#  }
#
#}

provider "vsphere" {
  user                 = "administrator@vsphere.local"
  password             = "Soleil1234!!"
  vsphere_server       = "192.168.1.49"
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = "dc-01"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = "cluster-01"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  name          = "ALL"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_host" "host" {
  name          = "192.168.1.11"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template_from_ovf" {
  name = "Ubuntu"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  for_each = var.node_list
  name             = each.key
  resource_pool_id = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = each.value.numvcpus
  memory           = each.value.memsize
  host_system_id = data.vsphere_host.host.id
  guest_id = "ubuntu64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template_from_ovf.id
    customize {
      linux_options {
        host_name = each.key
        domain    = "rrdev"
      }
      network_interface {
        ipv4_address = each.value.ip_address
        ipv4_netmask = 24
      }
      ipv4_gateway = "10.10.10.1"
      dns_server_list = ["8.8.8.8", "1.1.1.1"]
      timeout      = 900
    }
  }

  disk {
    label = "disk0"
    size  = 100
    thin_provisioned = false
  }

  provisioner "file" {
    source = "/home/rridane/.ssh/id_rsa.pub"
    destination = "/tmp/rridane.key"
    connection {
      type = "ssh"
      host = self.default_ip_address
      user = "rridane"
      password = "root"
      timeout = "60s"
    }
  }

  provisioner "remote-exec" {

    connection {
      type = "ssh"
      host = self.default_ip_address
      user = "rridane"
      password = "root"
      timeout = "60s"
    }

    inline = ["cat /tmp/rridane.key >> /home/rridane/.ssh/authorized_keys"]
  }

}