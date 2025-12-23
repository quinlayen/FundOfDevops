# Project Status: Fundamentals of DevOps Learning

## Overview

This repository follows the book "Fundamentals of DevOps and Software Delivery" by Yevgeniy Brikman, adapted to use **Vagrant** (local VMs) instead of AWS EC2 for cost-free learning.

**Book Repository:** https://github.com/brikis98/devops-book

**Key Adaptation:** All examples use Vagrant + VirtualBox instead of AWS, teaching the same concepts without cloud costs.

---

## What We've Completed

### Part 1: How to Deploy Your App ✅

**Status:** Complete

**Location:** Root directory

**Files:**
- `app.js` - Simple Node.js "Hello, World" server
- `package.json` - Node.js project metadata
- `Vagrantfile` - VM configuration with inline shell provisioning
- `README.md` - Usage instructions

**What it teaches:** Basic deployment of an app to a server (Vagrant VM instead of Render/AWS)

**How to use:**
```bash
vagrant up
# Access: http://localhost:8080
```

---

### Part 2: How to Manage Your Infrastructure as Code

**Status:** 3 of 4 approaches complete (plus 1 bonus)

**Location:** `ch2/` directory

---

#### Approach 1: Bash Scripts ✅

**Location:** `ch2/bash/`

**Status:** Complete

**Files:**
- `Vagrantfile` - VM config using shell provisioner
- `provision.sh` - Shell script to install Node.js and run app
- `deploy-vagrant-vm.sh` - Automation script (Linux/Mac)
- `deploy-vagrant-vm.bat` - Automation script (Windows)
- `README.md` - Usage guide

**What it teaches:** Ad-hoc scripting for automation (imperative, not idempotent)

**How to use:**
```bash
cd ch2/bash
./deploy-vagrant-vm.bat  # Windows
```

---

#### Approach 2: Ansible ✅

**Location:** `ch2/ansible/`

**Status:** Complete

**Files:**
```
ch2/ansible/
├── Vagrantfile              # Uses ansible_local provisioner
├── playbook.yml             # Main Ansible playbook
├── ansible.cfg              # Ansible configuration
├── roles/
│   └── sample-app/
│       ├── tasks/
│       │   └── main.yml    # Ansible tasks
│       └── files/
│           └── app.js      # Node.js app
├── README.md               # Usage guide
└── ANSIBLE_GUIDE.md        # COMPLETE 40+ page detailed guide
```

**What it teaches:**
- Declarative configuration management
- Idempotent operations
- Role-based organization
- YAML-based automation

**Key Features:**
- Agentless (no agent installation needed)
- Push model (you trigger execution)
- Sequential task execution
- Cross-platform

**How to use:**
```bash
cd ch2/ansible
vagrant up
# Test idempotency:
vagrant provision
```

**Learning Resources:**
- `ANSIBLE_GUIDE.md` - Complete line-by-line breakdown of every file, YAML syntax, concepts, execution flow

---

#### Approach 2b: Puppet (BONUS - Not in book) ✅

**Location:** `ch2/puppet/`

**Status:** Complete

**Files:**
```
ch2/puppet/
├── Vagrantfile                   # Installs Puppet, uses puppet provisioner
├── manifests/
│   └── default.pp               # Main manifest (entry point)
├── modules/
│   └── sample_app/
│       ├── manifests/
│       │   └── init.pp         # Puppet module class
│       └── files/
│           └── app.js          # Node.js app
├── README.md                    # Usage guide
└── PUPPET_GUIDE.md             # COMPLETE 50+ page guide with Ansible comparison
```

**What it teaches:**
- Agent-based configuration management
- Declarative Puppet DSL
- Dependency graph execution (not sequential!)
- Pull model capabilities

**Why we added this:**
- User's company uses Windows servers in AWS
- Puppet is often recommended for Windows (native agent, DSC integration)
- Good comparison to understand tradeoffs

**Key Features:**
- Agent-based architecture
- Puppet DSL (not YAML)
- Dependency graph (resources execute in dependency order, not file order)
- Excellent Windows support

**How to use:**
```bash
cd ch2/puppet
vagrant up
```

**Learning Resources:**
- `PUPPET_GUIDE.md` - Complete guide including:
  - Line-by-line breakdown of Puppet DSL
  - Architecture comparison (Ansible vs Puppet)
  - When to choose which tool
  - Windows-specific examples
  - Dependency graph explanation

---

#### Approach 3: Packer ⏳

**Location:** `ch2/packer/`

**Status:** NOT STARTED

**What it will teach:** Building reusable Vagrant boxes (machine images) with everything pre-installed

**Book equivalent:** Building AMIs for AWS

**Next steps:** Create Packer template to build Vagrant box with Node.js pre-installed

---

#### Approach 4: OpenTofu/Terraform ⏳

**Location:** `ch2/tofu/`

**Status:** NOT STARTED

**What it will teach:** Infrastructure provisioning as code (declarative, with state management)

**Book equivalent:** Provisioning EC2 instances with Terraform/OpenTofu

**Next steps:** Create OpenTofu configuration to provision Vagrant VMs

---

