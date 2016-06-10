class flocker::params {

  $install_cli             = false
  $flocker_version         = ''
  $flocker_controller      = ''
  $flocker_controller_fqdn = ''
  $flocker_host            = $::hostname 
  $yml_version             = ''
  $storage_backend         = ''
  $region                  = ''
  $zone                    = ''
  $access_key_id           = ''
  $secret_access_key       = ''
  $auth_plugin             = ''
  $username                = ''
  $api_key                 = ''
  $auth_url                = ''
  $gce_project             = ''
  $gce_blob                = ''
}