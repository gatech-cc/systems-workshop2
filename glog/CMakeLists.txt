cmake_minimum_required (VERSION 3.0)
project (glog_test)

find_package (glog REQUIRED)

add_executable (glog.o glog.cpp)
target_link_libraries (glog.o glog::glog)
