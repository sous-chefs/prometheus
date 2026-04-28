# frozen_string_literal: true

provides :prometheus_job
unified_mode true

property :scrape_interval, String
property :scrape_timeout, String
property :labels, Hash
property :target, [Array, String], required: true
property :metrics_path, String, default: '/metrics'
property :config_file, String, default: '/opt/prometheus/prometheus.yml'
property :allow_external_config, [true, false], default: false

default_action :create

action :create do
  job_resource = new_resource

  with_run_context :root do
    edit_resource(:template, job_resource.config_file) do
      variables[:jobs] ||= {}
      variables[:jobs][job_resource.name] ||= {}
      variables[:jobs][job_resource.name]['scrape_interval'] = job_resource.scrape_interval
      variables[:jobs][job_resource.name]['scrape_timeout'] = job_resource.scrape_timeout
      variables[:jobs][job_resource.name]['target'] = job_resource.target
      variables[:jobs][job_resource.name]['metrics_path'] = job_resource.metrics_path
      variables[:jobs][job_resource.name]['labels'] = job_resource.labels

      action :nothing
      delayed_action :create

      not_if { job_resource.allow_external_config }
    end
  end
end

action :delete do
  file new_resource.config_file do
    action :delete
  end
end
