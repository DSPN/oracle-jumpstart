#!/usr/bin/env bash

cd ~opc

curl https://raw.githubusercontent.com/DSPN/oracle-bmc-terraform-dse/master/jump-start/userdata/lcm_node.sh > lcm_node.sh

chmod +x lcm_node.sh

