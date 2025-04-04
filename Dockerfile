FROM ubuntu:latest

LABEL org.opencontainers.image.source=https://github.com/xdslproject/llvm-docker
LABEL org.opencontainers.image.description="LLVM Docker image for xdslproject"
LABEL org.opencontainers.image.licenses=MIT

# Install xz-utils
RUN apt-get update && apt-get install -y \
    wget xz-utils libz3-dev libedit-dev libzstd-dev git make gpg \
    && rm -rf /var/lib/apt/lists/*

# Download and extract the official LLVM 20.1.1 binary
WORKDIR /tmp
RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-20.1.1/LLVM-20.1.1-Linux-X64.tar.xz && \
    tar xf LLVM-20.1.1-Linux-X64.tar.xz -C /usr/local --strip-components=1 && \
    rm LLVM-20.1.1-Linux-X64.tar.xz
WORKDIR /
