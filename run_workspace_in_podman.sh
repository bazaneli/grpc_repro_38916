# podman run -it --volume='.:/work:rw' repro38916 /bin/bash -c "cd /work && \
#     bazel build :all && \
#     ./bazel-bin/repro_38916_server& sleep 2 && \
#     grpcurl -plaintext -proto repro_38916.proto -d '{\"masterId\": \"100\", \"bugs\": [ {\"bugId\": \"1\", \"bugInfo\": \"hello\"}, { \"bugId\": \"2\", \"bugInfo\": \"world\" } ] }' localhost:50051 repro38916.BugService/SayHelloBug && \
#     /bin/bash"

podman run -it --volume='.:/work:rw' repro38916 /bin/bash -c "cd /work && \
    bazel build :all && \
    ./bazel-bin/repro_38916_server"