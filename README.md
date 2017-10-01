# DataStax Enterprise (DSE) Demo Lab for Oracle Cloud Infrastructure (OCI) Jump Start Program
Terraform-based provisioning for DataStax Enterprise (DSE) JumpStart Demo Lab on OCI

This asset creates a virtual cloud network with a route table, Internet Gateway, Security Lists, 3 subnets on different availability domains (ADs) for the DSE cluster nodes (as OCI virtual machines) using NVMe SSDs as data disks and DataStax Enterprise OpsCenter. Additionally, a standalone virtual machine is hosting a DataStax Enterprise OpsCenter instance to manage the DSE cluster. In the same VM there is a DataStax Enterprise Studio with two interactive tutorial notebooks.

### Disclaimer
The use of this repo is to store DataStax Enterprise Demo Lab artifacts for OCI Jump Start Program.

### Prerequisites
* [Follow this link to install Terraform and OCI Terraform provider (v2.0.0)](https://github.com/oracle/terraform-provider-oci/blob/master/README.md)
* [Follow this link to set up your OCI's fingerprint for OCI APIs access](https://docs.us-phoenix-1.oraclecloud.com/Content/API/Concepts/apisigningkey.htm)
* [Follow this link to set up SSH key pair for your OCI BM or VM instances](https://docs.us-phoenix-1.oraclecloud.com/Content/GSG/Tasks/creatingkeys.htm)

&nbsp;&nbsp;&nbsp;After following these links you should have completed these tasks:
* Installed the `terraform` binary for your OS.
* Installed the `terraform-provider-oci` release ([version v2.0.0](https://github.com/oracle/terraform-provider-oci/releases/tag/v2.0.0)) and created the ~/.terraformrc file that specifies the path to the OCI provider.
* Created an Oracle OCI API Signing Key Pair under ~/.oraclebmc directory.
* Uploaded the public key from the above pair to OCI to generate the key's fingerprint.
* Created an SSH key pair to be used instead of a password to authenticate a remote user under your ~/.ssh directory.

### Files in the configuration

#### `env-vars`
This is used to export the environmental variables for the configuration. These are usually authentication related, be sure to exclude this file from your version control system. It's typical to keep this file outside of the configuration.  This file is not being used inside OCI Jump Start execution environments.

Before you run "terraform plan", "terraform apply", or "terraform destroy", source the configuration file as follows:  
`$ . env-vars`

#### `compute.tf`
Defines the compute resource

#### `network.tf`
Defines the network resource

#### `./userdata/*`
The user-data scripts that get injected into an instance on launch. More information on user-data scripts can be [found at the cloud-init project.](https://cloudinit.readthedocs.io/en/latest/topics/format.html)

#### `variables.tf`
Defines the variables used in the configuration.  The region variable's value is currently hard-wired to "us-ashburn-1" region as requested by Oracle.

#### `datasources.tf`
Defines the datasources used in the configuration

#### `outputs.tf`
Defines the outputs of the configuration

#### `provider.tf`
Specifies and passes authentication details to the OCI TF provider

#### `local-exec.tf`
Specifies the time delay in seconds required for DataStax Enterprise Jump Start software installation and configuration.
