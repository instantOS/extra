#!/bin/bash
set -e

# This script runs INSIDE the container

# 1. Configure local repo if it exists
# This allows packages to depend on previously built packages
if [ -f /repo/instant.db.tar.gz ]; then
    echo "Adding local repo to pacman.conf"
    echo "[instant]" >>/etc/pacman.conf
    echo "SigLevel = Optional TrustAll" >>/etc/pacman.conf
    echo "Server = file:///repo" >>/etc/pacman.conf
fi

# Install dependencies
# We sync (-y) to pick up the local repo if added
pacman -Syu --noconfirm --needed base-devel git sudo

# Create a builder user
useradd -m builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >>/etc/sudoers

# Set permissions for the working directory
# We assume the package source is mounted at /pkg
chown -R builder:builder /pkg

# Switch to builder user and build
cd /pkg
sudo -u builder makepkg -s --noconfirm

# Move built packages to the repo mount
# We assume the repo is mounted at /repo
mv *.pkg.tar.zst /repo/

# Update the repository database so subsequent builds can find this package
cd /repo
# We add the just-built packages to the DB
repo-add instant.db.tar.gz *.pkg.tar.zst