### Bonus: SSM vs Ansible vs Puppet Guide ✅

**Location:** Root directory

**File:** `SSM_vs_Ansible_Puppet_Complete_Guide.md`

**Status:** Complete

**What it covers:**
- AWS Systems Manager (SSM) overview
- Complete comparison: SSM vs Ansible vs Puppet
- When to use each tool
- Real-world architecture patterns
- Windows server management considerations
- Cost analysis
- Decision framework
- Code examples for all three tools

**Why we created this:**
- User's company uses Windows servers in AWS
- Company plans to use SSM for patching and possibly CD
- Important to understand when SSM can replace config management tools
- Helps make informed tooling decisions

**Key Takeaway:** Use SSM for patching/session management, consider Ansible/Puppet for complex configuration

---

## Current Todo List

1. ✅ Set up Bash scripts for Vagrant automation
2. ✅ Set up Ansible for configuration management with Vagrant
3. ✅ Set up Puppet for configuration management with Vagrant (bonus)
4. ⏳ Set up Packer to build Vagrant boxes
5. ⏳ Set up OpenTofu/Terraform for Vagrant provisioning

---

## Key Decisions Made

### Why Vagrant Instead of AWS?

- **Cost:** Free local development vs AWS charges
- **Learning:** Same concepts, different platform
- **Accessibility:** No AWS account needed
- **Safety:** Can't accidentally rack up cloud bills

### Why We Added Puppet?

- User's company runs Windows servers in AWS
- Industry often recommends Puppet for Windows
- Good comparison to understand Ansible vs Puppet tradeoffs
- Helps make informed tooling decisions

### Architecture Approach

**All examples deploy the same app (Node.js "Hello, World" on port 8080) but using different tools:**
- Bash - Imperative scripting
- Ansible - Declarative, agentless, YAML
- Puppet - Declarative, agent-based, DSL
- Packer - (upcoming) Pre-built images
- OpenTofu - (upcoming) Infrastructure provisioning

---

## Prerequisites

User has installed:
- ✅ Vagrant
- ✅ VirtualBox
- ✅ Git Bash (Windows)

---

## Important Notes for Continuation

### Vagrantfile Configuration

All Vagrantfiles include this block to avoid compatibility issues:
```ruby
if Vagrant.has_plugin?("vagrant-vbguest")
  config.vbguest.auto_update = false
end
```

### Port Forwarding

All examples forward port 8080 from VM to host:
```ruby
config.vm.network "forwarded_port", guest: 8080, host: 8080
```

**Important:** Only one VM can be running at a time (port conflict). Destroy previous VMs before starting new ones:
```bash
vagrant destroy -f
```

### Ansible Provisioner

