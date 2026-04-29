# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus_service' do
  step_into :prometheus_service
  platform 'ubuntu', '22.04'

  recipe do
    prometheus_service 'prometheus'
  end

  it { is_expected.to create_systemd_unit('prometheus.service') }

  it 'writes a systemd unit with prometheus flags' do
    content = chef_run.systemd_unit('prometheus.service').content
    service_content = content[:Service] || content['Service']
    expect(service_content[:ExecStart]).to include('/opt/prometheus/prometheus')
    expect(service_content[:ExecStart]).to include('--config.file=/opt/prometheus/prometheus.yml')
    expect(service_content[:User]).to eq('prometheus')
    expect(service_content[:Group]).to eq('prometheus')
  end
end
