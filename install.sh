#!/usr/bin/env bash
sudo apt-get update
sudo apt-get install -y zookeeper libzookeeper2 zookeeperd zookeeper-bin libzookeeper-mt-dev ant check build-essential autoconf libtool pkg-config checkinstall git
echo "Instaling cmake 3.0+"
mkdir -p ~/src
cd ~/src
sudo apt-get remove -y cmake
wget http://www.cmake.org/files/v3.2/cmake-3.2.2.tar.gz
tar xf cmake-3.2.2.tar.gz
cd cmake-3.2.2
./configure
make
sudo checkinstall -y --pkgname cmake
echo "PATH=/usr/local/bin:$PATH" >> ~/.profile
source ~/.profile
echo "Installing Conservator C++ Zookeeper Wrapper"
cd ~/src
git clone https://github.com/esaurez/conservator.git
cd conservator
cmake .
make 
sudo checkinstall -y --pkgname conservator
cd ~/src
echo "Installing GRPC"
git clone -b $(curl -L http://grpc.io/release) https://github.com/grpc/grpc
cd grpc
git submodule update --init
make
sudo checkinstall grpc
echo "Installing Protobuf"
cd ~/src/grpc/third_party/protobuf
make 
sudo checkinstall -y --pkgname protobuf
echo "Installing GLoc"
cd ~/src/
git clone https://github.com/google/glog.git
cd glog
mkdir build && cd build
export CXXFLAGS="-fPIC" 
cmake ..
make
make test
sudo checkinstall -y --pkgname glog
echo "export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH" >> ~/.bashrc
source ~/.bashrc
