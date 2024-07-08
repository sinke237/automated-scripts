#!/bin/bash

# Create a VM

# Function to extract numeric value from input
extract_num(){
    local value="$1"
    echo "$value" | sed 's/[^0-9]*//g'
}
read -p "Enter the VM name: " vm_name
read -p "How many CPUs should this VM use? " no_of_cpus
read -p "How much disk space be allocated (in GB)? " disk_space_input
read -p "How much ram should this VM use (in GB)? " ram_value_input

disk_space=$(extract_num "$disk_space_input")
ram_value=$(extract_num "$ram_value_input")

multipass launch --name "$vm_name" --cpus "$no_of_cpus" --disk "${disk_space}G" --memory "${ram_value}G"

# Mount dir form host to VM
read -p "Enter dir to mount from host (e.g. /path/to/dir): " host_dir
multipass mount "$host_dir" "$vm_name":/home/ubuntu/dir
