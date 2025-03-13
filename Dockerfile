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

#=================
# Setup git to access working directory across docker boundary.
# This avoids the "fatal: detected dubious ownership in repository XYZ"
# git error.
# Using "--system" makes the setting work
# for all users or even current user is not properly defined
# (which can happen e.g. inside execution environment
# of a bazel action)

RUN git config --global --add safe.directory '*'
RUN git config --global protocol.file.allow always
RUN git config --system --add safe.directory '*'
RUN git config --system protocol.file.allow always

RUN bazel --version


