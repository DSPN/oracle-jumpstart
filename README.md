# DataStax Enterprise (DSE) Demo Lab for Oracle Cloud Infrastructure (OCI) Jump Start Program
Terraform-based provisioning for DataStax Enterprise (DSE) JumpStart Demo Lab on OCI

This asset creates a virtual cloud network with a route table, Internet Gateway, Security Lists, 3 subnets on different availability domains (ADs) for the DSE cluster nodes (as OCI virtual machines) using NVMe SSDs as data disks and DataStax Enterprise OpsCenter. Additionally, a standalone virtual machine is hosting a DataStax Enterprise OpsCenter instance to manage the DSE cluster. In the same VM there is a DataStax Enterprise Studio with two interactive tutorial notebooks.

### Disclaimer
The use of this repo is to store DataStax Enterprise Demo Lab artifacts for OCI Jump Start Program.

## For local testing only
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

### Using this project
* Run `% git clone https://github.com/DSPN/oracle-jumpstart.git` to clone the repo.
* Run `% cd oracle-jumpstart` to change to the repo directory.
* Update env-vars file with the required information.
  * From your OCI account
    * TF_VAR_tenancy_ocid
    * TF_VAR_user_ocid
    * TF_VAR_fingerprint
    * TF_VAR_private_key_path
    * TF_VAR_region
  * From your local file system
    * TF_VAR_ssh_public_key
    * TF_VAR_ssh_private_key

* Source env-vars for appropriate environment
  * `% . env-vars`
* Update `variables.tf` with your instance options if you need to change the default settings.
* Run `% terraform plan` and follow on-screen instructions to create and review your execution plan.
* If everything looks good, run `% terraform apply` and follow on-screen instructions to provision your DSE cluster. *Currently the install will automatically create nodes in 3 Availability Domains (AD). The number you would like in each AD is specified by the Num_DSE_Nodes_In_Each_AD variable inside the variables.tf file*.
* If it runs successfully, you will see the following output from the command line.
![](./img/terraform_apply.png)
* The time taken to provision a 3-node DSE cluster is roughly 18 minutes long. Once complete, you can point your browser at http://<OpsCenter_URL> to access DataStax Enterprise OpsCenter to start managing your DSE cluster.
![](./img/opsc_dashboard.png)
* You can also SSH into the any of the DSE nodes using this command: `% ssh -i <path to your SSH private key> opc@<IP address of a DSE node>`.  You can locate the IP address of your DSE node in OCI Console's Compute>>Instances>>Instance Details screen.
![](./img/dse_ip.png)
* Similarly, you can cqlsh into your DSE nodes using `% cqlsh <IP address of a DSE node> -u cassandra -p <Cassandra_DB_User_Password>`.
* When you no longer need the DSE cluster, you can run `% terraform destroy` and follow on-screen instructions to de-provision your DSE cluster.

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
