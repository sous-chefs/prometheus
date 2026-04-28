# frozen_string_literal: true

provides :prometheus_service
unified_mode true

use '_partial/_common'
use '_partial/_prometheus'

default_action :create

action_class do
  include PrometheusCookbook::Helpers
end

action :create do
  systemd_unit 'prometheus.service' do
    content prometheus_unit_content(new_resource)
    action [:create, :enable, :start]
  end
end

action :enable do
  systemd_unit 'prometheus.service' do
    action :enable
  end
end

action :start do
  systemd_unit 'prometheus.service' do
    action :start
  end
end

action :restart do
  systemd_unit 'prometheus.service' do
    action :restart
  end
end

action :reload do
  systemd_unit 'prometheus.service' do
    action :reload
  end
end

action :stop do
  systemd_unit 'prometheus.service' do
    action [:stop, :disable]
  end
end

action :delete do
  systemd_unit 'prometheus.service' do
    action [:stop, :disable, :delete]
  end
end
