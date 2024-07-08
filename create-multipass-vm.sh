#!/bin/bash

# Create a VM
read -p "Enter the VM name: " vm_name
read -p "How many CPUs should this VM use? " no_of_cpus
read -p "How much disk space be allocated (in GM)? " disk_space
read -p "How much ram should this VM use (in GB)? " ram_value

multipass launch --name "$vm_name" --cpus "$no_of_cpus" --disk "${disk_space}G" --memory "${ram_value}G"

# Mount dir form host to VM
read -p "Enter dir to mount from host (e.g. /path/to/dir): " host_dir
multipass mount "$host_dir" "$vm_name":/home/ubuntu/dir
