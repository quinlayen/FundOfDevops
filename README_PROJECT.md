# Fundamentals of DevOps - Learning Repository

This repository contains hands-on examples following the book ["Fundamentals of DevOps and Software Delivery"](https://www.fundamentals-of-devops.com/) by Yevgeniy Brikman.

## Key Adaptation

All examples use **Vagrant + VirtualBox** instead of AWS EC2, allowing you to learn DevOps concepts **cost-free** on your local machine.

## Quick Start

### Prerequisites

Install these first:
- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Git](https://git-scm.com/downloads)

### Try the Examples

**Part 1 - Basic Deployment:**
```bash
vagrant up
# Access: http://localhost:8080
vagrant destroy -f
```

**Part 2 - Infrastructure as Code:**
```bash
cd ch2/bash      # Start with Bash
cd ch2/ansible   # Then try Ansible
cd ch2/puppet    # Compare with Puppet
```

## Project Status

📄 **See [`PROJECT_STATUS.md`](PROJECT_STATUS.md) for:**
- Detailed progress tracking
- What's completed vs in-progress
- File structure overview
- Learning resources created
- Next steps

## Structure

```
├── Part 1: Basic deployment (root directory)
├── ch2/: Infrastructure as Code
│   ├── bash/     ✅ Ad-hoc scripting
│   ├── ansible/  ✅ Configuration management
│   ├── puppet/   ✅ Configuration management (bonus)
│   ├── packer/   ⏳ Server templating (upcoming)
│   └── tofu/     ⏳ Infrastructure provisioning (upcoming)
└── Guides:
    ├── SSM_vs_Ansible_Puppet_Complete_Guide.md
    ├── ch2/ansible/ANSIBLE_GUIDE.md
    └── ch2/puppet/PUPPET_GUIDE.md
```

## Learning Resources

This repo includes comprehensive guides:
- **Ansible Guide** (40+ pages) - Complete line-by-line breakdown
- **Puppet Guide** (50+ pages) - DSL guide + Ansible comparison
- **SSM Comparison** - AWS Systems Manager vs config management tools

## Book vs This Repo

| Aspect | Book | This Repo |
|--------|------|-----------|
| **Platform** | AWS EC2 | Vagrant (local VMs) |
| **Cost** | Pay per use | Free |
| **Concepts** | Production-ready | Same concepts, safe environment |

## Contributing

This is a personal learning repository. Feel free to fork and adapt for your own learning!

## License

MIT (same as the book's example code)

## Acknowledgments

- Book: [Fundamentals of DevOps and Software Delivery](https://www.fundamentals-of-devops.com/)
- Author: [Yevgeniy Brikman](https://github.com/brikis98)
- Book Code: [github.com/brikis98/devops-book](https://github.com/brikis98/devops-book)
