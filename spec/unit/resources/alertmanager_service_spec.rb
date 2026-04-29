# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus_alertmanager_service' do
  step_into :prometheus_alertmanager_service
  platform 'ubuntu', '22.04'

  recipe do
    prometheus_alertmanager_service 'alertmanager'
  end

  it { is_expected.to create_systemd_unit('alertmanager.service') }

  it 'writes a systemd unit with alertmanager flags' do
    content = chef_run.systemd_unit('alertmanager.service').content
    service_content = content[:Service] || content['Service']
    expect(service_content[:ExecStart]).to include('/opt/prometheus/alertmanager')
    expect(service_content[:ExecStart]).to include('--config.file=/opt/prometheus/alertmanager.yml')
    expect(service_content[:ExecStart]).to include('--storage.path=/opt/prometheus/data')
    expect(service_content[:User]).to eq('prometheus')
    expect(service_content[:Group]).to eq('prometheus')
  end
end
