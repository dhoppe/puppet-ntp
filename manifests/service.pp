# == Class: ntp::service
#
class ntp::service {
  if $::ntp::service_name {
    service { 'ntp':
      ensure     => $::ntp::_service_ensure,
      name       => $::ntp::service_name,
      enable     => $::ntp::_service_enable,
      hasrestart => true,
    }
  }
}
