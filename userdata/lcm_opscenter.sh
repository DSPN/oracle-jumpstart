#!/bin/bash

# Collect input param
cluster_name=$1
cluster_size=$2
num_dcs=$3
host_user_name=$4
dsa_username=$5
dsa_password=$6
cassandra_user_pwd=$7
opc_passwd="datastax1!"

# In lcm_opscenter.sh
echo cluster_name = $cluster_name

##### Turn off the firewall
service firewalld stop
chkconfig firewalld off


##### Enable 'opc' user to ssh with a password
echo $opc_passwd | sudo passwd --stdin opc

file="/etc/ssh/sshd_config"
passwd_auth="yes"
cat $file \
| sed -e "s:\(PasswordAuthentication\).*:PasswordAuthentication $passwd_auth:" \
> $file.new
mv $file.new $file

service sshd restart


##### Install required OS packages
yum -y update
yum -y install unzip wget
#wget http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
wget http://mirror.centos.org/centos/7/extras/x86_64/Packages/epel-release-7-9.noarch.rpm
rpm -ivh epel-release-7-9.noarch.rpm
yum -y install python-pip
pip install requests


##### Install OpsCenter
cd ~opc
release="6.0.4"
wget https://github.com/DSPN/install-datastax-redhat/archive/$release.zip
unzip $release.zip
cd install-datastax-redhat-$release/bin/
./os/install_java.sh
./opscenter/install.sh
./opscenter/configure_opscenterd_conf.sh
./opscenter/start.sh


##### Configure DataStax Studio
pushd ~opc/DSE_Graph

node_ip=`echo $(hostname -I)`

file=datastax-studio-2.0.0/conf/configuration.yaml
date=$(date +%F)
backup="$file.$date"

cp $file $backup

cat $file \
| sed -e "s:.*\(httpBindAddress\:\).*: httpBindAddress\: $node_ip:" \
> $file.new

mv $file.new $file

chown opc:opc $file

sudo service datastax-studio restart

popd


##### Set up cluster in OpsCenter the LCM way
cd ~opc
release="6.0.4"
wget https://github.com/DSPN/install-datastax-ubuntu/archive/$release.zip -O lcm-$release.zip
unzip lcm-$release.zip
cd install-datastax-ubuntu-$release/bin/lcm/

# Retrieve OpsCenter's public IP address
private_ip=`echo $(hostname -I)`

# Retrieve bmc_rsa private key from a S3 bucket3 for LCM-based provisioning
curl https://s3.us-east-2.amazonaws.com/oci-dse/bmc_rsa > ~opc/.ssh/bmc_rsa
chown opc:opc ~opc/.ssh/bmc_rsa
chmod 600 ~opc/.ssh/bmc_rsa
privkey=$(readlink -f ~opc/.ssh/bmc_rsa)
sleep 1m

./setupCluster.py \
--opsc-ip $private_ip \
--pause 60 \
--trys 40 \
--clustername $cluster_name \
--privkey $privkey \
--datapath /mnt/data1 \
--user $host_user_name \
--repouser $dsa_username \
--repopw $dsa_password

./triggerInstall.py \
--opsc-ip $private_ip \
--clustername $cluster_name \
--clustersize $cluster_size \
--dbpasswd $cassandra_user_pwd \
--dclevel

./waitForJobs.py \
--num $num_dcs \
--opsc-ip $private_ip 
      
# Alter required keyspaces for multi-DC
./alterKeyspaces.py

