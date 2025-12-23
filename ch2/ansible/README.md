# Ansible for Configuration Management

This example demonstrates **configuration management** using Ansible, a declarative and idempotent automation tool.

## What This Teaches

In the book, Ansible is used to:
- Configure EC2 instances
- Install software packages
- Deploy applications
- Manage configuration in a repeatable way

Our Vagrant adaptation shows the same concepts locally:
- Declarative infrastructure (describe WHAT, not HOW)
- Idempotent operations (safe to run multiple times)
- Role-based organization
- Reusable automation

## Files and Structure

```
ch2/ansible/
├── Vagrantfile                    # Vagrant config with Ansible provisioner
├── playbook.yml                   # Main Ansible playbook
├── ansible.cfg                    # Ansible configuration
└── roles/
    └── sample-app/                # Ansible role for the app
        ├── tasks/
        │   └── main.yml          # Tasks to configure the app
        └── files/
            └── app.js            # The Node.js application
```

## Quick Start

```bash
cd ch2/ansible
vagrant up
```

This will:
1. Create an Ubuntu VM
2. Install Ansible inside the VM
3. Run the Ansible playbook
4. Install Node.js
5. Deploy and start the app

Access the app at: **http://localhost:8080**

## How It Works

### The Playbook (`playbook.yml`)

The playbook is the entry point:
```yaml
- name: Configure the VM to run a sample app
  hosts: all
  become: true
  roles:
    - sample-app
```

This tells Ansible to:
- Target all hosts
- Use sudo privileges (`become: true`)
- Apply the `sample-app` role

### The Role (`roles/sample-app/`)

The role contains:

**tasks/main.yml** - The automation tasks:
1. Add NodeSource GPG key
2. Add NodeSource repository
3. Update apt cache
4. Install Node.js
5. Copy app.js to the VM
6. Start the Node.js app

**files/app.js** - The application to deploy

### Vagrant Integration

The Vagrantfile uses the `ansible_local` provisioner:
```ruby
config.vm.provision "ansible_local" do |ansible|
  ansible.playbook = "playbook.yml"
end
```

This installs Ansible inside the VM and runs the playbook.

## Key Concepts

### 1. Declarative Configuration

**Bash approach (imperative):**
```bash
apt-get install nodejs  # HOW to do it
```

**Ansible approach (declarative):**
```yaml
- name: Install Node.js
  apt:
    name: nodejs
    state: present      # WHAT you want
```

You describe the desired state, not the steps to get there.

### 2. Idempotency

Run the playbook multiple times - it's safe!

```bash
vagrant provision
```

Ansible checks the current state and only makes changes if needed:
- Node.js already installed? Skip it.
- App already running? Don't start it again.
- File already exists with correct content? No change.

**Try it:** Run `vagrant provision` twice. The second time will be much faster because nothing needs changing.

### 3. Role-Based Organization

Roles make automation reusable and organized:

```
roles/
└── sample-app/          # Everything for one component
    ├── tasks/           # What to do
    ├── files/           # Static files to copy
    ├── templates/       # Dynamic files (we don't use this here)
    ├── handlers/        # Triggered tasks (we don't use this here)
    └── vars/            # Variables (we don't use this here)
```

You can reuse the `sample-app` role across different playbooks and environments.

## Comparing to Bash Approach

| Aspect | Bash | Ansible |
|--------|------|---------|
| **Style** | Imperative (HOW) | Declarative (WHAT) |
| **Idempotency** | No - runs everything each time | Yes - only changes what's needed |
| **Error Handling** | Manual checks needed | Built-in state checking |
| **Reusability** | Copy/paste scripts | Roles and modules |
| **Readability** | Command sequences | Human-readable YAML |
| **Complexity** | Good for simple tasks | Better as complexity grows |
| **Learning Curve** | Easy - just bash | Moderate - learn Ansible concepts |

## Testing Idempotency

1. First run:
   ```bash
   vagrant up
   ```
   Watch Ansible install everything (will show "changed" status).

2. Run provisioning again:
   ```bash
   vagrant provision
   ```
   Watch Ansible skip most tasks (will show "ok" status, not "changed").

This is idempotency in action!

## Manual Ansible Usage

You can also run Ansible manually inside the VM:

```bash
vagrant ssh
cd /vagrant
ansible-playbook playbook.yml -i "localhost," --connection=local
```

## Advanced: Running Ansible from Host (Windows Note)

The Vagrantfile uses `ansible_local` (runs Ansible inside the VM) because:
- Works on Windows (Windows doesn't support Ansible natively)
- No need to install Ansible on your host machine
- Simpler setup

On Linux/Mac, you could use `ansible` provisioner (runs from host).

## Troubleshooting

**Issue: Playbook fails on first run**

Some tasks may fail if repositories aren't updated. The playbook includes an apt cache update to handle this.

**Issue: App doesn't start**

SSH into the VM and check:
```bash
vagrant ssh
ps aux | grep node
cat /home/vagrant/app.log
```

**Issue: Port 8080 already in use**

Make sure you destroyed the VM from the bash example:
```bash
cd ../bash
vagrant destroy -f
cd ../ansible
```

## What's Better Than Bash?

Ansible improves on bash scripts with:

1. **Idempotency** - Safe to run multiple times
2. **Declarative** - Describe the end state
3. **Error handling** - Built-in checks
4. **Abstraction** - Modules handle OS differences
5. **Organization** - Roles structure complex automation

## What's Next?

Ansible is great for configuration management, but:
- Still need to create the VM first (that's where Vagrant/Terraform come in)
- Every server gets configured individually
- What if you want identical servers quickly?

That's where **Packer** comes in - we'll build pre-configured machine images next!

## Cleanup

```bash
vagrant destroy -f
```

## Learning More

The official Ansible documentation is excellent:
- [Getting Started](https://docs.ansible.com/ansible/latest/getting_started/)
- [Playbook Intro](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html)
- [Roles](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_reuse_roles.html)
