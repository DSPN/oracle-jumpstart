# Compute resources

resource "baremetal_core_instance" "DSE_OPSC" {
    depends_on = ["baremetal_core_subnet.DataStax_PublicSubnet_AD"]
    availability_domain = "${lookup(data.baremetal_identity_availability_domains.ADs.availability_domains[0],"name")}"
    compartment_id = "${var.compartment_ocid}"
    display_name = "OPSC_AD_1-0"
    image = "${var.OPSC_BASE_IMAGE_ID}"
    shape = "${var.OPSC_Shape}"
    subnet_id = "${baremetal_core_subnet.DataStax_PublicSubnet_AD.0.id}"
    metadata {
        user_data = "${base64encode(format("%s\n%s %s %s %s %s\n",
           file(var.OPSC_BootStrap),
           "./lcm_opscenter.sh",
           "${var.DSE_Cluster_Name}",
           "${var.host_user_name}",
           "${var.DataStax_Academy_Creds["username"]}",
           "${var.DataStax_Academy_Creds["password"]}"
        ))}"
    }
}

