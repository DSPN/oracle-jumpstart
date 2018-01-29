#!/bin/bash

cd ~opc

release="1.4"
curl https://raw.githubusercontent.com/DSPN/oracle-jumpstart/$release/userdata/lcm_opscenter.sh > lcm_opscenter.sh

chmod +x lcm_opscenter.sh

