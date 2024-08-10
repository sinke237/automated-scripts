# automated-scripts
Great scripts to automate repeated tasks

## How to use this scripts
- Allow user execution rights:

``` chmod +x create-multipass-vm.sh ```
``` chmod +x  setup-vm.sh script-inside-vm.sh```

- To create multipass instance, execute:
``` ./create-multipass-vm.sh ```

- To install programs into your just created vm, execute (on the host):
``` ./setup-vm.sh ```

- NOTE: this will trigger `script-inside-vm.sh` to run inside the vm.


## Challenges
Because it is complex to handle nested shell sessions, I am splitting the script into two; 
1. setup-vm.sh to run on the host  pc
2. script-inside-vm.sh to run inside the virtual machine.
