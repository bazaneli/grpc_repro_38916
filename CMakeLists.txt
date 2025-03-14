cmake_minimum_required(VERSION 3.31)
project(HelloBug)

set(CMAKE_CXX_COMPILER "/usr/bin/clang++")
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)


#adding grpc
set(CMAKE_PREFIX_PATH "/root/libs/grpc")

find_package(Protobuf CONFIG REQUIRED)
find_package(gRPC CONFIG REQUIRED)

add_library(protolib repro_38916.proto)
target_link_libraries(protolib gRPC::grpc++ gRPC::grpc++_reflection)

target_include_directories(protolib PUBLIC ${CMAKE_CURRENT_BINARY_DIR})
get_target_property(grpc_cpp_plugin_location gRPC::grpc_cpp_plugin LOCATION)

protobuf_generate(TARGET protolib LANGUAGE cpp)
protobuf_generate(TARGET protolib LANGUAGE grpc GENERATE_EXTENSIONS .grpc.pb.h
                  .grpc.pb.cc PLUGIN
                  "protoc-gen-grpc=${grpc_cpp_plugin_location}")

add_executable(main repro_38916_server.cc)

target_link_libraries(main PRIVATE
  protolib
)


