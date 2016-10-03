sudo -c
apt-get install -y zookeeper libzookeeper2 zookeeperd zookeeper-bin libzookeeper-mt-dev ant check build-essential autoconf libtool pkg-config
echo "Install Conservator C++ Zookeeper Wrapper"
mkdir -p ~/src
cd ~/src
git clone https://github.com/rjenkins/conservator.git
cd conservator
cmake .
make 
make install
cd ~/src
echo "Install GRPC"
git clone -b $(curl -L http://grpc.io/release) https://github.com/grpc/grpc
cd grpc
git submodule update --init
make
make install
echo "Install Protobuf"
cd ~/grpc/third_party/protobuf
make 
sudo make install