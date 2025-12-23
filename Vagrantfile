Vagrant.configure("2") do |config|
  # Disable vbguest plugin to avoid compatibility issues
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  # Use Ubuntu 22.04 LTS as the base box
  config.vm.box = "ubuntu/jammy64"

  # Forward port 8080 from the VM to port 8080 on the host
  config.vm.network "forwarded_port", guest: 8080, host: 8080

  # Sync the current directory to /vagrant in the VM
  config.vm.synced_folder ".", "/vagrant"

  # Configure VM resources
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "1024"
    vb.cpus = 1
  end

  # Provision the VM
  config.vm.provision "shell", inline: <<-SHELL
    # Update package lists
    apt-get update

    # Install Node.js (using NodeSource repository for latest LTS)
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
    apt-get install -y nodejs

    # Verify installation
    echo "Node.js version: $(node --version)"
    echo "npm version: $(npm --version)"

    # Navigate to the app directory
    cd /vagrant

    # Install dependencies (if any in the future)
    npm install

    # Create a systemd service to run the app
    cat > /etc/systemd/system/sample-app.service <<EOF
[Unit]
Description=Sample Node.js App
After=network.target

[Service]
Type=simple
User=vagrant
WorkingDirectory=/vagrant
ExecStart=/usr/bin/node /vagrant/app.js
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

    # Enable and start the service
    systemctl daemon-reload
    systemctl enable sample-app
    systemctl start sample-app

    echo "Sample app is now running on port 8080"
    echo "Access it at http://localhost:8080 from your host machine"
  SHELL
end
