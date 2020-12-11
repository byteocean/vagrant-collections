#!/bin/bash


if [ -x "/usr/local/bin/simple_switch" ]; then
    echo "behavioral model of p4 has been cloned and compiled"
else
    git clone https://github.com/p4lang/behavioral-model.git

    cd behavioral-model/

    sudo apt-get update
    export LC_ALL="en_US.UTF-8"
    ./install_deps.sh

    ./autogen.sh
    ./configure
    make -j4
    make check -j4
    sudo make install 
fi


