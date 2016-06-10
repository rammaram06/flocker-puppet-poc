# Class: flocker
# ===========================
#
# Full description of class flocker here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'flocker':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Author Name <author@domain.com>
#
# Copyright
# ---------
#
# Copyright 2016 Your name here, unless otherwise noted.
#
class flocker (

  $install_cli             = $flocker::params::install_cli,
  $flocker_version         = $flocker::params::flocker_version,
  $flocker_controller      = $flocker::params::flocker_controller,
  $flocker_controller_fqdn = $flocker::params::flocker_controller_fqdn,
  $flocker_host            = $flocker::params::flocker_host, 
  $yml_version             = $flocker::params::yml_version,
  $storage_backend         = $flocker::params::storage_backend,
  $region                  = $flocker::params::region,
  $zone                    = $flocker::params::zone, 
  $access_key_id           = $flocker::params::access_key_id,
  $secret_access_key       = $flocker::params::secret_access_key,
  $auth_plugin             = $flocker::params::auth_plugin,
  $username                = $flocker::params::username,
  $api_key                 = $flocker::params::api_key,
  $auth_url                = $flocker::params::auth_url,
  $gce_project             = $flocker::params::gce_project,
  $gce_blob                = $flocker::params::gce_blob,



) inherits flocker::params {
  
  validate_re($::osfamily, '^(Debian|RedHat)$', 'This module only works on Debian or Red Hat based systems.')
  validate_bool($install_cli)

  if $install_cli { include flocker::install_cli }

   exec { 'flocker repo':
   command => 'yum list installed clusterhq-release || yum install -y https://clusterhq-archive.s3.amazonaws.com/centos/clusterhq-release$(rpm -E %dist).noarch.rpm',
   path    => '/usr/bin:/usr/sbin:/bin:/usr/local/bin',
   creates => '/etc/yum.repos.d/clusterhq.repo',
   } ->
 
  package { ['clusterhq-flocker-node', 'clusterhq-flocker-docker-plugin']:
    ensure => $flocker_version,
    } ->

  case $::hostname {
	"$flocker_controller": {
      include flocker::install_master_node
      }
    default: { 
      include flocker::install_node
      contain flocker::docker_run

      Class['flocker::install_node']-> Class['flocker::docker_run'] 

    }
  }
}  
