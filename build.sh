#!/bin/bash
set -e

# This script runs on the HOST

# Create repo directory
mkdir -p repo
# Ensure repo directory is writable by the container user (usually 1000:1000 or similar, but 777 is safest for ephemeral builds)
chmod 777 repo

# Function to build a package using Docker
build_package_in_container() {
    local pkg_dir=$1
    echo "Building package in $pkg_dir using Docker"
    
    # Run the build in a container
    # We mount:
    # - The package directory to /pkg
    # - The repo directory to /repo
    # - The container_build.sh script to /build.sh
    docker run --rm \
        -v "$(pwd)/$pkg_dir:/pkg" \
        -v "$(pwd)/repo:/repo" \
        -v "$(pwd)/container_build.sh:/build.sh" \
        archlinux:base-devel \
        /bin/bash /build.sh
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
        build_package_in_container "$dirname"
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
        
        # Handle package_name:output_name format
        pkgname=$(echo "$line" | cut -d':' -f1)
        
        echo "Fetching AUR package: $pkgname"
        # We clone on the host to keep things simple
        git clone "https://aur.archlinux.org/$pkgname.git"
        
        if [ -d "$pkgname" ]; then
            # We need to go back up to call build_package_in_container with the correct path
            cd ..
            build_package_in_container "aur_temp/$pkgname"
            cd aur_temp
        else
            echo "Failed to clone $pkgname"
        fi
        
    done < ../aurpackages
    cd ..
    rm -rf aur_temp
fi

# Generate repository database
# We can do this in a container too, or on the host if repo-add is available.
# Since we are assuming a self-hosted runner which might not have pacman, let's use a container.
echo "Generating repository database..."
docker run --rm \
    -v "$(pwd)/repo:/repo" \
    archlinux:base-devel \
    /bin/bash -c "cd /repo && repo-add instant.db.tar.gz *.pkg.tar.zst"

echo "Build complete!"
