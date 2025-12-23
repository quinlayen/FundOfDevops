#!/bin/bash
# This script provisions a VM with Node.js and runs the sample app
# Equivalent to user-data.sh in the AWS example

set -e

echo "Starting provisioning..."

# Update package lists
apt-get update

# Install Node.js (using NodeSource repository for latest LTS)
echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -y nodejs

# Verify installation
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

# Create the sample app
echo "Creating sample app..."
cat > /home/vagrant/app.js <<'EOF'
const http = require('http');

const PORT = process.env.PORT || 8080;

const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'text/plain'});
  res.end('Hello, World!\n');
});

server.listen(PORT, () => {
  console.log(`Server is listening on port ${PORT}`);
});
EOF

# Set ownership
chown vagrant:vagrant /home/vagrant/app.js

# Run the app in the background
echo "Starting the app..."
su - vagrant -c "nohup node /home/vagrant/app.js > /home/vagrant/app.log 2>&1 &"

echo "Provisioning complete! App is running on port 8080"
