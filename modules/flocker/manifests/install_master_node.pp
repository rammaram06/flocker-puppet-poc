class flocker::install_master_node {
 
  file { '/etc/flocker':
    ensure => 'directory',
    mode   => '0700',
    } ->

  file { '/etc/flocker/cluster.crt':
    ensure  => present,
    content => template('flocker/cluster.crt.erb'),
    mode    => '0700',
    } ->

  file { '/etc/flocker/control-service.crt':
    ensure  => present,
    content => template('flocker/control-service.crt.erb'),
    mode    => '0700',
    } ->

  file { '/etc/flocker/plugin.crt':
    ensure  => present,
    content => template('flocker/plugin.crt.erb'),
    mode    => '0700',
    } ->  

   file { '/etc/flocker/plugin.key':
    ensure  => present,
    content => template('flocker/plugin.key.erb'),
    mode    => '0700',
    } ->    
  
  file { '/etc/flocker/control-service.key':
    ensure  => present,
    content => template('flocker/control-service.key.erb'),
    mode    => '0600',
    } ->

  case $::hostname {
    'flocker-01': {
      file { '/etc/flocker/node.crt':
        ensure  => present,
        source  => 'puppet:///modules/flocker/6165821d-4463-4095-98fa-7b0652d03e6d.crt',
        mode    => '0700', 
        }
      } 
   default: {
      file { '/etc/flocker/node.crt':
        ensure  => present,
        source  => 'puppet:///modules/flocker/eab4f88a-40b5-4b07-a19e-bed3093eb47d.crt',
        mode    => '0700', 
      }
    }
  } ->

  
  file { '/etc/flocker/node.key':
    ensure  => present,
    content => template('flocker/node.key.erb'),
    mode    => '0600',
    } ->  
 
  exec { 'flocker-control enable':
    command => 'bash -lc "systemctl enable flocker-control"',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    creates => '/etc/systemd/system/multi-user.target.wants/flocker-control.service'
    } ->

  service { 'flocker-control':
  	enable   => true,
  	ensure   => running,
    provider => systemd
    }

}