#!/bin/bash
#This script will use dkms to add, build and install based on dkms.conf and the Makefile in this directory.
set -e
src_dir=$(realpath $(dirname $(realpath $0)))
clean=0
while getopts ch flag 
do
    case "${flag}" in
        c) clean=1;;
        h) echo "Usage: ${0##*/} [OPTION]
            -c                      clean shadow source directory if needed
            "
            exit;;
    esac
done

module_name="xdma"
ver="1.0"
shadow_src_dir="/usr/src/$module_name-$ver"
echo Setting $module_name-$ver in dkms...
echo Creating a shadow of the source under $shadow_src_dir

# Verify the shadow source directory doesn't exist.
if [ -d "$shadow_src_dir" ]; then
    if [ $clean == 1 ]; then
        echo -n "$shadow_src_dir already exists, would you like to remove using: sudo rm -Ir ${shadow_src_dir} - "
        sudo rm -Ir ${shadow_src_dir}
    else
        echo "** Error - $shadow_src_dir already exists and must be removed before continuing, run with -c **"
        exit 1
    fi
fi

# Create the shadow source directory which has the tree structure required by dkms (dump an additional include file).
sudo mkdir -p $shadow_src_dir
sudo cp $src_dir/* $shadow_src_dir/
sudo cp $src_dir/../include/libxdma_api.h $shadow_src_dir/

# Add to dkms, build and install.
module_already_in_dkms=$(dkms status | grep -q "$module_name/$ver" && echo 1 || echo 0)
if [ $module_already_in_dkms == 1 ]; then
    sudo dkms remove $module_name/$ver --all
fi
sudo dkms add -m $module_name -v $ver
sudo dkms build -m $module_name -v $ver
sudo dkms install -m $module_name -v $ver --force
echo Completed setting $module_name-$ver in dkms
