# Part 2: How to Manage Your Infrastructure as Code

This directory contains examples of four different approaches to infrastructure automation, following the book's Part 2. Each approach deploys the same Node.js "Hello, World" app, but using different tools and methodologies.

## The Four Approaches

### 1. Ad-Hoc Scripts (`bash/`)

**Tool:** Bash scripts
**Concept:** Simple automation with shell scripts

The most basic approach - write scripts that execute commands in sequence.

```bash
cd bash
deploy-vagrant-vm.bat  # Windows
./deploy-vagrant-vm.sh # Linux/Mac
```

**Best for:** Simple, one-off tasks
**Limitations:** Not idempotent, imperative, hard to maintain at scale

### 2. Configuration Management (`ansible/`)

**Tool:** Ansible
**Concept:** Declarative, idempotent configuration

Define the desired state of your infrastructure, and Ansible makes it so.

```bash
cd ansible
vagrant up
```

**Best for:** Configuring existing servers, managing complex deployments
**Advantages:** Idempotent, declarative, reusable roles

### 2b. Configuration Management - Bonus (`puppet/`)

**Tool:** Puppet
**Concept:** Agent-based configuration management

Alternative to Ansible, often recommended for Windows environments. Uses dependency graphs instead of sequential execution.

```bash
cd puppet
vagrant up
```

**Best for:** Large server fleets, Windows environments with DSC, compliance reporting
**Advantages:** Native Windows support, dependency graphs, pull model capabilities
**Note:** Not in the original book, but valuable for comparison and Windows-focused shops

### 3. Server Templating (`packer/`)

**Tool:** Packer
**Concept:** Build pre-configured machine images

Create reusable VM images (Vagrant boxes) with everything pre-installed.

```bash
cd packer
# Coming soon!
```

**Best for:** Creating identical servers quickly, immutable infrastructure
**Advantages:** Fast deployment, consistency, no configuration drift

### 4. Infrastructure Provisioning (`tofu/`)

**Tool:** OpenTofu (Terraform fork)
**Concept:** Declarative infrastructure as code

Define your entire infrastructure in code - VMs, networks, storage, etc.

```bash
cd tofu
# Coming soon!
```

**Best for:** Managing complete infrastructure, cloud resources
**Advantages:** Declarative, state management, plan before apply

## Comparison Matrix

| Feature | Bash | Ansible | Puppet | Packer | OpenTofu |
|---------|------|---------|--------|--------|----------|
| **Idempotent** | ❌ No | ✅ Yes | ✅ Yes | N/A | ✅ Yes |
| **Declarative** | ❌ No | ✅ Yes | ✅ Yes | ✅ Yes | ✅ Yes |
| **Architecture** | N/A | Agentless | Agent-based | N/A | N/A |
| **Learning Curve** | Easy | Medium | Steep | Medium | Medium |
| **Best Use Case** | Quick scripts | Config mgmt | Config mgmt | Build images | Provision infra |
| **Windows Support** | Poor | Good | Excellent | N/A | N/A |
| **Reusability** | Low | High | High | High | High |
| **State Management** | None | None | None | None | Built-in |

## Which Tool Should I Use?

The answer is: **All of them!** They complement each other:

1. **Packer** - Build a base VM image with common software
2. **OpenTofu/Terraform** - Provision the infrastructure (VMs, networks, etc.)
3. **Ansible** - Configure the application-specific settings
4. **Bash** - Handle one-off tasks and glue code

## Learning Path

We recommend following in order:

1. **Start with Bash** (`bash/`) - Understand the basics of automation
2. **Learn Ansible** (`ansible/`) - See how declarative and idempotent tools work
3. **Try Packer** (`packer/`) - Build reusable machine images
4. **Explore OpenTofu** (`tofu/`) - Manage infrastructure as code

Each builds on concepts from the previous one.

## Current Status

- ✅ **Bash** - Complete and ready to use
- ✅ **Ansible** - Complete and ready to use
- ✅ **Puppet** - Complete and ready to use (bonus, not in book)
- 🚧 **Packer** - Coming soon
- 🚧 **OpenTofu** - Coming soon

## Book Comparison

| Aspect | Book Examples | Our Examples |
|--------|---------------|--------------|
| Platform | AWS EC2 | Vagrant (local VMs) |
| Cost | Pay per use | Free (local) |
| Learning Focus | Cloud deployment | IaC concepts |
| Tools | AWS CLI, Ansible, Packer, OpenTofu | Same tools, different targets |

The concepts are identical - we're just using Vagrant instead of AWS so you can learn without cloud costs.

## Prerequisites

- **Vagrant** - [Download](https://www.vagrantup.com/downloads)
- **VirtualBox** - [Download](https://www.virtualbox.org/wiki/Downloads)
- **Git Bash** (Windows) - For running shell scripts

## Getting Started

Each subdirectory has its own README with detailed instructions:

- [Bash README](bash/README.md)
- [Ansible README](ansible/README.md)
- [Puppet README](puppet/README.md) - Bonus: Alternative to Ansible
- Packer README (coming soon)
- OpenTofu README (coming soon)

Start with the Bash example and work your way through!

**Special Comparison:** After trying both Ansible and Puppet, read their guide files to understand the differences:
- [Ansible Guide](ansible/ANSIBLE_GUIDE.md) - Complete line-by-line breakdown
- [Puppet Guide](puppet/PUPPET_GUIDE.md) - Includes Ansible vs Puppet comparison

## Common Issues

**Port 8080 already in use:**
```bash
# Make sure to destroy VMs from other examples
vagrant global-status
vagrant destroy <id>
```

**VirtualBox errors:**
Make sure VirtualBox is installed and running.

**Vagrant plugin issues:**
The Vagrantfiles disable the vbguest plugin to avoid compatibility issues.

## Next Steps

After completing Part 2, you'll understand:
- Different approaches to infrastructure automation
- When to use each tool
- How to combine tools effectively

Part 3 of the book covers "How to Deploy Many Apps" with orchestration tools like Kubernetes!
