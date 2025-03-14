# Repro grpc/grpc#38916

This repro runs a test in podman / docker.

Building the image: `podman build -t repro38916_image .`

### Building and running the server:

```
./run_workspace_in_podman.sh
```

### Running the grpcurl client:

```
run_grpcurl_in_podman.sh
```

### Cleanup

```
podman container rm repro38916_container
podman image rm repro38916_image
```
