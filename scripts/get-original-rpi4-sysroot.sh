#!/bin/bash
set -e

# Variables
SYSROOTS_FOLDER="/opt/sysroots"
IMG_NAME="2025-05-13-raspios-bookworm-arm64"
IMG_URL="https://downloads.raspberrypi.com/raspios_arm64/images/raspios_arm64-2025-05-13/$IMG_NAME.img.xz"
IMG_XZ="$IMG_NAME.img.xz"
IMG="$IMG_NAME.img"
SYSROOT_BASE="$SYSROOTS_FOLDER/$IMG_NAME"
TMP_DIR="$HOME/tmp"

if [ ! -d $SYSROOTS_FOLDER ]; then
    mkdir -p $SYSROOTS_FOLDER
fi

if [ ! -d $TMP_DIR ]; then
    mkdir -p $TMP_DIR
fi

cd $TMP_DIR
# Download image
wget $IMG_URL

# Extract image
unxz $TMP_DIR/$IMG_XZ

# Extract partitions from image
7z x $TMP_DIR/$IMG -o$TMP_DIR/$IMG_NAME/

# Extract root filesystem from partition (usually 1.img)
7z x "$TMP_DIR/$IMG_NAME/1.img" -o$TMP_DIR/$IMG_NAME/


if [ ! -d $SYSROOTS_FOLDER ]; then
    sudo mkdir -p $SYSROOTS_FOLDER
fi

if [ ! -d $SYSROOT_BASE ]; then
    sudo mkdir -p $SYSROOT_BASE
fi

# Move the extracted sysroot to the correct location
sudo cp -R "$TMP_DIR/$IMG_NAME//usr/" "$SYSROOT_BASE/"
sudo cp -R "$TMP_DIR/$IMG_NAME//opt/" "$SYSROOT_BASE/"
sudo cp -R "$TMP_DIR/$IMG_NAME//lib/" "$SYSROOT_BASE/"

# Set permissions to 755
sudo chmod -R 755 "$SYSROOT_BASE"

# Clean up the temporary directory and image
rm -rf "$TMP_DIR"

cd $HOME