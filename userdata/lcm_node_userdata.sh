#!/usr/bin/env bash

cd ~opc

release="1.4"
curl https://raw.githubusercontent.com/DSPN/oracle-jumpstart/$release/userdata/lcm_node.sh > lcm_node.sh

chmod +x lcm_node.sh

