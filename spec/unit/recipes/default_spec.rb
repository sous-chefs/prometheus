require 'spec_helper'

describe 'prometheus::default' do
  let(:chef_run) do
    ChefSpec::SoloRunner
      .new(
        platform: 'ubuntu',
        version: '16.04',
        file_cache_path: '/tmp/chef/cache',
        step_into: ['prometheus_job']
      ) do |node|
        node.normal['prometheus']['job_config_cookbook_name'] = 'other_cookbook'
      end
      .converge(described_recipe)
  end

  before do
    stub_command('/usr/local/go/bin/go version | grep "go1.5 "').and_return(0)
  end

  it 'creates a user with correct attributes' do
    expect(chef_run).to(
      create_user('prometheus').with(
        system: true,
        shell: '/bin/false',
        home: '/opt/prometheus'
      )
    )
  end

  it 'creates a directory at /opt/prometheus' do
    expect(chef_run).to(
      create_directory('/opt/prometheus').with(
        owner: 'prometheus',
        group: 'prometheus',
        mode: '0755',
        recursive: true
      )
    )
  end

  it 'creates a directory at /var/log/prometheus' do
    expect(chef_run).to(
      create_directory('/var/log/prometheus').with(
        owner: 'prometheus',
        group: 'prometheus',
        mode: '0755',
        recursive: true
      )
    )
  end

  it 'renders a prometheus job configuration file and notifies prometheus to reload' do
    resource = chef_run.template('/opt/prometheus/prometheus.yml')
    expect(resource).to(notify('service[prometheus]').to(:reload))
  end

  it 'uses an attribute to select the prometheus.yml template' do
    expect(chef_run).to(create_template('/opt/prometheus/prometheus.yml').with_cookbook('other_cookbook'))
  end

  # Test for source.rb

  context('source') do
    let(:chef_run) do
      ChefSpec::SoloRunner
        .new(platform: 'ubuntu', version: '16.04', file_cache_path: '/var/chef/cache') do |node|
          node.normal['prometheus']['version'] = '2.2.1'
          node.normal['prometheus']['install_method'] = 'source'
          node.normal['go']['gopath'] = ''
        end
        .converge(described_recipe)
    end

    it 'includes build-essential' do
      expect(chef_run).to build_essential('install compilation tools')
    end

    # rubocop:disable Style/PercentLiteralDelimiters
    %w(curl git-core mercurial gzip sed).each do |pkg|
      it "installs #{pkg}" do
        expect(chef_run).to(install_package(pkg))
      end
    end
    # rubocop:enable Style/PercentLiteralDelimiters

    it 'checks out prometheus from github' do
      expect(chef_run).to(
        checkout_git("#{Chef::Config[:file_cache_path]}/prometheus-2.2.1").with(
          repository: 'https://github.com/prometheus/prometheus.git',
          revision: 'v2.2.1'
        )
      )
    end

    it 'compiles prometheus source' do
      expect(chef_run).to(run_bash('compile_prometheus_source'))
    end

    it 'notifies prometheus to reload' do
      resource = chef_run.bash('compile_prometheus_source')
      expect(resource).to(notify('service[prometheus]').to(:restart))
    end

    context('runit') do
      let(:chef_run) do
        ChefSpec::SoloRunner
          .new(platform: 'ubuntu', version: '16.04', file_cache_path: '/var/chef/cache') do |node|
            node.normal['prometheus']['init_style'] = 'runit'
          end
          .converge(described_recipe)
      end

      it 'includes runit::default recipe' do
        expect(chef_run).to(include_recipe('runit::default'))
      end

      it 'enables runit_service' do
        expect(chef_run).to(enable_runit_service('prometheus'))
      end
    end

    context('init') do
      let(:chef_run) do
        ChefSpec::SoloRunner
          .new(platform: 'ubuntu', version: '16.04', file_cache_path: '/var/chef/cache') do |node|
            node.normal['prometheus']['init_style'] = 'init'
          end
          .converge(described_recipe)
      end

      it 'renders an init.d configuration file' do
        expect(chef_run).to(render_file('/etc/init.d/prometheus'))
      end
    end

    context('systemd') do
      let(:chef_run) do
        ChefSpec::SoloRunner
          .new(platform: 'ubuntu', version: '16.04', file_cache_path: '/var/chef/cache') do |node|
            node.normal['prometheus']['init_style'] = 'systemd'
          end
          .converge(described_recipe)
      end

      it 'renders a systemd service file' do
        expect(chef_run).to(render_file('/etc/systemd/system/prometheus.service'))
      end
    end

    context('upstart') do
      let(:chef_run) do
        ChefSpec::SoloRunner
          .new(platform: 'ubuntu', version: '16.04', file_cache_path: '/var/chef/cache') do |node|
            node.normal['prometheus']['init_style'] = 'upstart'
          end
          .converge(described_recipe)
      end

      it 'renders an upstart job configuration file' do
        expect(chef_run).to(render_file('/etc/init/prometheus.conf'))
      end
    end
  end

  # Test for binary.rb

  context('binary') do
    let(:chef_run) do
      ChefSpec::SoloRunner
        .new(platform: 'ubuntu', version: '16.04', file_cache_path: '/var/chef/cache') do |node|
          node.normal['prometheus']['version'] = '2.2.1'
          node.normal['prometheus']['install_method'] = 'binary'
        end
        .converge(described_recipe)
    end

    it 'runs ark with correct attributes' do
      expect(chef_run).to(
        put_ark('prometheus').with(
          url: 'https://github.com/prometheus/prometheus/releases/download/v2.2.1/prometheus-2.2.1.linux-amd64.tar.gz',
          checksum: 'ec1798dbda1636f49d709c3931078dc17eafef76c480b67751aa09828396cf31',
          version: '2.2.1',
          prefix_root: Chef::Config['file_cache_path'],
          path: '/opt',
          owner: 'prometheus',
          group: 'prometheus'
        )
      )
    end

    context('with non empty file_extension') do
      let(:chef_run) do
        ChefSpec::SoloRunner
          .new(platform: 'ubuntu', version: '16.04', file_cache_path: '/var/chef/cache') do |node|
            node.normal['prometheus']['file_extension'] = 'tar.gz'
          end
          .converge(described_recipe)
      end

      it 'runs ark with given file_extension' do
        expect(chef_run).to(
          put_ark('prometheus').with(
            extension: 'tar.gz'
          )
        )
      end
    end

    context('runit') do
      let(:chef_run) do
        ChefSpec::SoloRunner
          .new(platform: 'ubuntu', version: '16.04', file_cache_path: '/var/chef/cache') do |node|
            node.normal['prometheus']['init_style'] = 'runit'
            node.normal['prometheus']['install_method'] = 'binary'
          end
          .converge(described_recipe)
      end

      it 'includes runit::default recipe' do
        expect(chef_run).to(include_recipe('runit::default'))
      end

      it 'enables runit_service' do
        expect(chef_run).to(enable_runit_service('prometheus'))
      end
    end

    context('init') do
      let(:chef_run) do
        ChefSpec::SoloRunner
          .new(platform: 'ubuntu', version: '16.04', file_cache_path: '/var/chef/cache') do |node|
            node.normal['prometheus']['init_style'] = 'init'
            node.normal['prometheus']['install_method'] = 'binary'
          end
          .converge(described_recipe)
      end

      it 'renders an init.d configuration file' do
        expect(chef_run).to(render_file('/etc/init.d/prometheus'))
      end
    end

    context('systemd') do
      let(:chef_run) do
        ChefSpec::SoloRunner
          .new(platform: 'ubuntu', version: '16.04', file_cache_path: '/var/chef/cache') do |node|
            node.normal['prometheus']['init_style'] = 'systemd'
            node.normal['prometheus']['install_method'] = 'binary'
          end
          .converge(described_recipe)
      end

      it 'renders a systemd service file' do
        expect(chef_run).to(render_file('/etc/systemd/system/prometheus.service'))
      end
    end

    context('upstart') do
      let(:chef_run) do
        ChefSpec::SoloRunner
          .new(platform: 'ubuntu', version: '16.04', file_cache_path: '/var/chef/cache') do |node|
            node.normal['prometheus']['init_style'] = 'upstart'
            node.normal['prometheus']['install_method'] = 'binary'
          end
          .converge(described_recipe)
      end

      it 'renders an upstart job configuration file' do
        expect(chef_run).to(render_file('/etc/init/prometheus.conf'))
      end
    end
  end
end
