#!/bin/bash

# Ensure the script exits if any command fails
set -e

# Download the latest stow archive
wget http://ftp.gnu.org/gnu/stow/stow-latest.tar.gz

# Unzip the archive
tar -xzf stow-latest.tar.gz

# Get the directory name, assuming it starts with "stow"
DIR_NAME=$(tar -tzf stow-latest.tar.gz | head -1 | cut -f1 -d"/")

# Change to the directory
cd "$DIR_NAME"

# Configure and install
./configure
make install

# Return to the parent directory
cd ..

# Clean up
rm -rf "$DIR_NAME" stow-latest.tar.gz

echo "Installation of stow is complete."

