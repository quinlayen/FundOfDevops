#!/bin/bash
# This script automates Vagrant VM deployment
# Equivalent to deploy-ec2-instance.sh in the AWS example

set -e

echo "==================================================="
echo "Deploying Vagrant VM with sample Node.js app"
echo "==================================================="

# Check if Vagrant is installed
if ! command -v vagrant &> /dev/null; then
    echo "ERROR: Vagrant is not installed!"
    echo "Please install Vagrant from https://www.vagrantup.com/downloads"
    exit 1
fi

# Check if VirtualBox is installed
if ! command -v VBoxManage &> /dev/null; then
    echo "ERROR: VirtualBox is not installed!"
    echo "Please install VirtualBox from https://www.virtualbox.org/wiki/Downloads"
    exit 1
fi

# Navigate to the directory containing this script
cd "$(dirname "$0")"

# Destroy existing VM if it exists
if vagrant status | grep -q "running\|saved\|poweroff"; then
    echo "Existing VM found. Destroying it..."
    vagrant destroy -f
fi

# Start and provision the VM
echo "Creating and provisioning new VM..."
vagrant up

# Get VM status
VM_STATUS=$(vagrant status | grep "default" | awk '{print $2}')
echo ""
echo "==================================================="
echo "Deployment Complete!"
echo "==================================================="
echo "VM Status: $VM_STATUS"
echo ""
echo "You can access the app at: http://localhost:8080"
echo ""
echo "Useful commands:"
echo "  vagrant ssh           - SSH into the VM"
echo "  vagrant status        - Check VM status"
echo "  vagrant halt          - Stop the VM"
echo "  vagrant destroy       - Delete the VM"
echo "==================================================="
