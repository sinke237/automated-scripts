#!/bin/bash

# Function to extract numeric value from input
extract_num(){
    local value="$1"
    echo "$value" | sed 's/[^0-9]*//g'
}

read -p "Enter the VM name: " vm_name
read -p "How many CPUs should this VM use? " no_of_cpus
read -p "How much disk space be allocated (in GB)? " disk_space_input
read -p "How much RAM should this VM use (in GB)? " ram_value_input

disk_space=$(extract_num "$disk_space_input")
ram_value=$(extract_num "$ram_value_input")

if multipass launch --name "$vm_name" --cpus "$no_of_cpus" --disk "${disk_space}G" --memory "${ram_value}G"; then
    read -p "Do you want to create a mount point? (yes/no): " create_mount

    if [[ $create_mount == "yes" ]]; then
        read -p "Enter directory to mount from host (e.g. /path/to/dir): " host_dir
        # check if the mount point exits first before mounting.
        multipass mount "$host_dir" "$vm_name":/home/ubuntu/mount_point
        echo "Mount point created successfully."
    else
        echo "No mount point created."
    fi
else 
    echo "Failed to create VM '$vm_name'. Please check your inputs and try again."
fi
