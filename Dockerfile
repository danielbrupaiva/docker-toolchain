# Use the Ubuntu 22.04 base image
FROM ubuntu:22.04
# Set environment variables to prevent interaction during installation
ENV DEBIAN_FRONTEND=noninteractive
# Set default shell during Docker image build to bash
SHELL ["/bin/bash", "-c"]
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
# Update and install toolchain dependencies
RUN apt update && \
    apt install -y --no-install-recommends sudo ca-certificates \
    pkg-config build-essential ninja-build cmake make gcc autoconf libtool automake m4 gawk texinfo bison \
    file git wget curl rsync symlinks python3 python-is-python3 xz-utils xutils-dev p7zip-full symlinks \
    openssh-client net-tools iputils-ping nodejs gdb gdb-multiarch openocd
# Install Official ARM 32-bit toolchain for Linux targets
RUN apt install -y gcc-arm-linux-gnueabi g++-arm-linux-gnueabi
# Install Official AARCH64 toolchain
RUN apt install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
# Clean-up
RUN apt clean
RUN apt autoremove -y
RUN rm -rf /var/lib/apt/lists/* 
# Create a non-root user named 'dev' with home directory
RUN useradd -m -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# Optionally set a password (not recommended for production)
# RUN echo "dev:devpassword" | chpasswd
# Switch to the root user
USER dev
# Set the default working directory
WORKDIR /home/dev/workspace 