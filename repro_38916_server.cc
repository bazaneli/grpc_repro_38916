// Copyright 2025 the gRPC authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <grpc/grpc.h>
#include <grpcpp/ext/proto_server_reflection_plugin.h>
#include <grpcpp/grpcpp.h>

#include "absl/log/log.h"

#include "repro_38916.grpc.pb.h"

namespace absl
{
ABSL_NAMESPACE_BEGIN
namespace log_internal
{
template LogMessage& LogMessage::operator<<(const char& v);
template LogMessage& LogMessage::operator<<(const signed char& v);
template LogMessage& LogMessage::operator<<(const unsigned char& v);
template LogMessage& LogMessage::operator<<(const short& v);           // NOLINT
template LogMessage& LogMessage::operator<<(const unsigned short& v);  // NOLINT
template LogMessage& LogMessage::operator<<(const int& v);
template LogMessage& LogMessage::operator<<(const unsigned int& v);
template LogMessage& LogMessage::operator<<(const long& v);                // NOLINT
template LogMessage& LogMessage::operator<<(const unsigned long& v);       // NOLINT
template LogMessage& LogMessage::operator<<(const long long& v);           // NOLINT
template LogMessage& LogMessage::operator<<(const unsigned long long& v);  // NOLINT
template LogMessage& LogMessage::operator<<(void* const& v);
template LogMessage& LogMessage::operator<<(const void* const& v);
template LogMessage& LogMessage::operator<<(const float& v);
template LogMessage& LogMessage::operator<<(const double& v);
template LogMessage& LogMessage::operator<<(const bool& v);
}  // namespace log_internal
ABSL_NAMESPACE_END
}  // namespace absl

class BugServiceImpl final : public repro38916::BugService::CallbackService {
public:
  grpc::ServerUnaryReactor *
  SayHelloBug(grpc::CallbackServerContext *context,
              const repro38916::BugRequest *request,
              repro38916::BugResponse *response) override {
    LOG(INFO) << "Method has been called";
    auto *reactor = context->DefaultReactor();
    reactor->Finish(grpc::Status::OK);
    return reactor;
  }
};

int main(int argc, const char **argv) {
  std::string server_address("0.0.0.0:50051");
  BugServiceImpl service;
  grpc::reflection::InitProtoReflectionServerBuilderPlugin();
  grpc::ServerBuilder builder;
  builder.AddListeningPort(server_address, grpc::InsecureServerCredentials());
  builder.RegisterService(&service);
  std::unique_ptr<grpc::Server> server(builder.BuildAndStart());
  LOG(INFO) << "Server listening on " << server_address;
  server->Wait();
  return 0;
}
