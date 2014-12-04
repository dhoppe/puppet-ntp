# ntp

[![Build Status](https://travis-ci.org/dhoppe/puppet-ntp.png?branch=master)](https://travis-ci.org/dhoppe/puppet-ntp)
[![Puppet Forge](https://img.shields.io/puppetforge/v/dhoppe/ntp.svg)](https://forge.puppetlabs.com/dhoppe/ntp)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with ntp](#setup)
    * [What ntp affects](#what-ntp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with ntp](#beginning-with-ntp)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
6. [Limitations - OS compatibility, etc.](#limitations)
7. [Development - Guide for contributing to the module](#development)

## Overview

This module installs, configures and manages the NTP service.

## Module Description

This module handles installing, configuring and running NTP across a range of operating systems and distributions.

## Setup

### What ntp affects

* ntp package.
* ntp configuration file.
* ntp service.

### Setup Requirements

* Puppet >= 2.7
* Facter >= 1.6
* [Stdlib module](https://github.com/puppetlabs/puppetlabs-stdlib)

### Beginning with ntp

Install ntp with the default parameters ***(No configuration files will be changed)***.

```puppet
    class { 'ntp': }
```

Install ntp with the recommended parameters.

#### Standalone setup

```puppet
    class { 'ntp':
      config_file_template => "ntp/${::operatingsystem}/etc/ntp.conf.erb",
    }
```

#### Client/Server setup (client)

```puppet
    class { 'ntp':
      config_file_template => "ntp/${::operatingsystem}/etc/ntp.conf.erb",
      server_internal      => [
        "ntp1.${::domain}",
        "ntp2.${::domain}",
      ],
    }
```

#### Client/Server setup (server)

```puppet
    class { 'ntp':
      config_file_template => "ntp/${::operatingsystem}/etc/ntp-server.conf.erb",
      server_internal      => [
        "ntp1.${::domain}",
        "ntp2.${::domain}",
      ],
    }
```

## Usage

Update the ntp package.

```puppet
    class { 'ntp':
      package_ensure => 'latest',
    }
```

Remove the ntp package.

```puppet
    class { 'ntp':
      package_ensure => 'absent',
    }
```

Purge the ntp package ***(All configuration files will be removed)***.

```puppet
    class { 'ntp':
      package_ensure => 'purged',
    }
```

Deploy the configuration files from source directory.

```puppet
    class { 'ntp':
      config_dir_source => "puppet:///modules/ntp/${::operatingsystem}/etc",
    }
```

Deploy the configuration files from source directory ***(Unmanaged configuration files will be removed)***.

```puppet
    class { 'ntp':
      config_dir_purge  => true,
      config_dir_source => "puppet:///modules/ntp/${::operatingsystem}/etc",
    }
```

Deploy the configuration file from source.

```puppet
    class { 'ntp':
      config_file_source => "puppet:///modules/ntp/${::operatingsystem}/etc/ntp.conf",
    }
```

Deploy the configuration file from string.

```puppet
    class { 'ntp':
      config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
    }
```

Deploy the configuration file from template.

```puppet
    class { 'ntp':
      config_file_template => "ntp/${::operatingsystem}/etc/ntp.conf.erb",
    }
```

Deploy the configuration file from custom template ***(Additional parameters can be defined)***.

```puppet
    class { 'ntp':
      config_file_template     => "ntp/${::operatingsystem}/etc/ntp.conf.erb",
      config_file_options_hash => {
        'key' => 'value',
      },
    }
```

Deploy additional configuration files from source, string or template.

```puppet
    class { 'ntp':
      config_file_hash => {
        'ntp.2nd.conf' => {
          config_file_path   => '/etc/ntp.2nd.conf',
          config_file_source => "puppet:///modules/ntp/${::operatingsystem}/etc/ntp.2nd.conf",
        },
        'ntp.3rd.conf' => {
          config_file_path   => '/etc/ntp.3rd.conf',
          config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
        },
        'ntp.4th.conf' => {
          config_file_path     => '/etc/ntp.4th.conf',
          config_file_template => "ntp/${::operatingsystem}/etc/ntp.4th.conf.erb",
        },
      },
    }
```

Disable the ntp service.

```puppet
    class { 'ntp':
      service_ensure => 'stopped',
    }
```

## Reference

### Classes

#### Public Classes

* ntp: Main class, includes all other classes.

#### Private Classes

* ntp::install: Handles the packages.
* ntp::config: Handles the configuration file.
* ntp::service: Handles the service.

### Parameters

#### `package_ensure`

Determines if the package should be installed. Valid values are 'present', 'latest', 'absent' and 'purged'. Defaults to 'present'.

#### `package_name`

Determines the name of package to manage. Defaults to 'ntp'.

#### `package_list`

Determines if additional packages should be managed. Defaults to 'undef'.

#### `config_dir_ensure`

Determines if the configuration directory should be present. Valid values are 'absent' and 'directory'. Defaults to 'directory'.

#### `config_dir_path`

Determines if the configuration directory should be managed. Defaults to '/etc'

#### `config_dir_purge`

Determines if unmanaged configuration files should be removed. Valid values are 'true' and 'false'. Defaults to 'false'.

#### `config_dir_recurse`

Determines if the configuration directory should be recursively managed. Valid values are 'true' and 'false'. Defaults to 'true'.

#### `config_dir_source`

Determines the source of a configuration directory. Defaults to 'undef'.

#### `config_file_ensure`

Determines if the configuration file should be present. Valid values are 'absent' and 'present'. Defaults to 'present'.

#### `config_file_path`

Determines if the configuration file should be managed. Defaults to '/etc/ntp.conf'

#### `config_file_owner`

Determines which user should own the configuration file. Defaults to 'root'.

#### `config_file_group`

Determines which group should own the configuration file. Defaults to 'root'.

#### `config_file_mode`

Determines the desired permissions mode of the configuration file. Defaults to '0644'.

#### `config_file_source`

Determines the source of a configuration file. Defaults to 'undef'.

#### `config_file_string`

Determines the content of a configuration file. Defaults to 'undef'.

#### `config_file_template`

Determines the content of a configuration file. Defaults to 'undef'.

#### `config_file_notify`

Determines if the service should be restarted after configuration changes. Defaults to 'Service[ntp]'.

#### `config_file_require`

Determines which package a configuration file depends on. Defaults to 'Package[ntp]'.

#### `config_file_hash`

Determines which configuration files should be managed via `ntp::define`. Defaults to '{}'.

#### `config_file_options_hash`

Determines which parameters should be passed to an ERB template. Defaults to '{}'.

#### `service_ensure`

Determines if the service should be running or not. Valid values are 'running' and 'stopped'. Defaults to 'running'.

#### `service_name`

Determines the name of service to manage. Defaults to 'ntp'.

#### `service_enable`

Determines if the service should be enabled at boot. Valid values are 'true' and 'false'. Defaults to 'true'.

#### `server_external`

Determines which hosts should be used as synchronization source (external). Defaults to '["0.${::operatingsystem}.pool.ntp.org", "1.${::operatingsystem}.pool.ntp.org", "2.${::operatingsystem}.pool.ntp.org", "3.${::operatingsystem}.pool.ntp.org"]'.

#### `server_internal`

Determines which hosts should be used as synchronization source (internal). If more than one internal NTP server is used, they begin to synchronize with each other. Defaults to 'undef'.

## Limitations

This module has been tested on:

* Debian 6/7
* Ubuntu 12.04/14.04

## Development

### Bug Report

If you find a bug, have trouble following the documentation or have a question about this module - please create an issue.

### Pull Request

If you are able to patch the bug or add the feature yourself - please make a pull request.

### Contributors

The list of contributors can be found at: [https://github.com/dhoppe/puppet-ntp/graphs/contributors](https://github.com/dhoppe/puppet-ntp/graphs/contributors)
