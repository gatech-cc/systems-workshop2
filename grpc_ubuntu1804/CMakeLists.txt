cmake_minimum_required(VERSION 3.2)
project(grpc_helloworld)

find_package(Protobuf REQUIRED)

find_package(Protobuf CONFIG REQUIRED)
message(STATUS "Using protobuf ${Protobuf_VERSION}")

set(_PROTOBUF_LIBPROTOBUF protobuf::libprotobuf)
set(_REFLECTION gRPC::grpc++_reflection)
set(_PROTOBUF_PROTOC $<TARGET_FILE:protobuf::protoc>)

# Find gRPC installation
# Looks for gRPCConfig.cmake file installed by gRPC's cmake installation.
find_package(gRPC CONFIG REQUIRED)
message(STATUS "Using gRPC ${gRPC_VERSION}")

set(_GRPC_GRPCPP gRPC::grpc++)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
set(_GRPC_CPP_PLUGIN_EXECUTABLE $<TARGET_FILE:gRPC::grpc_cpp_plugin>)

include_directories(/usr/local/include)
link_directories(/usr/local/lib)

set(PROTO_PATH "${CMAKE_SOURCE_DIR}")
set(HELLOWORLD_PROTO "${CMAKE_SOURCE_DIR}/hello.proto")
set(GENERATED_PROTOBUF_PATH "${CMAKE_BINARY_DIR}/generated")
file(MAKE_DIRECTORY ${GENERATED_PROTOBUF_PATH})

set(HELLOWORLD_PB_CPP_FILE "${GENERATED_PROTOBUF_PATH}/hello.pb.cc")
set(HELLOWORLD_PB_H_FILE "${GENERATED_PROTOBUF_PATH}/hello.pb.h")
set(HELLOWORLD_GRPC_PB_CPP_FILE "${GENERATED_PROTOBUF_PATH}/hello.grpc.pb.cc")
set(HELLOWORLD_GRPC_PB_H_FILE "${GENERATED_PROTOBUF_PATH}/hello.grpc.pb.h")
add_custom_command(
    OUTPUT "${HELLOWORLD_PB_H_FILE}"
           "${HELLOWORLD_PB_CPP_FILE}"
           "${HELLOWORLD_GRPC_PB_H_FILE}"
           "${HELLOWORLD_GRPC_PB_CPP_FILE}"
    COMMAND ${PROTOBUF_PROTOC_EXECUTABLE}
    ARGS "--proto_path=${PROTO_PATH}"
         "--cpp_out=${GENERATED_PROTOBUF_PATH}"
         "${HELLOWORLD_PROTO}"
    COMMAND ${PROTOBUF_PROTOC_EXECUTABLE}
    ARGS "--proto_path=${PROTO_PATH}"
         "--grpc_out=${GENERATED_PROTOBUF_PATH}"
         "--plugin=protoc-gen-grpc=/usr/local/bin/grpc_cpp_plugin"
         "${HELLOWORLD_PROTO}"
    )

add_library(hw_grpc_proto ${HELLOWORLD_PB_H_FILE} ${HELLOWORLD_PB_CPP_FILE} ${HELLOWORLD_GRPC_PB_H_FILE} ${HELLOWORLD_GRPC_PB_CPP_FILE})
target_link_libraries(hw_grpc_proto ${_REFLECTION} ${_GRPC_GRPCPP} ${_PROTOBUF_LIBPROTOBUF})


set(GENERATED_PROTOBUF_FILES ${HELLOWORLD_PB_H_FILE} ${HELLOWORLD_PB_CPP_FILE}
    ${HELLOWORLD_GRPC_PB_H_FILE} ${HELLOWORLD_GRPC_PB_CPP_FILE})

include_directories(${GENERATED_PROTOBUF_PATH})
link_libraries(grpc++_unsecure grpc gpr ${PROTOBUF_LIBRARY})

add_executable(greeter_server greeter_server.cc )
target_link_libraries(greeter_server hw_grpc_proto ${_REFLECTION} ${_GRPC_GRPCPP} ${_PROTOBUF_LIBPROTOBUF})
add_executable(greeter_client greeter_client.cc )
target_link_libraries(greeter_client hw_grpc_proto ${_REFLECTION} ${_GRPC_GRPCPP} ${_PROTOBUF_LIBPROTOBUF})
#add_executable(greeter_async_server src/greeter_async_server.cc ${GENERATED_PROTOBUF_FILES})
#add_executable(greeter_async_client src/greeter_async_client.cc ${GENERATED_PROTOBUF_FILES})
