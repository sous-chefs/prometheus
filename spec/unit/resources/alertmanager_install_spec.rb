# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus_alertmanager_install' do
  step_into :prometheus_alertmanager_install
  platform 'ubuntu', '22.04'

  recipe do
    prometheus_alertmanager_install 'alertmanager'
  end

  it { is_expected.to create_user('prometheus') }
  it { is_expected.to create_directory('/opt/prometheus') }
  it { is_expected.to create_directory('/var/log/prometheus') }
  it { is_expected.to create_directory('/opt/prometheus/data') }
  it { is_expected.to install_package(%w(tar bzip2)) }

  it 'installs the binary archive with ark' do
    expect(chef_run).to put_ark('prometheus').with(
      url: 'https://github.com/prometheus/alertmanager/releases/download/v0.32.0/alertmanager-0.32.0.linux-amd64.tar.gz',
      checksum: 'be72f50f6124ec53d944c0f100f8ec8108d969bade02fcc9f06a3068ff6c726f',
      version: '0.32.0',
      path: '/opt',
      owner: 'prometheus',
      group: 'prometheus'
    )
  end
end
