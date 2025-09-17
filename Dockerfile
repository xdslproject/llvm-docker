FROM ubuntu:latest

LABEL org.opencontainers.image.source=https://github.com/xdslproject/llvm-docker
LABEL org.opencontainers.image.description="LLVM Docker image for xdslproject"
LABEL org.opencontainers.image.licenses=MIT

# Install xz-utils
# Install dependencies and LLVM 21.1.1
RUN apt-get update && apt-get install -y \
    wget xz-utils libz3-dev libedit-dev libzstd-dev git make gpg lsb-release software-properties-common \
    && wget https://apt.llvm.org/llvm.sh \
    && chmod +x llvm.sh \
    && ./llvm.sh 21 all \
    && apt-get install -y libmlir-21-dev mlir-21-tools \
    && ln -sf /usr/bin/mlir-opt-21 /usr/bin/mlir-opt \
    && ln -sf /usr/bin/mlir-translate-21 /usr/bin/mlir-translate \
    && ln -sf /usr/bin/mlir-tblgen-21 /usr/bin/mlir-tblgen \
    && ln -sf /usr/bin/mlir-linalg-ods-gen-21 /usr/bin/mlir-linalg-ods-gen \
    && ln -sf /usr/bin/mlir-pdll-21 /usr/bin/mlir-pdll \
    && ln -sf /usr/bin/mlir-runner-21 /usr/bin/mlir-runner \
    && rm llvm.sh \
    && rm -rf /var/lib/apt/lists/*

# Verify that the installed LLVM version is 21.1.1
RUN llvm-config-21 --version | grep -q "^21\.1\.1" || (echo "Error: LLVM 21.1.1 not installed!" && exit 1)
