FROM ubuntu:22.04

# Install required packages
RUN apt update && apt install -y build-essential git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Clone and build Entware
RUN git clone --depth 1 https://github.com/Entware/Entware.git /opt/entware \
    && cd /opt/entware \
    && make package/symlinks \
    && make -j$(nproc) toolchain/install

# Set working directory
WORKDIR /opt/entware

# Default command
CMD ["/bin/bash"]