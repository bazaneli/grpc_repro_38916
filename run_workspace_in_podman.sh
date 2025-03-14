podman run \
	-it \
	--volume=".:/work:rw" \
	--name repro38916_container \
	repro38916_image:latest \
	/bin/bash -c "
    cd /work && \
    mkdir -p build && \
    cd build && \
    cmake .. && \
    cmake --build . && ./main
  "
