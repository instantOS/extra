#!/bin/bash
set -e

# This script runs INSIDE the container

# Install dependencies
pacman -Syu --noconfirm --needed base-devel git sudo

# Create a builder user
useradd -m builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set permissions for the working directory
# We assume the package source is mounted at /pkg
chown -R builder:builder /pkg

# Switch to builder user and build
cd /pkg
sudo -u builder makepkg -si --noconfirm

# Move built packages to the repo mount
# We assume the repo is mounted at /repo
mv *.pkg.tar.zst /repo/
