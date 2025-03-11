# Repro grpc/grpc#38916

This repro runs a test in podman / docker.

Building the image: `podman build -t repro38916_image .`

### Building and running the server:

```
podman run \
  -it \
  --volume=".:/work:rw" \
  --name repro38916_container \
  repro38916_image:latest \
  /bin/bash -c "
    cd /work
    bazel build :all && ./bazel-bin/repro_38916_server"
```

### Running the grpcurl client:

```
podman container exec repro38916_container \
  grpcurl \
    -plaintext \
    -import-path /work \
    -proto repro_38916.proto \
    -d '{"masterId": "100", "bugs": [ {"bugId": "1", "bugInfo": "hello"}, { "bugId": "2", "bugInfo": "world" } ] }' \
    localhost:50051 \
    repro38916.BugService/SayHelloBug
```

### Cleanup

```
podman container rm repro38916_container
podman image rm repro38916_image
```