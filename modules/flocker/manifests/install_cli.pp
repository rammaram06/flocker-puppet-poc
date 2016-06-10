class flocker::install_cli {

  package { ['gcc', 'libffi-devel', 'openssl-devel'] :
  	ensure => installed,
    before => Class['python']
    }

  class { 'python' :
    version    => 'system',
    pip        => 'present',
    dev        => 'present',
    virtualenv => 'present',
    use_epel   => true,
    }

  python::virtualenv { '/etc/flocker-client' :
	ensure     => present,
	version    => 'system',
	systempkgs => true,
    distribute => false,
	timeout    => '1800',
	require    =>  Class['python']
	} ->

  python::pip { 'flocker-client' :
    ensure        => 'present',
    virtualenv    => '/etc/flocker-client/',
    url           => 'https://clusterhq-archive.s3.amazonaws.com/python/Flocker-1.11.0-py2-none-any.whl',
    timeout       => 1800,
    }

  file { '/etc/profile.d/flocker.sh':
    ensure  => present,
    content => template('flocker/flocker.sh.erb'),
    mode    => '0644',
    }   
}