#!/usr/bin/env bash

numprocs=$(cat /proc/cpuinfo | grep processor | wc -l)

sudo apt-get update
sudo apt-get install -y g++ zookeeper libzookeeper-mt2 zookeeperd zookeeper-bin libzookeeper-mt-dev ant check build-essential autoconf libtool pkg-config checkinstall git zlib1g libssl-dev
sudo dpkg -r conservator
echo "Reinstalling Conservator C++ Zookeeper Wrapper"
mkdir -p ~/src
cd ~/src
git clone https://github.gatech.edu/cs8803-SIC/conservator.git
cd conservator
cmake .
make -j${numprocs}
make test
sudo checkinstall -y --pkgname conservator
sudo ldconfig
