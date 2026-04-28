# frozen_string_literal: true

provides :prometheus_alertmanager_config
unified_mode true

use '_partial/_common'
use '_partial/_alertmanager'

property :template_cookbook, String, default: 'prometheus'
property :template_source, String, default: 'alertmanager.yml.erb'
property :notification_config, Hash, default: {}

default_action :create

action :create do
  template new_resource.config_file do
    cookbook new_resource.template_cookbook
    source new_resource.template_source
    mode '0644'
    owner new_resource.user
    group new_resource.group
    variables(notification_config: new_resource.notification_config)
  end
end

action :delete do
  file new_resource.config_file do
    action :delete
  end
end
