class flocker::install_node (

  $flocker_controller_fqdn = $flocker::flocker_controller_fqdn,
  $yml_version             = $flocker::yml_version,
  $storage_backend         = $flocker::storage_backend,
  $region                  = $flocker::region,
  $zone                    = $flocker::zone, 
  $access_key_id           = $flocker::access_key_id,
  $secret_access_key       = $flocker::secret_access_key,
  $auth_plugin             = $flocker::auth_plugin,
  $username                = $flocker::username,
  $api_key                 = $flocker::api_key,
  $auth_url                = $flocker::auth_url,
  $gce_project             = $flocker::gce_project,
  $gce_blob                = $flocker::gce_blob,
  
  ) {

  file { '/etc/flocker':
    ensure => 'directory',
    mode   => '0700',
    } ->

  file { '/etc/flocker/cluster.crt':
    ensure  => present,
    content => template('flocker/cluster.crt.erb'),
    mode    => '0700',
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

  file { '/etc/flocker/agent.yml':
    ensure  => present,
    content => template('flocker/agent.yml.erb')
    } ->

  exec { 'flocker-dataset-agent enable':
    command => 'bash -lc "systemctl enable flocker-dataset-agent"',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => 'systemctl status flocker-dataset-agent',
    } ->

  service { 'flocker-dataset-agent':
  	enable   => true,
  	ensure   => running,
    }  ->
  
  exec { 'flocker-container-agent enable':
    command => 'bash -lc "systemctl enable flocker-container-agent"',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => 'systemctl status flocker-container-agent',
    } ->

  service { 'flocker-container-agent':
  	enable   => true,
  	ensure   => running,
    }
  
  exec { 'flocker-docker-plugin enable':
    command => 'bash -lc "systemctl enable flocker-docker-plugin"',
    path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
    unless  => 'systemctl status flocker-docker-plugin',
    } ->

  service { 'flocker-docker-plugin.service':
    enable   => true,
    ensure   => running,
  }  
}