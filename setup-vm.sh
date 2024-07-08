#!/bin/bash

# Start a shell session with Multipass VM
read -p "Enter the name of your Multipass VM: " vm_name

# Check if the VM exists before attempting to shell into it
if multipass info $vm_name &> /dev/null; then
    echo "VM $vm_name exists. Starting setup..."

    # Transfer and execute setup script inside VM
    multipass transfer script-inside-vm.sh $vm_name:/home/ubuntu/script-inside-vm.sh
    multipass exec $vm_name bash /home/ubuntu/script-inside-vm.sh
    
    echo "Setup completed successfully."

else 
    echo "VM $vm_name does not exist. Please enter an existing VM name."
fi
