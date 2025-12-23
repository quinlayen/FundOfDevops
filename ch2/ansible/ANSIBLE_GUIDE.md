# Complete Ansible Guide - Understanding Every Detail

This guide explains every aspect of the Ansible setup, line by line, so you understand exactly what's happening.

## Table of Contents

1. [Ansible Architecture & Concepts](#ansible-architecture--concepts)
2. [File Structure Overview](#file-structure-overview)
3. [File-by-File Breakdown](#file-by-file-breakdown)
4. [How It All Works Together](#how-it-all-works-together)
5. [YAML Syntax Primer](#yaml-syntax-primer)
6. [Execution Flow](#execution-flow)

---

## Ansible Architecture & Concepts

### What is Ansible?

Ansible is a **configuration management tool** that:
- Connects to servers via SSH
- Executes tasks to configure them
- Is **agentless** (no software needed on target servers)
- Uses **declarative** syntax (describe the end state, not the steps)
- Is **idempotent** (safe to run multiple times)

### Core Concepts

#### 1. Control Node
The machine where you run Ansible from (in our case, inside the VM via `ansible_local`).

#### 2. Managed Nodes
The servers you're configuring (in our case, the VM configures itself - `localhost`).

#### 3. Inventory
A list of servers to manage. Can be:
- Static file listing servers
- Dynamic script that queries cloud APIs
- Simple: `localhost` for local execution

#### 4. Playbook
A YAML file defining **what** to configure. Like a recipe.

#### 5. Tasks
Individual actions to perform (install package, copy file, start service, etc.).

#### 6. Modules
Reusable code that performs tasks. Examples:
- `apt` - Manage apt packages
- `copy` - Copy files
- `shell` - Run shell commands
- [2000+ built-in modules](https://docs.ansible.com/ansible/latest/collections/index_module.html)

#### 7. Roles
A way to organize playbooks into reusable components. Think of it as a function or library.

#### 8. Idempotency
Running the same playbook multiple times produces the same result without breaking things.

**Example:**
```yaml
# This is idempotent
- name: Ensure nginx is installed
  apt:
    name: nginx
    state: present
```

First run: Installs nginx (changed)
Second run: Sees nginx is already installed (ok, no change)

---

## File Structure Overview

```
ch2/ansible/
├── Vagrantfile                    # Vagrant config - tells Vagrant to use Ansible
├── ansible.cfg                    # Ansible settings
├── playbook.yml                   # Main playbook - entry point
└── roles/
    └── sample-app/                # A role for our app
        ├── tasks/
        │   └── main.yml          # Tasks the role performs
        └── files/
            └── app.js            # Files the role uses
```

### Role Structure Explained

A role is a folder with a standardized structure:

```
roles/
└── <role-name>/
    ├── tasks/          # Required: What to do
    │   └── main.yml
    ├── files/          # Optional: Static files to copy
    ├── templates/      # Optional: Dynamic files (Jinja2 templates)
    ├── vars/           # Optional: Variables
    ├── defaults/       # Optional: Default variables
    ├── handlers/       # Optional: Triggered tasks (like service restarts)
    └── meta/           # Optional: Role metadata and dependencies
```

We only use `tasks/` and `files/` for this simple example.

---

## File-by-File Breakdown

### 1. `Vagrantfile`

```ruby
Vagrant.configure("2") do |config|
  # Disable vbguest plugin to avoid compatibility issues
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  # Use Ubuntu 22.04 LTS as the base box
  config.vm.box = "ubuntu/jammy64"

  # Forward port 8080 from the VM to port 8080 on the host
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Configure VM resources
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 1
  end

  # Provision using Ansible
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "playbook.yml"
    ansible.verbose = false
    ansible.install = true
    ansible.install_mode = "pip"
  end
end
```

#### Line-by-Line Explanation

**Lines 1-5:** Standard Vagrant config, disable problematic plugin

**Line 8:** Use Ubuntu 22.04 as the base operating system

**Line 11:** Port forwarding
- `guest: 8080` - Port inside the VM
- `host: 8080` - Port on your Windows machine
- Allows you to access `http://localhost:8080` from your browser

**Lines 14-17:** VM resources
- 1GB RAM
- 1 CPU core

**Lines 20-25:** **THE ANSIBLE PROVISIONER** - This is the key!

- `ansible_local` - Run Ansible **inside** the VM (not from host)
- `ansible.playbook = "playbook.yml"` - Which playbook to run
- `ansible.verbose = false` - Don't show excessive output (change to `true` for debugging)
- `ansible.install = true` - Auto-install Ansible if not present
- `ansible.install_mode = "pip"` - Install via Python's pip package manager

**What happens:** When you run `vagrant up`, Vagrant will:
1. Create the VM
2. Install Ansible inside the VM using pip
3. Copy `playbook.yml` and the `roles/` folder to the VM
4. Run `ansible-playbook playbook.yml` inside the VM
5. Ansible configures the VM using the playbook

---

### 2. `ansible.cfg`

```ini
[defaults]
host_key_checking = False
inventory = inventory
```

#### Line-by-Line Explanation

**Section: `[defaults]`**
This is the default configuration section for Ansible.

**`host_key_checking = False`**
- Disables SSH host key verification
- Normally, SSH asks "Are you sure you want to connect?" on first connection
- For local development, we skip this prompt
- **Production:** You'd enable this for security

**`inventory = inventory`**
- Specifies the default inventory file location
- We don't actually use a separate inventory file in this setup
- When using `ansible_local`, Ansible runs against `localhost` automatically
- **Production:** You'd have an inventory file listing all your servers

**Note:** This file is optional for our simple setup, but it's good practice to include it.

---

### 3. `playbook.yml`

```yaml
---
- name: Configure the VM to run a sample app
  hosts: all
  gather_facts: true
  become: true

  roles:
    - sample-app
```

This is the **entry point** - the file Vagrant tells Ansible to run.

#### Line-by-Line Explanation

**`---`**
- YAML files start with three dashes
- Indicates the beginning of a YAML document

**`- name: Configure the VM to run a sample app`**
- `name` is a human-readable description
- Shows up in the output when Ansible runs
- The dash `-` indicates this is a list item (a "play" in Ansible terms)

**`hosts: all`**
- Defines **which servers** to configure
- `all` means "all servers in the inventory"
- In our case with `ansible_local`, this resolves to `localhost`
- **Production example:** `hosts: webservers` would target only servers in the `[webservers]` group

**`gather_facts: true`**
- Tells Ansible to collect information about the target system first
- Facts include: OS type, IP addresses, CPU count, memory, etc.
- Stored in variables like `ansible_distribution`, `ansible_distribution_release`
- We use `ansible_distribution_release` in our tasks (e.g., "jammy" for Ubuntu 22.04)
- **Performance note:** Set to `false` if you don't need facts (faster)

**`become: true`**
- Use privilege escalation (sudo)
- Ansible will run commands as root
- Needed for system tasks like installing packages
- Equivalent to prefixing commands with `sudo`

**`roles:`**
- List of roles to apply
- Roles are executed in order

**`- sample-app`**
- Apply the `sample-app` role
- Ansible looks for `roles/sample-app/` directory
- Executes `roles/sample-app/tasks/main.yml`

---

### 4. `roles/sample-app/tasks/main.yml`

This is where the **actual work** happens!

```yaml
---
# Tasks for installing and running the sample Node.js app

- name: Add NodeSource GPG key
  ansible.builtin.apt_key:
    url: https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key
    state: present

- name: Add NodeSource repository
  ansible.builtin.apt_repository:
    repo: "deb https://deb.nodesource.com/node_lts.x {{ ansible_distribution_release }} main"
    state: present
    filename: nodesource

- name: Update apt cache
  ansible.builtin.apt:
    update_cache: yes

- name: Install Node.js
  ansible.builtin.apt:
    name: nodejs
    state: present

- name: Copy sample app
  ansible.builtin.copy:
    src: app.js
    dest: /home/vagrant/app.js
    owner: vagrant
    group: vagrant
    mode: '0644'

- name: Check if app is already running
  ansible.builtin.shell: pgrep -f "node.*app.js" || true
  register: app_running
  changed_when: false

- name: Start sample app
  ansible.builtin.shell: nohup node /home/vagrant/app.js > /home/vagrant/app.log 2>&1 &
  args:
    chdir: /home/vagrant
  become_user: vagrant
  when: app_running.stdout == ""
```

Let's break down **each task**:

---

#### Task 1: Add NodeSource GPG Key

```yaml
- name: Add NodeSource GPG key
  ansible.builtin.apt_key:
    url: https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key
    state: present
```

**What it does:** Downloads and adds the GPG key for the NodeSource repository.

**Why:** Ubuntu verifies package signatures for security. We need the key to trust packages from NodeSource.

**Module:** `apt_key` - Manages APT repository keys

**Parameters:**
- `url` - Where to download the key from
- `state: present` - Ensure the key exists (install if missing)

**Idempotent?** Yes. If the key already exists, Ansible skips this.

**Equivalent bash command:**
```bash
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo apt-key add -
```

---

#### Task 2: Add NodeSource Repository

```yaml
- name: Add NodeSource repository
  ansible.builtin.apt_repository:
    repo: "deb https://deb.nodesource.com/node_lts.x {{ ansible_distribution_release }} main"
    state: present
    filename: nodesource
```

**What it does:** Adds the NodeSource APT repository to the system.

**Why:** Ubuntu's default repos have an old Node.js version. NodeSource provides the latest LTS.

**Module:** `apt_repository` - Manages APT repositories

**Parameters:**
- `repo` - The repository line to add
  - `{{ ansible_distribution_release }}` - A **Jinja2 variable** (more on this below)
  - On Ubuntu 22.04, this becomes `jammy`
  - Final: `deb https://deb.nodesource.com/node_lts.x jammy main`
- `state: present` - Ensure the repo exists
- `filename: nodesource` - Save to `/etc/apt/sources.list.d/nodesource.list`

**Jinja2 Variables:**
- Ansible uses Jinja2 templating
- `{{ variable_name }}` gets replaced with the actual value
- `ansible_distribution_release` is a **fact** gathered earlier (remember `gather_facts: true`?)

**Idempotent?** Yes. If the repo already exists, Ansible skips this.

**Equivalent bash command:**
```bash
echo "deb https://deb.nodesource.com/node_lts.x jammy main" | sudo tee /etc/apt/sources.list.d/nodesource.list
```

---

#### Task 3: Update APT Cache

```yaml
- name: Update apt cache
  ansible.builtin.apt:
    update_cache: yes
```

**What it does:** Updates the package list from all repositories.

**Why:** After adding a new repo, we need to refresh the package list.

**Module:** `apt` - Manages APT packages

**Parameters:**
- `update_cache: yes` - Run `apt-get update`

**Idempotent?** Mostly. It will run `apt-get update` each time, but this is safe and quick.

**Equivalent bash command:**
```bash
sudo apt-get update
```

---

#### Task 4: Install Node.js

```yaml
- name: Install Node.js
  ansible.builtin.apt:
    name: nodejs
    state: present
```

**What it does:** Installs the Node.js package.

**Module:** `apt` - Manages APT packages

**Parameters:**
- `name: nodejs` - Package name to install
- `state: present` - Ensure it's installed

**Idempotent?** **YES!** This is the key benefit:
- First run: Installs Node.js (status: **changed**)
- Second run: Sees it's already installed (status: **ok**, no change)

**Equivalent bash command:**
```bash
sudo apt-get install -y nodejs
```

But the bash version will download/reinstall even if already present!

---

#### Task 5: Copy Sample App

```yaml
- name: Copy sample app
  ansible.builtin.copy:
    src: app.js
    dest: /home/vagrant/app.js
    owner: vagrant
    group: vagrant
    mode: '0644'
```

**What it does:** Copies `app.js` from the role's `files/` directory to the VM.

**Module:** `copy` - Copies files from control node to managed nodes

**Parameters:**
- `src: app.js` - Source file (relative to `roles/sample-app/files/`)
- `dest: /home/vagrant/app.js` - Destination path on the VM
- `owner: vagrant` - Set file owner
- `group: vagrant` - Set file group
- `mode: '0644'` - Set permissions (read/write for owner, read for others)

**Idempotent?** **YES!** Ansible:
1. Checks if the file exists
2. Compares checksums (MD5/SHA)
3. Only copies if different or missing

**Note:** The `src` path is relative to `roles/sample-app/files/` because that's where Ansible looks for files in a role.

**Equivalent bash commands:**
```bash
sudo cp app.js /home/vagrant/app.js
sudo chown vagrant:vagrant /home/vagrant/app.js
sudo chmod 0644 /home/vagrant/app.js
```

---

#### Task 6: Check If App Is Already Running

```yaml
- name: Check if app is already running
  ansible.builtin.shell: pgrep -f "node.*app.js" || true
  register: app_running
  changed_when: false
```

**What it does:** Checks if the Node.js app is already running.

**Module:** `shell` - Runs shell commands (use when `command` module isn't enough)

**Parameters:**
- `pgrep -f "node.*app.js"` - Search for process matching the pattern
  - Returns process ID if found
  - Returns empty if not found
  - `|| true` ensures the command always exits with success (even if no process found)
- `register: app_running` - **Store the result in a variable**
  - We can use this variable in later tasks
  - `app_running.stdout` will contain the output (process ID or empty string)
- `changed_when: false` - Tell Ansible this task doesn't change anything
  - It's just a check/query
  - Prevents Ansible from reporting this as a "change"

**Why `|| true`?**
Without it, if `pgrep` finds no processes, it exits with code 1 (error), and Ansible would fail the task.

**Variable `app_running` contains:**
```json
{
  "stdout": "12345",        // Process ID if running, or ""
  "stderr": "",
  "rc": 0,                  // Return code
  "changed": false
}
```

---

#### Task 7: Start Sample App

```yaml
- name: Start sample app
  ansible.builtin.shell: nohup node /home/vagrant/app.js > /home/vagrant/app.log 2>&1 &
  args:
    chdir: /home/vagrant
  become_user: vagrant
  when: app_running.stdout == ""
```

**What it does:** Starts the Node.js app if it's not already running.

**Module:** `shell` - Runs shell commands

**Command breakdown:**
- `nohup` - Run process immune to hangups (keeps running after SSH disconnect)
- `node /home/vagrant/app.js` - Start the Node.js app
- `> /home/vagrant/app.log` - Redirect stdout to log file
- `2>&1` - Redirect stderr to stdout (both go to log file)
- `&` - Run in background

**Parameters:**
- `args: chdir: /home/vagrant` - Change to this directory before running
- `become_user: vagrant` - Run as the `vagrant` user (not root)
- `when: app_running.stdout == ""` - **CONDITIONAL EXECUTION**
  - Only run if `app_running.stdout` is empty
  - This is our **idempotency** mechanism for starting the app!

**Idempotent?** **YES**, thanks to the `when` condition:
- First run: App not running, so `app_running.stdout == ""` is true → starts app
- Second run: App is running, so `app_running.stdout == "12345"` (PID) → skips task

**Equivalent bash commands:**
```bash
cd /home/vagrant
su - vagrant -c "nohup node /home/vagrant/app.js > /home/vagrant/app.log 2>&1 &"
```

---

### 5. `roles/sample-app/files/app.js`

```javascript
const http = require('http');

const server = http.createServer((req, res) => {
  res.writeHead(200, { 'Content-Type': 'text/plain' });
  res.end('Hello, World!\n');
});

const port = process.env.PORT || 8080;
server.listen(port, () => {
  console.log(`Listening on port ${port}`);
});
```

This is just a simple Node.js HTTP server. Nothing Ansible-specific here.

**What it does:**
- Creates an HTTP server
- Responds with "Hello, World!" to any request
- Listens on port 8080 (or `PORT` environment variable)
- Logs when it starts

---

## How It All Works Together

### The Execution Flow

1. **You run:** `vagrant up`

2. **Vagrant:**
   - Creates Ubuntu VM
   - Forwards port 8080
   - Installs Ansible inside VM (via pip)
   - Copies `playbook.yml` and `roles/` to `/vagrant` in the VM
   - Runs: `ansible-playbook /vagrant/playbook.yml`

3. **Ansible starts:**
   - Reads `ansible.cfg` for configuration
   - Reads `playbook.yml` for what to do

4. **Playbook execution:**
   - **Play:** "Configure the VM to run a sample app"
   - **Targets:** `all` hosts (localhost in our case)
   - **Gather facts:** Collects system info (OS, distribution, etc.)
   - **Become:** Enable sudo
   - **Apply role:** `sample-app`

5. **Role `sample-app` execution:**
   - Reads `roles/sample-app/tasks/main.yml`
   - Executes each task in order:
     1. ✓ Add GPG key
     2. ✓ Add NodeSource repo
     3. ✓ Update apt cache
     4. ✓ Install Node.js
     5. ✓ Copy app.js
     6. ✓ Check if app running (not running → empty string)
     7. ✓ Start app (condition met, so it runs)

6. **App is running:**
   - Node.js server listening on port 8080
   - Port forwarding makes it accessible at `http://localhost:8080`

7. **You access:** `http://localhost:8080` → See "Hello, World!"

---

## YAML Syntax Primer

YAML (YAML Ain't Markup Language) is human-readable data serialization.

### Basic Syntax

```yaml
# Comments start with #

# Key-value pairs
key: value
name: sample-app

# Lists (arrays)
items:
  - first
  - second
  - third

# Or inline
items: [first, second, third]

# Dictionaries (objects)
person:
  name: John
  age: 30

# Lists of dictionaries
tasks:
  - name: Task 1
    action: do_something
  - name: Task 2
    action: do_another
```

### Ansible-Specific YAML

```yaml
# A task
- name: Install nginx          # Human description
  apt:                          # Module name
    name: nginx                 # Module parameter
    state: present              # Module parameter

# Multiple tasks
- name: Task 1
  module_name:
    param: value

- name: Task 2
  another_module:
    param: value
```

### Important YAML Rules

1. **Indentation matters!** (use 2 spaces, not tabs)
   ```yaml
   # Correct
   tasks:
     - name: Task
       apt:
         name: nginx

   # Wrong (inconsistent indentation)
   tasks:
    - name: Task
      apt:
       name: nginx
   ```

2. **Dashes `-` indicate list items**
   ```yaml
   # This is a list of 3 tasks
   - task1
   - task2
   - task3
   ```

3. **Quotes for special characters**
   ```yaml
   # Not needed for simple values
   name: nodejs

   # Needed for special chars
   command: "echo 'hello' | grep hello"
   ```

4. **Booleans**
   ```yaml
   # All these mean "true"
   enabled: true
   enabled: yes
   enabled: True
   enabled: on

   # All these mean "false"
   enabled: false
   enabled: no
   enabled: False
   enabled: off
   ```

---

## Advanced Ansible Concepts in Our Example

### 1. Variables

We use `{{ ansible_distribution_release }}`:

```yaml
repo: "deb https://deb.nodesource.com/node_lts.x {{ ansible_distribution_release }} main"
```

This is a **fact** (automatic variable) collected by `gather_facts: true`.

**All available facts:**
```bash
# SSH into VM and run:
ansible localhost -m setup
```

This shows hundreds of facts like:
- `ansible_distribution` → "Ubuntu"
- `ansible_distribution_release` → "jammy"
- `ansible_processor_cores` → 1
- `ansible_memtotal_mb` → 1024

### 2. Registered Variables

We create our own variable:

```yaml
register: app_running
```

This stores the task result for later use.

**Using it:**
```yaml
when: app_running.stdout == ""
```

### 3. Conditionals

The `when` directive:

```yaml
when: app_running.stdout == ""
```

**Operators you can use:**
- `==` - Equals
- `!=` - Not equals
- `>`, `<`, `>=`, `<=` - Comparisons
- `and`, `or`, `not` - Logic
- `in` - Membership

**Examples:**
```yaml
when: ansible_distribution == "Ubuntu"
when: ansible_memtotal_mb >= 1024
when: app_running.stdout != "" and env == "production"
```

### 4. Module Parameters

Each module has different parameters. Examples:

**apt module:**
```yaml
- name: Install package
  apt:
    name: nginx           # Package name
    state: present        # present, absent, latest
    update_cache: yes     # Run apt-get update first
```

**copy module:**
```yaml
- name: Copy file
  copy:
    src: myfile.txt       # Source (on control node)
    dest: /tmp/myfile.txt # Destination (on managed node)
    owner: vagrant        # File owner
    group: vagrant        # File group
    mode: '0644'          # Permissions (octal)
```

**shell module:**
```yaml
- name: Run command
  shell: echo "Hello" > /tmp/hello.txt
  args:
    chdir: /tmp           # Run in this directory
    creates: /tmp/hello.txt  # Skip if this file exists
```

---

## Testing and Debugging

### Run with Verbose Output

Change in Vagrantfile:
```ruby
ansible.verbose = true     # or "v", "vv", "vvv" for more detail
```

Or run manually:
```bash
vagrant ssh
cd /vagrant
ansible-playbook playbook.yml -v   # -v, -vv, -vvv, or -vvvv
```

### Check Mode (Dry Run)

See what would change without changing it:
```bash
ansible-playbook playbook.yml --check
```

### Run Specific Tasks

Using tags (you'd add tags to tasks first):
```yaml
- name: Install Node.js
  apt:
    name: nodejs
    state: present
  tags: [nodejs, install]
```

Then run:
```bash
ansible-playbook playbook.yml --tags nodejs
```

### View All Facts

```bash
vagrant ssh
ansible localhost -m setup | less
```

---

## Idempotency in Practice

### Test It Yourself

**First run:**
```bash
vagrant up
```

Output will show **"changed"** for most tasks.

**Second run:**
```bash
vagrant provision
```

Output will show **"ok"** for most tasks (no changes needed).

**What you'll see:**

```
TASK [sample-app : Add NodeSource GPG key] *****
ok: [default]                              # ← Was "changed", now "ok"

TASK [sample-app : Install Node.js] *****
ok: [default]                              # ← Already installed, no change

TASK [sample-app : Copy sample app] *****
ok: [default]                              # ← File unchanged, no copy

TASK [sample-app : Start sample app] *****
skipping: [default]                        # ← App running, condition false
```

This is the power of idempotency!

---

## Common Pitfalls & Best Practices

### ❌ Don't: Use `shell` for everything

```yaml
# Bad - not idempotent
- name: Install nginx
  shell: apt-get install -y nginx
```

### ✅ Do: Use modules when available

```yaml
# Good - idempotent, cross-platform
- name: Install nginx
  apt:
    name: nginx
    state: present
```

### ❌ Don't: Hardcode values

```yaml
# Bad - only works on Ubuntu 22.04
repo: "deb https://deb.nodesource.com/node_lts.x jammy main"
```

### ✅ Do: Use variables

```yaml
# Good - works on all Ubuntu versions
repo: "deb https://deb.nodesource.com/node_lts.x {{ ansible_distribution_release }} main"
```

### ❌ Don't: Forget to check if things are already done

```yaml
# Bad - always tries to start, causes errors if running
- name: Start app
  shell: nohup node app.js &
```

### ✅ Do: Check state first

```yaml
# Good - check first, conditionally start
- name: Check if running
  shell: pgrep -f "node.*app.js" || true
  register: app_running
  changed_when: false

- name: Start app
  shell: nohup node app.js &
  when: app_running.stdout == ""
```

---

## Summary

### What You Learned

1. **Ansible Architecture:**
   - Control node, managed nodes, inventory, playbooks, tasks, modules, roles

2. **File Structure:**
   - `Vagrantfile` - Triggers Ansible
   - `playbook.yml` - Entry point, applies roles
   - `roles/sample-app/tasks/main.yml` - The actual work
   - `roles/sample-app/files/app.js` - Files to deploy

3. **Key Concepts:**
   - **Declarative** - Describe desired state, not steps
   - **Idempotent** - Safe to run multiple times
   - **Modules** - Reusable building blocks
   - **Roles** - Organize related tasks

4. **YAML Syntax:**
   - Indentation matters (2 spaces)
   - Dashes for lists
   - Key-value pairs for dictionaries

5. **Advanced Features:**
   - Variables (facts and registered)
   - Conditionals (`when`)
   - Modules with parameters

### Why Ansible > Bash

| Feature | Bash Script | Ansible |
|---------|-------------|---------|
| **Idempotency** | Manual checks needed | Built-in |
| **Readability** | Commands | Human-readable YAML |
| **Error Handling** | Manual | Automatic |
| **Cross-platform** | OS-specific commands | Modules abstract OS differences |
| **Reusability** | Copy-paste | Roles and includes |
| **State Checking** | Manual | Automatic |

---

## Next Steps

Now that you understand how Ansible works:

1. **Try it:**
   ```bash
   cd ch2/ansible
   vagrant up
   ```

2. **Test idempotency:**
   ```bash
   vagrant provision
   ```
   Notice how it's faster and shows "ok" instead of "changed"

3. **Experiment:**
   - Change `app.js` and run `vagrant provision`
   - Add a new task to install another package
   - Try running with `-v` for verbose output

4. **Compare:**
   - Look at `ch2/bash/provision.sh`
   - See how the same outcome requires imperative bash commands
   - Notice bash doesn't have idempotency

You now have a solid foundation in Ansible!
