# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus_alertmanager_config' do
  step_into :prometheus_alertmanager_config
  platform 'ubuntu', '22.04'

  recipe do
    prometheus_alertmanager_config 'alertmanager'
  end

  it 'creates the alertmanager configuration template' do
    expect(chef_run).to create_template('/opt/prometheus/alertmanager.yml').with(
      cookbook: 'prometheus',
      source: 'alertmanager.yml.erb',
      owner: 'prometheus',
      group: 'prometheus',
      mode: '0644'
    )
  end
end
