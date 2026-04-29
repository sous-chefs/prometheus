# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus_config' do
  step_into :prometheus_config
  platform 'ubuntu', '22.04'

  recipe do
    prometheus_config 'prometheus'
  end

  it 'creates the prometheus configuration template' do
    expect(chef_run).to create_template('/opt/prometheus/prometheus.yml').with(
      cookbook: 'prometheus',
      source: 'prometheus.yml.erb',
      owner: 'prometheus',
      group: 'prometheus',
      mode: '0644'
    )
  end

  it 'passes default variables' do
    expect(chef_run.template('/opt/prometheus/prometheus.yml').variables).to include(
      global_config: {
        'scrape_interval' => '60s',
        'evaluation_interval' => '60s',
      },
      jobs: {},
      rule_filenames: nil
    )
  end
end
