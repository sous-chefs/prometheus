#
# Cookbook:: prometheus
# Recipe:: service
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node['prometheus']['init_style']
when 'runit'
  include_recipe 'runit::default'

  runit_service 'prometheus' do
    default_logger true
  end
when 'systemd'
  # rubocop:disable Style/PercentLiteralDelimiters
  dist_dir, conf_dir, env_file = value_for_platform_family(
    ['fedora'] => %w(fedora sysconfig prometheus),
    ['rhel'] => %w(redhat sysconfig prometheus),
    ['debian'] => %w(debian default prometheus),
    ['amazon'] => %w(amazon default prometheus)
  )
  # rubocop:enable Style/PercentLiteralDelimiters

  template '/etc/systemd/system/prometheus.service' do
    source 'systemd/prometheus.service.erb'
    mode '0644'
    variables(sysconfig_file: "/etc/#{conf_dir}/#{env_file}")
    notifies :restart, 'service[prometheus]', :delayed
  end

  template "/etc/#{conf_dir}/#{env_file}" do
    source "#{dist_dir}/#{conf_dir}/prometheus.erb"
    mode '0644'
    notifies :restart, 'service[prometheus]', :delayed
  end

  # rubocop:disable Style/PercentLiteralDelimiters
  service 'prometheus' do
    supports status: true, restart: true
    action %i(enable start)
  end
  # rubocop:enable Style/PercentLiteralDelimiters

when 'upstart'
  template '/etc/init/prometheus.conf' do
    source 'upstart/prometheus.service.erb'
    mode '0644'
    notifies :restart, 'service[prometheus]', :delayed
  end

  # rubocop:disable Style/PercentLiteralDelimiters
  service 'prometheus' do
    provider Chef::Provider::Service::Upstart
    action %i(enable start)
  end
  # rubocop:enable Style/PercentLiteralDelimiters
else

  package 'chkconfig' do
    only_if { platform?('amazon') }
  end

  template '/etc/init.d/prometheus' do
    source 'prometheus.erb'
    owner 'root'
    group node['root_group']
    mode '0755'
  end

  # rubocop:disable Style/PercentLiteralDelimiters
  service 'prometheus' do
    supports status: true, restart: true, reload: true
    action %i(enable start)
  end
  # rubocop:enable Style/PercentLiteralDelimiters

end
