# frozen_string_literal: true

provides :prometheus_install
unified_mode true

use '_partial/_common'
use '_partial/_prometheus'

default_action :install

action_class do
  include PrometheusCookbook::Helpers
end

action :install do
  user new_resource.user do
    system true
    shell '/bin/false'
    home new_resource.install_dir
    not_if { new_resource.use_existing_user || new_resource.user == 'root' }
  end

  directory new_resource.install_dir do
    owner new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
  end

  directory new_resource.log_dir do
    owner new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
  end

  directory new_resource.storage_path do
    owner new_resource.user
    group new_resource.group
    mode '0755'
    recursive true
  end

  case new_resource.install_method
  when 'binary'
    package %w(tar bzip2)

    ark install_dir_name(new_resource.install_dir) do
      url new_resource.binary_url
      checksum new_resource.checksum
      version new_resource.version
      prefix_root Chef::Config['file_cache_path']
      path install_dir_parent(new_resource.install_dir)
      owner new_resource.user
      group new_resource.group
      extension new_resource.file_extension unless new_resource.file_extension.empty?
      action :put
    end
  when 'shell_binary'
    package %w(tar bzip2)

    remote_file "#{Chef::Config[:file_cache_path]}/prometheus-#{new_resource.version}.tar.gz" do
      source new_resource.binary_url
      checksum new_resource.checksum
      action :create
      notifies :run, 'execute[install_prometheus_archive]', :immediately
    end

    execute 'install_prometheus_archive' do
      command "tar -xzf #{Chef::Config[:file_cache_path]}/prometheus-#{new_resource.version}.tar.gz -C #{new_resource.install_dir} --strip-components=1"
      action :nothing
    end
  when 'source'
    build_essential 'install compilation tools'

    package %w(curl git-core mercurial gzip sed)

    git "#{Chef::Config[:file_cache_path]}/prometheus-#{new_resource.version}" do
      repository new_resource.source_repository
      revision new_resource.source_revision
      action :checkout
    end

    bash 'compile_prometheus_source' do
      cwd "#{Chef::Config[:file_cache_path]}/prometheus-#{new_resource.version}"
      environment(
        'PATH' => "/usr/local/go/bin:#{ENV.fetch('PATH', nil)}",
        'GOPATH' => '/opt/go:/opt/go/src/github.com/prometheus/promu/vendor'
      )
      code <<~EOH
        make build
        mv prometheus #{new_resource.install_dir}
        cp -R console_libraries #{new_resource.install_dir}
        cp -R consoles #{new_resource.install_dir}
      EOH
    end
  end
end
