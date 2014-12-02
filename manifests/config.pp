# == Class: ntp::config
#
class ntp::config {
  if $::ntp::config_dir_source {
    file { 'ntp.dir':
      ensure  => $::ntp::config_dir_ensure,
      path    => $::ntp::config_dir_path,
      force   => $::ntp::config_dir_purge,
      purge   => $::ntp::config_dir_purge,
      recurse => $::ntp::config_dir_recurse,
      source  => $::ntp::config_dir_source,
      notify  => $::ntp::config_file_notify,
      require => $::ntp::config_file_require,
    }
  }

  if $::ntp::config_file_path {
    file { 'ntp.conf':
      ensure  => $::ntp::config_file_ensure,
      path    => $::ntp::config_file_path,
      owner   => $::ntp::config_file_owner,
      group   => $::ntp::config_file_group,
      mode    => $::ntp::config_file_mode,
      source  => $::ntp::config_file_source,
      content => $::ntp::config_file_content,
      notify  => $::ntp::config_file_notify,
      require => $::ntp::config_file_require,
    }
  }
}