Uses `ansible_local` (not `ansible`) because:
- Works on Windows (Ansible doesn't run natively on Windows)
- No need to install Ansible on host
- Ansible is installed inside the VM automatically

### Puppet Provisioner

Requires manual Puppet installation via shell provisioner because Vagrant's puppet provisioner doesn't auto-install Puppet like it does for Ansible.

---

## Next Steps (Return to Packer)

When continuing, we need to:

1. **Set up Packer for building Vagrant boxes**
   - Create Packer template
   - Build a Vagrant box with Node.js pre-installed
   - Show how to use the custom box
   - Compare to manual provisioning (faster deployment)

2. **Set up OpenTofu/Terraform**
   - Create Terraform configuration for Vagrant
   - Show declarative infrastructure provisioning
   - Demonstrate state management
   - Show plan/apply workflow

3. **Create comparison summary**
   - When to use each tool
   - How they complement each other
   - Real-world usage patterns

---

## File Structure Overview

```
FundOfDevops/
├── .git/
├── .gitignore
├── app.js                                    # Part 1: Simple app
├── package.json                              # Part 1: Package metadata
├── Vagrantfile                               # Part 1: Basic deployment
├── README.md                                 # Part 1: Instructions
├── PROJECT_STATUS.md                         # THIS FILE - Current status
├── SSM_vs_Ansible_Puppet_Complete_Guide.md  # Bonus: SSM comparison
│
└── ch2/                                      # Part 2: Infrastructure as Code
    ├── README.md                             # Overview of all approaches
    │
    ├── bash/                                 # Approach 1: Ad-hoc scripts
    │   ├── Vagrantfile
    │   ├── provision.sh
    │   ├── deploy-vagrant-vm.sh
    │   ├── deploy-vagrant-vm.bat
    │   └── README.md
    │
    ├── ansible/                              # Approach 2: Config management
    │   ├── Vagrantfile
    │   ├── playbook.yml
    │   ├── ansible.cfg
    │   ├── roles/
    │   │   └── sample-app/
    │   │       ├── tasks/
    │   │       │   └── main.yml
    │   │       └── files/
    │   │           └── app.js
    │   ├── README.md
    │   └── ANSIBLE_GUIDE.md                  # ⭐ Detailed guide
    │
    ├── puppet/                               # Approach 2b: Config management (bonus)
    │   ├── Vagrantfile
    │   ├── manifests/
    │   │   └── default.pp
    │   ├── modules/
    │   │   └── sample_app/
    │   │       ├── manifests/
    │   │       │   └── init.pp
    │   │       └── files/
    │   │           └── app.js
    │   ├── README.md
    │   └── PUPPET_GUIDE.md                   # ⭐ Detailed guide with comparison
    │
    ├── packer/                               # Approach 3: Server templating (TODO)
    │   └── (not created yet)
    │
    └── tofu/                                 # Approach 4: Infrastructure provisioning (TODO)
        └── (not created yet)
```

---

## Key Learning Resources Created

1. **`ch2/ansible/ANSIBLE_GUIDE.md`**
   - 40+ pages
   - Line-by-line code breakdown
   - Complete YAML syntax guide
   - Idempotency explanations
   - Execution flow diagrams
   - Variables, conditionals, modules

2. **`ch2/puppet/PUPPET_GUIDE.md`**
   - 50+ pages
   - Complete Puppet DSL guide
   - Ansible vs Puppet comparison
   - Dependency graph explanation
   - Windows-specific examples
   - When to choose which tool

3. **`SSM_vs_Ansible_Puppet_Complete_Guide.md`**
   - Comprehensive SSM overview
   - Feature comparison matrix
   - Real-world architecture patterns
   - Decision framework
   - Cost analysis
   - Code examples

---

## Questions to Ask When Continuing

If the new Claude Code session needs clarification:

1. **"Where did we leave off?"**
   - We completed Bash, Ansible, and Puppet (bonus)
   - Need to do Packer and OpenTofu next
   - User wants to continue learning the book material

2. **"Why did we add Puppet if it's not in the book?"**
   - User's company uses Windows servers in AWS
   - Wanted to understand Ansible vs Puppet for Windows
   - Common industry question

3. **"What's the learning approach?"**
   - Adapt book examples from AWS to Vagrant
   - Same concepts, zero cost
   - Create detailed guides for each tool

4. **"Any special requirements?"**
   - User is on Windows
   - Using Vagrant + VirtualBox
   - Prefers detailed explanations
   - Wants downloadable markdown guides

---

## Testing Instructions

To verify everything works on the new machine:

### Test Part 1
```bash
cd /path/to/FundOfDevops
vagrant up
# Should see "Hello, World!" at http://localhost:8080
vagrant destroy -f
```

### Test Bash Approach
```bash
cd ch2/bash
vagrant up
# Should see "Hello, World!" at http://localhost:8080
vagrant destroy -f
```

### Test Ansible Approach
```bash
cd ch2/ansible
vagrant up
# Watch Ansible install and configure
# Access http://localhost:8080
vagrant provision  # Test idempotency - should be much faster
vagrant destroy -f
```

### Test Puppet Approach
```bash
cd ch2/puppet
vagrant up
# Watch Puppet install and configure
# Access http://localhost:8080
vagrant provision  # Test idempotency
vagrant destroy -f
```

---

## Common Issues & Solutions

### Port 8080 Already in Use

**Problem:** Another VM is still running

**Solution:**
```bash
vagrant global-status
vagrant destroy <id> -f
```

### VirtualBox Errors

**Problem:** VirtualBox not running or version mismatch

**Solution:**
- Ensure VirtualBox is installed and running
- All Vagrantfiles disable vbguest plugin to avoid issues

### Ansible/Puppet Installation Failures

**Problem:** Network issues or repository problems

**Solution:**
- Re-run `vagrant provision`
- Check internet connectivity in VM
- Try `vagrant destroy -f` and `vagrant up` again

---

## Book Progress

### Completed
- ✅ Part 1: How to Deploy Your App
- 🔄 Part 2: How to Manage Your Infrastructure as Code (60% complete)

### Not Started
- ⏳ Part 3: How to Deploy Many Apps (Kubernetes, orchestration)
- ⏳ Part 4: How to Version, Build, and Test Your Code
- ⏳ Part 5: How to Set Up CI/CD

---

## User Context

- **Background:** Learning DevOps fundamentals
- **Environment:** Windows desktop, will continue on work computer
- **Company:** Uses Windows servers in AWS, planning SSM for patching/CD
- **Goal:** Understand infrastructure automation tools and when to use each
- **Learning Style:** Prefers detailed explanations with examples

---

## Resume Instructions for Claude Code

When picking up this conversation:

1. **Read this file** to understand current status
2. **Ask user:** "Would you like to continue with Packer (building Vagrant boxes), or would you prefer to explore something else first?"
3. **Reference existing work:** Point to the comprehensive guides already created
4. **Maintain consistency:** Use the same file structure and naming conventions
5. **Continue pedagogy:** Detailed explanations, compare to book, create downloadable guides

---

## Quick Commands Reference

```bash
# Start VM
vagrant up

# Provision existing VM
vagrant provision

# SSH into VM
vagrant ssh

# Check status
vagrant status

# Stop VM
vagrant halt

# Destroy VM
vagrant destroy -f

# See all VMs
vagrant global-status

# Destroy specific VM
vagrant destroy <id> -f
```

---

**Last Updated:** 2025-12-22
**Next Task:** Set up Packer for building Vagrant boxes
**Status:** Ready to continue with Part 2, Approach 3 (Packer)
