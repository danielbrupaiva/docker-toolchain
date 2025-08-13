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
    pkg-config build-essential ninja-build cmake make gcc autoconf libtool automake m4 gawk texinfo bison file git wget curl rsync symlinks python3 python-is-python3 xz-utils \
    xutils-dev p7zip-full symlinks openssh-client net-tools iputils-ping nodejs
# Install project dependencies
RUN apt install -y --no-install-recommends libsqlite3-dev libgl1-mesa-dev libegl1-mesa libegl1 libgl1-mesa-glx libglx-mesa0 libgles2-mesa-dev libxkbcommon-dev libwayland-dev \
                   libxrandr-dev libxinerama-dev libxcursor-dev libxi-dev tcl-dev     
# QT dependencies
RUN apt install -y --no-install-recommends make cmake build-essential libclang-dev clang ninja-build gcc git bison python3 gperf pkg-config libfontconfig1-dev libfreetype6-dev \
                libx11-dev libx11-xcb-dev libxext-dev libxfixes-dev libxi-dev libxrender-dev libxcb1-dev libxcb-glx0-dev libxcb-keysyms1-dev libxcb-image0-dev \
                libxcb-shm0-dev libxcb-icccm4-dev libxcb-sync-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-randr0-dev libxcb-render-util0-dev libxcb-util-dev \
                libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev libatspi2.0-dev libgl1-mesa-dev libglu1-mesa-dev freeglut3-dev llvm-14-dev
# Install Official AARCH64 toolchain
RUN apt install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu
# Clean-up
RUN apt clean && apt autoremove -y 
# Create a non-root user named 'dev' with home directory
RUN useradd -m -s /bin/bash dev \
    && echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# Optionally set a password (not recommended for production)
# RUN echo "dev:devpassword" | chpasswd

# RPI4 SYSROOT
# Switch to the root user
USER root
# Set the default working directory
WORKDIR /opt/sysroots 
COPY /sysroots/rpi4.tar.xz /opt/sysroots/
# Extract RPI4 sysroot
RUN tar -xvf rpi4.tar.xz && \
    rm rpi4.tar.xz
# BeaglePlay
COPY /sysroots/beagleplay.tar.xz /opt/sysroots/
# Extract BeaglePlay sysroot
RUN tar -xvf beagleplay.tar.xz && \
    rm beagleplay.tar.xz
# Switch to the root user
USER dev
# Set the default working directory
WORKDIR /home/dev/workspace 
# Default command to start a Bash shell
#ENTRYPOINT ["tail", "-f", "/dev/null"]