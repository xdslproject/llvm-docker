FROM ubuntu:latest AS builder

# Install xz-utils
RUN apt-get update && apt-get install -y \
    wget xz-utils \
    && rm -rf /var/lib/apt/lists/*

# Download and extract the official LLVM 19.1.7 binary
WORKDIR /tmp
RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.7/LLVM-19.1.7-Linux-X64.tar.xz && \
    tar xf LLVM-19.1.7-Linux-X64.tar.xz -C /usr/local --strip-components=1 && \
    rm LLVM-19.1.7-Linux-X64.tar.xz

# Create a smaller final image
FROM ubuntu:22.04

# Install only the minimal runtime dependencies
RUN apt-get update && apt-get install -y \
    libz3-dev libedit-dev libzstd-dev git \
    && rm -rf /var/lib/apt/lists/*

# Create directory structure
RUN mkdir -p /usr/local/bin /usr/local/lib

# Copy only the needed tools and their required libraries
COPY --from=builder /usr/local/bin/mlir-opt /usr/local/bin/
COPY --from=builder /usr/local/bin/mlir-translate /usr/local/bin/
COPY --from=builder /usr/local/bin/clang /usr/local/bin/
COPY --from=builder /usr/local/bin/llc /usr/local/bin/

# Copy required shared libraries
COPY --from=builder /usr/local/lib/*.so* /usr/local/lib/

LABEL org.opencontainers.image.source=https://github.com/xdslproject/llvm-docker
LABEL org.opencontainers.image.description="LLVM Docker image for xdslproject"
LABEL org.opencontainers.image.licenses=MIT
