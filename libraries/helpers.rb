# frozen_string_literal: true

require 'uri'

module PrometheusCookbook
  module Helpers
    def archive_name(component, version, url)
      basename = ::File.basename(URI.parse(url).path)
      basename.sub(/(?:\.tar\.gz|\.tgz|\.tar\.bz2|\.tar\.xz|\.zip)\z/, '')
    rescue URI::InvalidURIError
      "#{component}-#{version}"
    end

    def install_dir_parent(install_dir)
      ::File.dirname(install_dir)
    end

    def install_dir_name(install_dir)
      ::File.basename(install_dir)
    end

    def prometheus_flags(resource)
      flag_pairs = if Gem::Version.new(resource.version) < Gem::Version.new('2.0.0-alpha.0')
                     resource.flags.map { |key, value| "-#{key}=#{value}" unless value == '' }
                   else
                     resource.cli_options.map { |key, value| "--#{key}=#{value}" unless value == '' } +
                       resource.cli_flags.map { |flag| "--#{flag}" unless flag == '' }
                   end

      flag_pairs.compact.join(' ')
    end

    def prometheus_unit_content(resource)
      {
        Unit: {
          Description: 'Prometheus',
          After: 'network.target auditd.service',
        },
        Service: {
          Type: 'simple',
          Environment: "GOMAXPROCS=#{node['cpu']['total'] || 1}",
          User: resource.user,
          Group: resource.group,
          ExecStart: "#{resource.binary} #{prometheus_flags(resource)}",
          ExecReload: '/bin/kill -HUP $MAINPID',
          Restart: 'always',
        },
        Install: {
          WantedBy: 'multi-user.target',
        },
      }
    end

    def alertmanager_unit_content(resource)
      {
        Unit: {
          Description: 'Prometheus Alertmanager',
          After: 'network.target',
        },
        Service: {
          User: resource.user,
          Group: resource.group,
          ExecStart: [
            resource.binary,
            "--log.level=#{resource.log_level}",
            "--storage.path=#{resource.storage_path}",
            "--config.file=#{resource.config_file}",
            "--web.external-url=#{resource.external_url}",
          ].join(' '),
          Restart: 'always',
        },
        Install: {
          WantedBy: 'multi-user.target',
        },
      }
    end
  end
end
