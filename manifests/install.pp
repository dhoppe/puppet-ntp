# == Class: ntp::install
#
class ntp::install {
  if $::ntp::package_name {
    package { 'ntp':
      ensure => $::ntp::package_ensure,
      name   => $::ntp::package_name,
    }
  }

  if $::ntp::package_list {
    ensure_resource('package', $::ntp::package_list, { 'ensure' => $::ntp::package_ensure })
  }
}
