# == Class: ntp
#
class ntp (
  $package_ensure           = 'present',
  $package_name             = $::ntp::params::package_name,
  $package_list             = $::ntp::params::package_list,

  $config_dir_path          = $::ntp::params::config_dir_path,
  $config_dir_purge         = false,
  $config_dir_recurse       = true,
  $config_dir_source        = undef,

  $config_file_path         = $::ntp::params::config_file_path,
  $config_file_owner        = $::ntp::params::config_file_owner,
  $config_file_group        = $::ntp::params::config_file_group,
  $config_file_mode         = $::ntp::params::config_file_mode,
  $config_file_source       = undef,
  $config_file_string       = undef,
  $config_file_template     = undef,

  $config_file_notify       = $::ntp::params::config_file_notify,
  $config_file_require      = $::ntp::params::config_file_require,

  $config_file_hash         = {},
  $config_file_options_hash = {},

  $service_ensure           = 'running',
  $service_name             = $::ntp::params::service_name,
  $service_enable           = true,

  $server_external          = [
    "0.${::operatingsystem}.pool.ntp.org",
    "1.${::operatingsystem}.pool.ntp.org",
    "2.${::operatingsystem}.pool.ntp.org",
    "3.${::operatingsystem}.pool.ntp.org",
  ],
  $server_internal          = undef,
) inherits ::ntp::params {
  validate_re($package_ensure, '^(absent|latest|present|purged)$')
  validate_string($package_name)
  if $package_list { validate_array($package_list) }

  validate_absolute_path($config_dir_path)
  validate_bool($config_dir_purge)
  validate_bool($config_dir_recurse)
  if $config_dir_source { validate_string($config_dir_source) }

  validate_absolute_path($config_file_path)
  validate_string($config_file_owner)
  validate_string($config_file_group)
  validate_string($config_file_mode)
  if $config_file_source { validate_string($config_file_source) }
  if $config_file_string { validate_string($config_file_string) }
  if $config_file_template { validate_string($config_file_template) }

  validate_string($config_file_notify)
  validate_string($config_file_require)

  validate_hash($config_file_hash)
  validate_hash($config_file_options_hash)

  validate_re($service_ensure, '^(running|stopped)$')
  validate_string($service_name)
  validate_bool($service_enable)

  $config_file_content = default_content($config_file_string, $config_file_template)

  if $config_file_hash {
    create_resources('ntp::define', $config_file_hash)
  }

  if $package_ensure == 'absent' {
    $config_dir_ensure  = 'directory'
    $config_file_ensure = 'present'
    $_service_ensure    = 'stopped'
    $_service_enable    = false
  } elsif $package_ensure == 'purged' {
    $config_dir_ensure  = 'absent'
    $config_file_ensure = 'absent'
    $_service_ensure    = 'stopped'
    $_service_enable    = false
  } else {
    $config_dir_ensure  = 'directory'
    $config_file_ensure = 'present'
    $_service_ensure    = $service_ensure
    $_service_enable    = $service_enable
  }

  validate_re($config_dir_ensure, '^(absent|directory)$')
  validate_re($config_file_ensure, '^(absent|present)$')

  anchor { 'ntp::begin': } ->
  class { '::ntp::install': } ->
  class { '::ntp::config': } ~>
  class { '::ntp::service': } ->
  anchor { 'ntp::end': }
}
