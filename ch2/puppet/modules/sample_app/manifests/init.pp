# Sample App Puppet Module
# Installs Node.js and runs the sample app

class sample_app {

  # Ensure puppetlabs-apt module is available (we'll install it in Vagrantfile)
  # This provides apt::key and apt::source resources

  # Add NodeSource GPG key
  apt::key { 'nodesource':
    id     => '9FD3B784BC1C6FC31A8A0A1C1655A098B8219C84',
    source => 'https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key',
  }

  # Add NodeSource repository
  apt::source { 'nodesource':
    location => 'https://deb.nodesource.com/node_lts.x',
    release  => $::lsbdistcodename,
    repos    => 'main',
    key      => {
      'id'     => '9FD3B784BC1C6FC31A8A0A1C1655A098B8219C84',
      'source' => 'https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key',
    },
    require  => Apt::Key['nodesource'],
  }

  # Update apt cache after adding repository
  exec { 'apt_update':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
    subscribe   => Apt::Source['nodesource'],
  }

  # Install Node.js
  package { 'nodejs':
    ensure  => present,
    require => [
      Apt::Source['nodesource'],
      Exec['apt_update'],
    ],
  }

  # Copy the sample app
  file { '/home/vagrant/app.js':
    ensure  => file,
    source  => 'puppet:///modules/sample_app/app.js',
    owner   => 'vagrant',
    group   => 'vagrant',
    mode    => '0644',
    require => Package['nodejs'],
  }

  # Check if app is already running and start it if not
  exec { 'start_sample_app':
    command => '/usr/bin/nohup /usr/bin/node /home/vagrant/app.js > /home/vagrant/app.log 2>&1 &',
    user    => 'vagrant',
    cwd     => '/home/vagrant',
    unless  => '/usr/bin/pgrep -f "node.*app.js"',
    require => [
      Package['nodejs'],
      File['/home/vagrant/app.js'],
    ],
  }
}
