variable "node_list" {
  type = map(object({
    numvcpus        = string
    memsize         = string
    disk_store      = string
    virtual_network = string
    disk_size       = number
    ip_address      = string
  }))
  description = "Names of VMs to be create."
  default     = {
    "k8s-master-01" : {
      numvcpus        = 2
      memsize         = "2048"
      disk_store      = "datastore1"
      virtual_network = "VM Network"
      disk_size       = 100
      ip_address      = "10.10.10.100"
    },
    "k8s-master-02" : {
      numvcpus        = 2
      memsize         = "2048"
      disk_store      = "datastore1"
      virtual_network = "VM Network"
      disk_size       = 10
      ip_address      = "10.10.10.101"
    },
    "k8s-master-03" : {
      numvcpus        = 2
      memsize         = "2048"
      disk_store      = "datastore1"
      virtual_network = "VM Network"
      disk_size       = 100
      ip_address      = "10.10.10.102"
    },
    "k8s-slave-01" : {
      numvcpus        = 4
      memsize         = "4096"
      disk_store      = "datastore1"
      virtual_network = "VM Network"
      disk_size       = 100
      ip_address      = "10.10.10.103"
    },
    "k8s-slave-02" : {
      numvcpus        = 4
      memsize         = "4096"
      disk_store      = "datastore1"
      virtual_network = "VM Network"
      disk_size       = 100
      ip_address      = "10.10.10.104"
    },
    "k8s-slave-03" : {
      numvcpus        = 4
      memsize         = "4096"
      disk_store      = "datastore1"
      virtual_network = "VM Network"
      disk_size       = 100
      ip_address      = "10.10.10.105"
    }
    "k8s-haproxy-1" : {
      numvcpus        = 2
      memsize         = "2048"
      disk_store      = "datastore1"
      virtual_network = "VM Network"
      disk_size       = 30
      ip_address      = "10.10.10.106"
    }
    "k8s-haproxy-2" : {
      numvcpus        = 2
      memsize         = "2048"
      disk_store      = "datastore1"
      virtual_network = "VM Network"
      disk_size       = 30
      ip_address      = "10.10.10.107"
    }
    "nfs-server" : {
      numvcpus        = 2
      memsize         = "1024"
      disk_store      = "datastore1"
      virtual_network = "VM Network"
      disk_size       = 10000
      ip_address      = "10.10.10.109"
    }
    "ldap-server" : {
      numvcpus        = 2
      memsize         = "1024"
      disk_store      = "datastore1"
      virtual_network = "VM Network"
      disk_size       = 30
      ip_address      = "10.10.10.110"
    }
  }
}
