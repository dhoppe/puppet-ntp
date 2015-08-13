require 'spec_helper'

describe 'ntp::define', :type => :define do
  ['Debian'].each do |osfamily|
    let(:facts) {{
      :osfamily        => osfamily,
      :operatingsystem => 'Debian',
      :is_virtual      => true,
    }}
    let(:pre_condition) { 'include ntp' }
    let(:title) { 'ntp.conf' }

    context "on #{osfamily}" do
      context 'when source file' do
        let(:params) {{
          :config_file_path   => '/etc/ntp.2nd.conf',
          :config_file_source => 'puppet:///modules/ntp/Debian/etc/ntp.conf',
        }}

        it do
          is_expected.to contain_file('define_ntp.conf').with({
            'ensure'  => 'present',
            'source'  => 'puppet:///modules/ntp/Debian/etc/ntp.conf',
            'notify'  => 'Service[ntp]',
            'require' => 'Package[ntp]',
          })
        end
      end

      context 'when content string' do
        let(:params) {{
          :config_file_path   => '/etc/ntp.3rd.conf',
          :config_file_string => '# THIS FILE IS MANAGED BY PUPPET',
        }}

        it do
          is_expected.to contain_file('define_ntp.conf').with({
            'ensure'  => 'present',
            'content' => /THIS FILE IS MANAGED BY PUPPET/,
            'notify'  => 'Service[ntp]',
            'require' => 'Package[ntp]',
          })
        end
      end

      context 'when content template' do
        let(:params) {{
          :config_file_path     => '/etc/ntp.4th.conf',
          :config_file_template => 'ntp/Debian/etc/ntp.conf.erb',
        }}

        it do
          is_expected.to contain_file('define_ntp.conf').with({
            'ensure'  => 'present',
            'content' => /THIS FILE IS MANAGED BY PUPPET/,
            'notify'  => 'Service[ntp]',
            'require' => 'Package[ntp]',
          })
        end
      end

      context 'when content template (custom)' do
        let(:params) {{
          :config_file_path         => '/etc/ntp.5th.conf',
          :config_file_template     => 'ntp/Debian/etc/ntp.conf.erb',
          :config_file_options_hash => {
            'key' => 'value',
          },
        }}

        it do
          is_expected.to contain_file('define_ntp.conf').with({
            'ensure'  => 'present',
            'content' => /THIS FILE IS MANAGED BY PUPPET/,
            'notify'  => 'Service[ntp]',
            'require' => 'Package[ntp]',
          })
        end
      end
    end
  end
end
