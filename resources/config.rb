# frozen_string_literal: true

provides :prometheus_config
unified_mode true

use '_partial/_common'
use '_partial/_prometheus'

property :template_cookbook, String, default: 'prometheus'
property :template_source, String, default: 'prometheus.yml.erb'
property :rule_filenames, [Array, nil], default: nil
property :global_config, Hash, default: {
  'scrape_interval' => '60s',
  'evaluation_interval' => '60s',
}
property :allow_external_config, [true, false], default: false

default_action :create

action :create do
  config_resource = new_resource

  with_run_context :root do
    template config_resource.config_file do
      cookbook config_resource.template_cookbook
      source config_resource.template_source
      mode '0644'
      owner config_resource.user
      group config_resource.group
      variables(
        global_config: config_resource.global_config,
        jobs: {},
        rule_filenames: config_resource.rule_filenames
      )
      not_if { config_resource.allow_external_config }
    end
  end
end

action :delete do
  file new_resource.config_file do
    action :delete
  end
end
