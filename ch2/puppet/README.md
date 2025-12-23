# Puppet for Configuration Management

This example demonstrates **agent-based configuration management** using Puppet, an alternative to Ansible that's often recommended for Windows environments.

## What This Teaches

Same goal as the Ansible example (install Node.js, deploy app), but using:
- **Agent-based** architecture (vs Ansible's agentless)
- **Puppet DSL** (vs Ansible's YAML)
- **Dependency graphs** (vs Ansible's sequential execution)
- **Pull model** capabilities (vs Ansible's push model)

## Why Puppet for Windows?

Many companies running Windows servers prefer Puppet because:
- ✅ Native Windows agent (no WinRM hassles)
- ✅ Deep PowerShell DSC integration
- ✅ Extensive Windows-specific modules
- ✅ Feels more native to Windows administrators

**However:** Ansible works fine for Windows too! The choice depends on your team and requirements.

## Files and Structure

```
ch2/puppet/
├── Vagrantfile                    # Vagrant config with Puppet provisioner
├── manifests/
│   └── default.pp                # Main manifest (entry point)
├── modules/
│   └── sample_app/               # Our module
│       ├── manifests/
│       │   └── init.pp          # Module class definition
│       └── files/
│           └── app.js           # The Node.js application
└── PUPPET_GUIDE.md              # Complete guide comparing to Ansible
```

## Quick Start

```bash
cd ch2/puppet
vagrant up
```

This will:
1. Create an Ubuntu VM
2. Install Puppet agent
3. Install required Puppet modules (puppetlabs-apt)
4. Apply the Puppet manifest
5. Install Node.js
6. Deploy and start the app

Access the app at: **http://localhost:8080**

## How It Works

### 1. Main Manifest (`manifests/default.pp`)

```puppet
include sample_app
```

Includes the `sample_app` module/class.

### 2. Module (`modules/sample_app/manifests/init.pp`)

Defines resources:
- Add NodeSource GPG key
- Add NodeSource repository
- Update apt cache
- Install Node.js package
- Copy app.js file
- Start the application

### 3. Dependency Graph

Unlike Ansible (sequential), Puppet builds a dependency graph:

```
apt::key → apt::source → exec[apt_update] → package[nodejs] → file[app.js] → exec[start_app]
```

Resources execute in dependency order, not file order!

## Key Differences from Ansible

| Aspect | Ansible | Puppet |
|--------|---------|--------|
| **Language** | YAML | Puppet DSL |
| **Architecture** | Agentless (SSH/WinRM) | Agent-based |
| **Execution** | Sequential (top to bottom) | Dependency graph |
| **Syntax** | `key: value` | `key => value` |
| **File paths** | Relative OK | Must use absolute paths |
| **Conditionals** | `when:` | `unless:`, `onlyif:` |

### Ansible Task Example

```yaml
- name: Install Node.js
  ansible.builtin.apt:
    name: nodejs
    state: present
```

### Puppet Resource Example

```puppet
package { 'nodejs':
  ensure => present,
}
```

## Testing Idempotency

**First run:**
```bash
vagrant up
```

Resources will be created/applied.

**Second run:**
```bash
vagrant provision
```

Puppet checks each resource and only changes what's needed!

**What you'll see:**
- Resources already in desired state → skipped
- Resources that need changes → applied
- Dependencies automatically respected

## Learning Puppet

Read **`PUPPET_GUIDE.md`** for:
- Complete Puppet architecture explanation
- Line-by-line breakdown of every file
- Puppet DSL syntax guide
- Why Puppet is recommended for Windows
- When to choose Puppet vs Ansible
- Detailed comparison of both tools

## Manual Puppet Usage

After `vagrant ssh`, you can run Puppet manually:

```bash
vagrant ssh
cd /vagrant
sudo puppet apply --modulepath=modules manifests/default.pp
```

## Puppet for Windows Example

While our example uses Linux, here's what Puppet Windows config looks like:

```puppet
class windows_webserver {
  # Install IIS using DSC
  dsc_windowsfeature { 'IIS':
    dsc_ensure => 'present',
    dsc_name   => 'Web-Server',
  }

  # Configure Windows Firewall
  windows_firewall_rule { 'HTTP':
    ensure    => present,
    direction => 'Inbound',
    action    => 'Allow',
    protocol  => 'TCP',
    port      => 80,
  }
}
```

This is why Puppet is popular for Windows - native Windows resources and DSC integration!

## When to Use Puppet

✅ Managing large fleets of servers (100s-1000s)
✅ Windows-heavy environment with DSC usage
✅ Want centralized configuration management
✅ Prefer agent-based architecture
✅ Need strong compliance and reporting
✅ Infrastructure-focused (vs application deployment)

## When to Use Ansible

✅ Agentless architecture preferred
✅ Easier learning curve (YAML vs DSL)
✅ Application deployment and orchestration
✅ Ad-hoc command execution needed
✅ Smaller infrastructure (10s-100s of servers)
✅ Mixed environment tooling

## Comparison to Other Examples

All three examples deploy the same app:

**Bash (`ch2/bash/`)**
- Imperative shell commands
- Not idempotent
- Simple but not scalable

**Ansible (`ch2/ansible/`)**
- Declarative YAML
- Idempotent
- Sequential execution
- Agentless

**Puppet (`ch2/puppet/`)**
- Declarative DSL
- Idempotent
- Dependency graph execution
- Agent-based

## Real-World Usage

Many companies use **both** Puppet and Ansible:
- **Puppet** for OS-level configuration and compliance
- **Ansible** for application deployment

Or use cloud-native tools:
- AWS Systems Manager (SSM)
- Azure Automation DSC
- Google Cloud Config Management

The "best" tool is the one your team knows and fits your needs!

## Cleanup

```bash
vagrant destroy -f
```

## Further Reading

- [Puppet Documentation](https://puppet.com/docs/puppet/latest/puppet_index.html)
- [Puppet Forge](https://forge.puppet.com/) - Module repository
- [Learning Puppet](https://puppet.com/docs/puppet/latest/learning_puppet.html)
- [Puppet vs Ansible](https://puppet.com/resources/infographic/puppet-vs-ansible/) - Official comparison

## Next Steps

After understanding both Ansible and Puppet:
- Compare the code side-by-side
- Understand when to choose each
- Move on to **Packer** (building machine images)
- Then **OpenTofu** (infrastructure provisioning)

You now understand the two most popular configuration management tools!
