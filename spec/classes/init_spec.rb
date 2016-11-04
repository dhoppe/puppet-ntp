require 'spec_helper'

describe 'ntp', type: :class do
  ['Debian'].each do |osfamily|
    let(:facts) do
      {
        osfamily: osfamily,
        operatingsystem: 'Debian',
        is_virtual: true
      }
    end

    it { is_expected.to compile.with_all_deps }
    it { is_expected.to contain_anchor('ntp::begin') }
    it { is_expected.to contain_class('ntp::params') }
    it { is_expected.to contain_class('ntp::install') }
    it { is_expected.to contain_class('ntp::config') }
    it { is_expected.to contain_class('ntp::service') }
    it { is_expected.to contain_anchor('ntp::end') }

    context "on #{osfamily}" do
      describe 'ntp::install' do
        context 'defaults' do
          it do
            is_expected.to contain_package('ntp').with(
              'ensure' => 'present'
            )
          end
        end

        context 'when package latest' do
          let(:params) do
            {
              package_ensure: 'latest'
            }
          end

          it do
            is_expected.to contain_package('ntp').with(
              'ensure' => 'latest'
            )
          end
        end

        context 'when package absent' do
          let(:params) do
            {
              package_ensure: 'absent',
              service_ensure: 'stopped',
              service_enable: false
            }
          end

          it do
            is_expected.to contain_package('ntp').with(
              'ensure' => 'absent'
            )
          end
          it do
            is_expected.to contain_file('ntp.conf').with(
              'ensure'  => 'present',
              'notify'  => 'Service[ntp]',
              'require' => 'Package[ntp]'
            )
          end
          it do
            is_expected.to contain_service('ntp').with(
              'ensure' => 'stopped',
              'enable' => false
            )
          end
        end

        context 'when package purged' do
          let(:params) do
            {
              package_ensure: 'purged',
              service_ensure: 'stopped',
              service_enable: false
            }
          end

          it do
            is_expected.to contain_package('ntp').with(
              'ensure' => 'purged'
            )
          end
          it do
            is_expected.to contain_file('ntp.conf').with(
              'ensure'  => 'absent',
              'notify'  => 'Service[ntp]',
              'require' => 'Package[ntp]'
            )
          end
          it do
            is_expected.to contain_service('ntp').with(
              'ensure' => 'stopped',
              'enable' => false
            )
          end
        end
      end

      describe 'ntp::config' do
        context 'defaults' do
          it do
            is_expected.to contain_file('ntp.conf').with(
              'ensure'  => 'present',
              'notify'  => 'Service[ntp]',
              'require' => 'Package[ntp]'
            )
          end
        end

        context 'when source dir' do
          let(:params) do
            {
              config_dir_source: 'puppet:///modules/ntp/Debian/etc'
            }
          end

          it do
            is_expected.to contain_file('ntp.dir').with(
              'ensure'  => 'directory',
              'force'   => false,
              'purge'   => false,
              'recurse' => true,
              'source'  => 'puppet:///modules/ntp/Debian/etc',
              'notify'  => 'Service[ntp]',
              'require' => 'Package[ntp]'
            )
          end
        end

        context 'when source dir purged' do
          let(:params) do
            {
              config_dir_purge: true,
              config_dir_source: 'puppet:///modules/ntp/Debian/etc'
            }
          end

          it do
            is_expected.to contain_file('ntp.dir').with(
              'ensure'  => 'directory',
              'force'   => true,
              'purge'   => true,
              'recurse' => true,
              'source'  => 'puppet:///modules/ntp/Debian/etc',
              'notify'  => 'Service[ntp]',
              'require' => 'Package[ntp]'
            )
          end
        end

        context 'when source file' do
          let(:params) do
            {
              config_file_source: 'puppet:///modules/ntp/Debian/etc/ntp.conf'
            }
          end

          it do
            is_expected.to contain_file('ntp.conf').with(
              'ensure'  => 'present',
              'source'  => 'puppet:///modules/ntp/Debian/etc/ntp.conf',
              'notify'  => 'Service[ntp]',
              'require' => 'Package[ntp]'
            )
          end
        end

        context 'when content string' do
          let(:params) do
            {
              config_file_string: '# THIS FILE IS MANAGED BY PUPPET'
            }
          end

          it do
            is_expected.to contain_file('ntp.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'notify'  => 'Service[ntp]',
              'require' => 'Package[ntp]'
            )
          end
        end

        context 'when content template' do
          let(:params) do
            {
              config_file_template: 'ntp/Debian/etc/ntp.conf.erb'
            }
          end

          it do
            is_expected.to contain_file('ntp.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'notify'  => 'Service[ntp]',
              'require' => 'Package[ntp]'
            )
          end
        end

        context 'when content template (custom)' do
          let(:params) do
            {
              config_file_template: 'ntp/Debian/etc/ntp.conf.erb',
              config_file_options_hash: {
                'key' => 'value'
              }
            }
          end

          it do
            is_expected.to contain_file('ntp.conf').with(
              'ensure'  => 'present',
              'content' => %r{THIS FILE IS MANAGED BY PUPPET},
              'notify'  => 'Service[ntp]',
              'require' => 'Package[ntp]'
            )
          end
        end
      end

      describe 'ntp::service' do
        context 'defaults' do
          it do
            is_expected.to contain_service('ntp').with(
              'ensure' => 'running',
              'enable' => true
            )
          end
        end

        context 'when service stopped' do
          let(:params) do
            {
              service_ensure: 'stopped'
            }
          end

          it do
            is_expected.to contain_service('ntp').with(
              'ensure' => 'stopped',
              'enable' => true
            )
          end
        end
      end
    end
  end
end
