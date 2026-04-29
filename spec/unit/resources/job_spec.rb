# frozen_string_literal: true

require 'spec_helper'

describe 'prometheus_job' do
  step_into :prometheus_config, :prometheus_job
  platform 'ubuntu', '22.04'

  recipe do
    prometheus_config 'prometheus'

    prometheus_job 'prometheus' do
      scrape_interval '15s'
      target 'localhost:9090'
    end
  end

  it 'adds the job to the prometheus template variables' do
    variables = chef_run.template('/opt/prometheus/prometheus.yml').variables
    expect(variables[:jobs]['prometheus']).to include(
      'scrape_interval' => '15s',
      'target' => 'localhost:9090',
      'metrics_path' => '/metrics'
    )
  end
end
