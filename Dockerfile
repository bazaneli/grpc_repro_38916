FROM archlinux:latest

# Update system and install basic packages
RUN pacman -Syu --noconfirm && \
    pacman -S --noconfirm \
    base-devel \
    curl \
    libtool \
    make \
    vim \
    wget \
    gdb \
    gcc \
    clang \
    git \
    cmake \
    unzip \
    python \
    go \
    sudo

ENV USE_BAZEL_VERSION 8.0.1
ENV DISABLE_BAZEL_WRAPPER 1

ADD --chmod=777 https://github.com/bazelbuild/bazelisk/releases/download/v1.25.0/bazelisk-linux-amd64 /usr/local/bin/bazel

RUN git config --global --add safe.directory '*'
RUN git config --global protocol.file.allow always
RUN git config --system --add safe.directory '*'
RUN git config --system protocol.file.allow always

RUN bazel --version

# Create /root/libs and build grpc
RUN mkdir -p /root/libInstall && \
    cd /root/libInstall && \
    git clone --recurse-submodules -b v1.71.0 --depth 1 --shallow-submodules https://github.com/grpc/grpc
    
RUN cd /root/libInstall/grpc && \
    mkdir -p cmake/build && \
    cd cmake/build && \
    cmake -DgRPC_INSTALL=ON \
          -DgRPC_BUILD_TESTS=OFF \
          -DCMAKE_CXX_STANDARD=17 \
          -DCMAKE_INSTALL_PREFIX=/root/libs/grpc \
          ../..           
          
RUN cd /root/libInstall/grpc/cmake/build && \ 
	make -j 16 && \
    make install

# Download and install grpcurl
RUN cd /root && \
    wget https://github.com/fullstorydev/grpcurl/releases/download/v1.9.3/grpcurl_1.9.3_linux_x86_64.tar.gz && \
    tar -xzf grpcurl_1.9.3_linux_x86_64.tar.gz --no-same-owner && \
    mv grpcurl /usr/local/bin && \
    rm grpcurl_1.9.3_linux_x86_64.tar.gz
