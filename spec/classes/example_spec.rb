require 'spec_helper'

describe 'ld_relay' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "ld_relay class without any parameters" do
          it { is_expected.to compile.with_all_deps }

          it { is_expected.to contain_class('ld_relay::params') }
          it { is_expected.to contain_class('ld_relay::install').that_comes_before('ld_relay::config') }
          it { is_expected.to contain_class('ld_relay::config') }
          it { is_expected.to contain_class('ld_relay::service').that_subscribes_to('ld_relay::config') }

          it { is_expected.to contain_service('ld_relay') }
          it { is_expected.to contain_package('ld_relay').with_ensure('present') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'ld_relay class without any parameters on Solaris/Nexenta' do
      let(:facts) do
        {
          :osfamily        => 'Solaris',
          :operatingsystem => 'Nexenta',
        }
      end

      it { expect { is_expected.to contain_package('ld_relay') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
