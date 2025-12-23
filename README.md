# Sample Node.js App - DevOps Fundamentals

This is a simple Node.js "Hello, World" application deployed using Vagrant, following the principles from [Fundamentals of DevOps and Software Delivery](https://books.gruntwork.io/books/fundamentals-of-devops).

## What This Does

Instead of deploying to Render (a PaaS), this setup uses Vagrant to create a local virtual machine that simulates a server environment. This gives you hands-on experience with:

- Setting up a server from scratch
- Installing dependencies (Node.js)
- Running an application as a service
- Understanding the deployment process

## Prerequisites

You need to have installed:
- [Vagrant](https://www.vagrantup.com/downloads)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads) (or another Vagrant provider)

## Quick Start

1. **Start the VM and deploy the app:**
   ```bash
   vagrant up
   ```

   This will:
   - Download Ubuntu 22.04 image (first time only)
   - Create a virtual machine
   - Install Node.js
   - Deploy and start the sample app

2. **Access the application:**

   Open your browser and go to:
   ```
   http://localhost:8080
   ```

   You should see: `Hello, World!`

## Useful Commands

- **Check VM status:**
  ```bash
  vagrant status
  ```

- **SSH into the VM:**
  ```bash
  vagrant ssh
  ```

- **Check if the app is running (inside VM):**
  ```bash
  vagrant ssh -c "systemctl status sample-app"
  ```

- **View app logs (inside VM):**
  ```bash
  vagrant ssh -c "journalctl -u sample-app -f"
  ```

- **Stop the VM:**
  ```bash
  vagrant halt
  ```

- **Restart the VM:**
  ```bash
  vagrant reload
  ```

- **Destroy the VM (clean up):**
  ```bash
  vagrant destroy
  ```

## How It Works

The `Vagrantfile` defines the VM configuration:

1. **Base Image:** Uses Ubuntu 22.04 LTS
2. **Port Forwarding:** Maps port 8080 on the VM to port 8080 on your host machine
3. **Provisioning:** Automatically installs Node.js and sets up the app as a systemd service
4. **Service Management:** The app runs as a background service that starts automatically

## Making Changes

If you modify `app.js`, you can reload the changes:

```bash
vagrant ssh -c "sudo systemctl restart sample-app"
```

Or reprovision the entire VM:

```bash
vagrant provision
```

## Comparison to Render (PaaS)

| Aspect | Render (PaaS) | Vagrant (Local IaaS) |
|--------|---------------|----------------------|
| Setup | Minimal - platform handles infrastructure | Manual - you configure everything |
| Cost | Pay for hosting | Free (runs locally) |
| Learning | Abstracts infrastructure details | Exposes full deployment process |
| Access | Public URL | localhost only |
| Scaling | Easy horizontal scaling | Manual VM management |

This Vagrant approach gives you a deeper understanding of what happens "under the hood" when you deploy to a PaaS like Render.

## Next Steps

After mastering local deployment with Vagrant, you can:
- Deploy to a cloud IaaS provider (AWS EC2, as covered in the book)
- Try deploying to a PaaS like Render for comparison
- Explore containerization with Docker
- Learn about orchestration with Kubernetes

## Troubleshooting

**Port already in use:**
If port 8080 is already in use on your host machine, edit the `Vagrantfile` and change:
```ruby
config.vm.network "forwarded_port", guest: 8080, host: 9090
```

**VM won't start:**
Make sure VirtualBox is installed and running. Check Vagrant status with `vagrant status`.

**Can't access the app:**
SSH into the VM and check the service status:
```bash
vagrant ssh
systemctl status sample-app
```
