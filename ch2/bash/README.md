# Bash Scripts for Infrastructure Automation

This example demonstrates **ad-hoc scripting** for infrastructure automation using Bash scripts to manage Vagrant VMs.

## What This Teaches

In the book, this approach uses Bash scripts with AWS CLI to:
- Create security groups
- Launch EC2 instances
- Configure networking

Our Vagrant adaptation shows the same concepts:
- Automating VM creation and destruction
- Provisioning servers with shell scripts
- Managing infrastructure programmatically

## Files

- **deploy-vagrant-vm.sh** (Linux/Mac) - Automates VM deployment
- **deploy-vagrant-vm.bat** (Windows) - Same functionality for Windows
- **provision.sh** - Installs Node.js and runs the app on the VM
- **Vagrantfile** - Minimal VM configuration

## Quick Start

### Windows
```cmd
deploy-vagrant-vm.bat
```

### Linux/Mac
```bash
chmod +x deploy-vagrant-vm.sh
./deploy-vagrant-vm.sh
```

The script will:
1. Check for Vagrant and VirtualBox
2. Destroy any existing VM
3. Create a new Ubuntu VM
4. Run `provision.sh` to install Node.js and start the app
5. Display the access URL

## Access the App

Once deployed, visit: **http://localhost:8080**

## Manual Approach (Without the Script)

You can also do this manually to understand what the script automates:

```bash
vagrant up
vagrant ssh
curl http://localhost:8080
```

## Key Concepts

### Ad-Hoc Scripting
This approach uses simple shell scripts to automate tasks. It's:

**Pros:**
- Simple and straightforward
- No special tools needed (just Bash)
- Easy to understand and modify
- Quick for one-off tasks

**Cons:**
- Not declarative (you specify HOW, not WHAT)
- Hard to maintain as complexity grows
- No idempotency guarantees
- Limited error handling
- Doesn't scale well

## Comparison to AWS Example

| Aspect | AWS (Book) | Vagrant (This Example) |
|--------|------------|------------------------|
| Infrastructure | EC2 instance | Local VM |
| Deployment Script | Uses AWS CLI | Uses Vagrant CLI |
| Provisioning | user-data.sh | provision.sh |
| Networking | Security groups | Port forwarding |
| Cost | Pay per hour | Free (local) |

## What's Next?

The ad-hoc script approach works but has limitations:
- What if the script fails halfway through?
- How do you know what's already been configured?
- How do you update the infrastructure?

This is why we move to better tools in the next examples:
- **Ansible** - Configuration management with idempotency
- **Packer** - Build reusable machine images
- **OpenTofu** - Declarative infrastructure provisioning

## Cleanup

```bash
vagrant destroy -f
```

Or just run the deploy script again (it auto-destroys the old VM).
