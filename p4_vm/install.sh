#!/bin/bash

#source install_deps.sh

sudo apt update
sudo apt install htop

#source /home/vagrant/install/setup_dpdk.sh
source /home/vagrant/install/setup_p4_bmv2.sh
source /home/vagrant/install/setup_p4c.sh


