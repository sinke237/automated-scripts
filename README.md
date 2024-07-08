# automated-scripts
Great scripts to automate repeated tasks

## Activate user Execution right

``` chmod +x create-multipass-vm.sh ```
``` chmod +x  setup-vm.sh script-inside-vm.sh```

## Aim

The config-programs.sh has programs I frequently need to use when creating a new virtual machine.

Please feel free to folk this reposity and customize the scripts for your needs.
Don't forget to give this repo a star.


## Note
Run the config.programs.sh from the host machine to install all the sited programs in VM.

## Challenges
Because it is complex to handle nested shell sessions, I am splitting the script into two; 
1. setup-vm.sh to run on the host  pc
2. script-inside-vm.sh to run inside the virtual machine.
