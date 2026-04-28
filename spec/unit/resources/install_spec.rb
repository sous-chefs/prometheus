# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus_install' do
  step_into :prometheus_install
  platform 'ubuntu', '22.04'

  recipe do
    prometheus_install 'prometheus'
  end

  it { is_expected.to create_user('prometheus') }
  it { is_expected.to create_directory('/opt/prometheus') }
  it { is_expected.to create_directory('/var/log/prometheus') }
  it { is_expected.to create_directory('/var/lib/prometheus') }
  it { is_expected.to install_package(%w(curl tar bzip2)) }

  it 'installs the binary archive with ark' do
    expect(chef_run).to put_ark('prometheus').with(
      url: 'https://github.com/prometheus/prometheus/releases/download/v3.11.2/prometheus-3.11.2.linux-amd64.tar.gz',
      checksum: 'f643ea1ee90d109329302d27bddb1fb2e52655b1fa84e9e26f9a6f340da144a6',
      version: '3.11.2',
      path: '/opt',
      owner: 'prometheus',
      group: 'prometheus'
    )
  end

  context 'source install' do
    recipe do
      prometheus_install 'prometheus' do
        install_method 'source'
      end
    end

    it 'installs build tools' do
      expect(chef_run.resource_collection.find(build_essential: 'install compilation tools')).not_to be_nil
    end

    it 'checks out prometheus source' do
      expect(chef_run.resource_collection.all_resources.any? { |resource| resource.resource_name == :git && resource.name.end_with?('/prometheus-3.11.2') }).to be true
    end

    it { is_expected.to run_bash('compile_prometheus_source') }
  end
end
