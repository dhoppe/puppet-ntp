# == Class: ntp::params
#
class ntp::params {
  $package_name = $::osfamily ? {
    default => 'ntp',
  }

  $package_list = $::osfamily ? {
    default => undef,
  }

  $config_dir_path = $::osfamily ? {
    default => '/etc',
  }

  $config_file_path = $::osfamily ? {
    default => '/etc/ntp.conf',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_notify = $::osfamily ? {
    default => 'Service[ntp]',
  }

  $config_file_require = $::osfamily ? {
    default => 'Package[ntp]',
  }

  $service_name = $::osfamily ? {
    default => 'ntp',
  }

  case $::osfamily {
    'Debian': {
    }
    default: {
      fail("${::operatingsystem} not supported.")
    }
  }
}
