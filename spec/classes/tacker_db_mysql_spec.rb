require 'spec_helper'

describe 'tacker::db::mysql' do

  let :pre_condition do
    'include mysql::server'
  end

  let :required_params do
    { :password => 'tackerpass', }
  end

  shared_examples_for 'tacker-db-mysql' do
    context 'with only required params' do
      let :params do
        required_params
      end

      it { should contain_class('tacker::deps') }

      it { is_expected.to contain_openstacklib__db__mysql('tacker').with(
        :user          => 'tacker',
        :password      => 'tackerpass',
        :dbname        => 'tacker',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
      )}
    end

    context 'overriding allowed_hosts param to array' do
      let :params do
        { :allowed_hosts => ['127.0.0.1','%'] }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('tacker').with(
        :user          => 'tacker',
        :password      => 'tackerpass',
        :dbname        => 'tacker',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => ['127.0.0.1','%']
      )}
    end

    describe 'overriding allowed_hosts param to string' do
      let :params do
        { :allowed_hosts => '192.168.1.1' }.merge(required_params)
      end

      it { is_expected.to contain_openstacklib__db__mysql('tacker').with(
        :user          => 'tacker',
        :password      => 'tackerpass',
        :dbname        => 'tacker',
        :host          => '127.0.0.1',
        :charset       => 'utf8',
        :collate       => 'utf8_general_ci',
        :allowed_hosts => '192.168.1.1'
      )}
    end
  end

  on_supported_os({
    :supported_os => OSDefaults.get_supported_os
  }).each do |os,facts|
    context "on #{os}" do
      let (:facts) do
        facts.merge!(OSDefaults.get_facts())
      end

      it_behaves_like 'tacker-db-mysql'
    end
  end
end
