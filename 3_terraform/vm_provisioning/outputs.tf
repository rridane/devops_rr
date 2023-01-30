#output "ip_addresses" {
#  value = [ for key, vm in esxi_guest.k8s-cluster-vms : {
#      id: vm.id
#      name: vm.guest_name
#      ip_address: vm.ip_address
#    }
#  ]
#}