#!/bin/bash

if [ -x "/usr/local/bin/p4c" ]; then
    echo "p4 compiler has been installed"
else

    # install dependences
    sudo apt update
    sudo apt -y install cmake g++ git automake libtool libgc-dev bison flex libfl-dev libgmp-dev libboost-dev libboost-iostreams-dev libboost-graph-dev llvm pkg-config python python-scapy python-ipaddr python-ply python3-pip tcpdump autoconf curl unzip
    
    pip3 install scapy ply

    # install protobuf 3.6.1
    git clone https://github.com/protocolbuffers/protobuf.git
    cd protobuf
    git checkout v3.6.1
    git submodule update --init --recursive
    ./autogen.sh
    ./configure
    make -j4
    make check -j4
    sudo make install
    sudo ldconfig

    cd ..
    # install p4c
    git clone --recursive https://github.com/p4lang/p4c.git
    cd p4c/
    mkdir build
    cd build/
    cmake ..
    make -j2
    make check -j2
    sudo make install
fi