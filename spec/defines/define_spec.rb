require 'spec_helper'

describe 'ntp::define', type: :define do
  ['Debian'].each do |osfamily|
    let(:facts) do
      {
        osfamily: osfamily,
        operatingsystem: 'Debian',
        is_virtual: true
      }
    end
    let(:pre_condition) { 'include ntp' }
    let(:title) { 'ntp.conf' }

    context "on #{osfamily}" do
      context 'when source file' do
        let(:params) do
          {
            config_file_path: '/etc/ntp.2nd.conf',
            config_file_source: 'puppet:///modules/ntp/Debian/etc/ntp.conf'
          }
        end

        it do
          is_expected.to contain_file('define_ntp.conf').with(
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
            config_file_path: '/etc/ntp.3rd.conf',
            config_file_string: '# THIS FILE IS MANAGED BY PUPPET'
          }
        end

        it do
          is_expected.to contain_file('define_ntp.conf').with(
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
            config_file_path: '/etc/ntp.4th.conf',
            config_file_template: 'ntp/Debian/etc/ntp.conf.erb'
          }
        end

        it do
          is_expected.to contain_file('define_ntp.conf').with(
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
            config_file_path: '/etc/ntp.5th.conf',
            config_file_template: 'ntp/Debian/etc/ntp.conf.erb',
            config_file_options_hash: {
              'key' => 'value'
            }
          }
        end

        it do
          is_expected.to contain_file('define_ntp.conf').with(
            'ensure'  => 'present',
            'content' => %r{THIS FILE IS MANAGED BY PUPPET},
            'notify'  => 'Service[ntp]',
            'require' => 'Package[ntp]'
          )
        end
      end
    end
  end
end
