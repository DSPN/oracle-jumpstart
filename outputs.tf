# Output the private and public IPs of the DataStax OpsCenter instance


output "OpsCenter_URL" {
  value = ["${format("%s:8888", data.baremetal_core_vnic.DSE_OPSC_Vnic.public_ip_address)}"]
}

output "DataStax_Studio_URL" {
  value = ["${format("%s:9091", data.baremetal_core_vnic.DSE_OPSC_Vnic.public_ip_address)}"]
}


