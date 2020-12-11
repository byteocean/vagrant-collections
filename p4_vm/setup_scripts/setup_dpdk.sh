#!/bin/bash

# based on script on: https://github.com/lorenzosaino/ubuntu-dpdk

sudo apt-get -qq update
sudo apt-get -y -qq install git clang doxygen hugepages build-essential libnuma-dev libpcap-dev linux-headers-`uname -r`

echo $HOME
export DPDK_VERSION=v19.11
export RTE_SDK=${HOME}/dpdk
export RTE_TARGET=x86_64-native-linuxapp-gcc

# configure huge page
export HUGEPAGE_MOUNT=/mnt/huge
echo 1024 | sudo tee /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages
sudo mkdir ${HUGEPAGE_MOUNT}
sudo mount -t hugetlbfs nodev ${HUGEPAGE_MOUNT}
echo "hugetlbfs ${HUGEPAGE_MOUNT} hugetlbfs rw,mode=0777 0 0" | sudo tee -a /etc/fstab

if [ -x "${RTE_SDK}/usertools/dpdk-devbind.py" ]; then  
    echo "DPDK has been installed"; 
else 
    # configure and compile dpdk
    git clone http://dpdk.org/git/dpdk ${RTE_SDK}
    cd ${RTE_SDK}
    git checkout "${DPDK_VERSION:-master}"
    make config T=${RTE_TARGET}
    sed -ri 's,(PMD_PCAP=).*,\1y,' build/.config
    make -j4
fi
# use user space io as linux module

sudo modprobe uio

if lsmod | grep "igb_uio" &> /dev/null; then
    echo "igb_uio has been loaded"
else
    sudo insmod ${RTE_SDK}/build/kmod/igb_uio.ko
    sudo ln -sf ${RTE_SDK}/build/kmod/igb_uio.ko /lib/modules/`uname -r`
    sudo depmod -a
    echo "uio" | sudo tee -a /etc/modules
fi

# configure interface
#sudo ifconfig eth2 down
#sudo ${RTE_SDK}/usertools/dpdk-devbind.py --bind=igb_uio eth2

#source /home/vagrant/install/config_dpdk_interface.sh

echo "export RTE_SDK=${RTE_SDK}" >> ${HOME}/.profile
echo "export RTE_TARGET=${RTE_TARGET}" >> ${HOME}/.profile
#ln -sf ${RTE_SDK}/build ${RTE_SDK}/${RTE_TARGET}

