#!/usr/bin/env bash

numprocs=$(cat /proc/cpuinfo | grep processor | wc -l)

sudo apt-get update
sudo apt-get install -y g++ zookeeper libzookeeper-mt2 zookeeperd zookeeper-bin libzookeeper-mt-dev ant check build-essential autoconf libtool pkg-config checkinstall git zlib1g cmake
echo "PATH=/usr/local/bin:$PATH" >> ~/.profile
source ~/.profile
echo "Installing Conservator C++ Zookeeper Wrapper"
mkdir -p ~/src
cd ~/src
git clone https://github.gatech.edu/cs8803-SIC/conservator.git
cd conservator
cmake .
make -j${numprocs}
sudo checkinstall -y --pkgname conservator
cd ~/src
echo "Installing GRPC"
git clone -b v1.35.0 https://github.com/grpc/grpc
cd grpc
git submodule update --init
mkdir -p cmake/build
cd cmake/build
cmake ../..
make -j${numprocs}
sudo checkinstall -y --pkgname grpc
sudo ldconfig
echo "Installing GLog"
cd ~/src/
git clone https://github.com/google/glog.git
cd glog
cmake -H. -Bbuild -G "Unix Makefiles"
cmake --build build
cmake --build build --target test
sudo cmake --build build --target install
echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
source ~/.bashrc
