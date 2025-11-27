#!/bin/bash
set -e

# Install dependencies
pacman -Syu --noconfirm --needed base-devel git sudo

# Create a builder user since makepkg cannot run as root
useradd -m builder
echo "builder ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Create repo directory
mkdir -p repo
chown builder:builder repo

# Function to build a package
build_package() {
    local pkg_dir=$1
    echo "Building package in $pkg_dir"
    
    cd "$pkg_dir"
    
    # Check if PKGBUILD exists
    if [ ! -f PKGBUILD ]; then
        echo "No PKGBUILD found in $pkg_dir, skipping..."
        return
    fi

    # Install dependencies and build
    # We use sudo -u builder to run makepkg as the builder user
    chown -R builder:builder .
    sudo -u builder makepkg -si --noconfirm
    
    # Move built packages to repo
    mv *.pkg.tar.zst ../repo/
    
    cd ..
}

# Build local packages
echo "Building local packages..."
for d in */; do
    if [ "$d" == "repo/" ]; then continue; fi
    # Remove trailing slash
    dirname=${d%/}
    
    # Skip hidden directories and files
    if [[ $dirname == .* ]]; then continue; fi
    
    if [ -f "$dirname/PKGBUILD" ]; then
        build_package "$dirname"
    fi
done

# Build AUR packages
echo "Building AUR packages..."
if [ -f aurpackages ]; then
    mkdir -p aur_temp
    cd aur_temp
    
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Skip empty lines and comments
        if [[ -z "$line" ]] || [[ "$line" == \#* ]]; then continue; fi
        
        # Handle package_name:output_name format (take the part before colon)
        pkgname=$(echo "$line" | cut -d':' -f1)
        
        echo "Fetching AUR package: $pkgname"
        git clone "https://aur.archlinux.org/$pkgname.git"
        
        if [ -d "$pkgname" ]; then
            build_package "$pkgname"
        else
            echo "Failed to clone $pkgname"
        fi
        
    done < ../aurpackages
    cd ..
    rm -rf aur_temp
fi

# Generate repository database
echo "Generating repository database..."
cd repo
repo-add instant.db.tar.gz *.pkg.tar.zst

echo "Build complete!"
