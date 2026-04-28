# frozen_string_literal: true

property :version, String, default: '3.11.2'
property :binary, String, default: '/opt/prometheus/prometheus'
property :architecture, String, equal_to: %w(amd64 arm64), default: lazy {
  node['kernel']['machine'] == 'aarch64' ? 'arm64' : 'amd64'
}
property :binary_url, String, default: lazy { "https://github.com/prometheus/prometheus/releases/download/v#{version}/prometheus-#{version}.linux-#{architecture}.tar.gz" }
property :checksum, String, default: lazy {
  {
    'amd64' => 'f643ea1ee90d109329302d27bddb1fb2e52655b1fa84e9e26f9a6f340da144a6',
    'arm64' => '4e40f115655a3021744137f49287846bc5a59e02835565748ff66b23e776a73d',
  }[architecture]
}
property :file_extension, String, default: ''
property :source_repository, String, default: 'https://github.com/prometheus/prometheus.git'
property :source_revision, String, default: lazy { "v#{version}" }
property :config_file, String, default: '/opt/prometheus/prometheus.yml'
property :storage_path, String, default: '/var/lib/prometheus'
property :flags, Hash, default: lazy {
  legacy_flags = {
    'config.file' => config_file,
    'log.level' => 'info',
    'alertmanager.timeout' => '10s',
    'alertmanager.notification-queue-capacity' => 100,
    'alertmanager.url' => 'http://127.0.0.1/alert-manager/',
    'query.max-concurrency' => 20,
    'query.staleness-delta' => '5m',
    'query.timeout' => '2m',
    'storage.local.checkpoint-dirty-series-limit' => 5000,
    'storage.local.checkpoint-interval' => '5m',
    'storage.local.dirty' => false,
    'storage.local.index-cache-size.fingerprint-to-metric' => 10_485_760,
    'storage.local.index-cache-size.fingerprint-to-timerange' => 5_242_880,
    'storage.local.index-cache-size.label-name-to-label-values' => 10_485_760,
    'storage.local.index-cache-size.label-pair-to-fingerprints' => 20_971_520,
    'storage.local.memory-chunks' => 1_048_576,
    'storage.local.path' => storage_path,
    'storage.local.pedantic-checks' => false,
    'storage.local.retention' => '360h0m0s',
    'storage.local.series-sync-strategy' => 'adaptive',
    'storage.remote.influxdb-url' => '',
    'storage.remote.influxdb.database' => 'prometheus',
    'storage.remote.influxdb.retention-policy' => 'default',
    'storage.remote.opentsdb-url' => '',
    'storage.remote.timeout' => '30s',
    'web.console.libraries' => 'console_libraries',
    'web.console.templates' => 'consoles',
    'web.enable-remote-shutdown' => false,
    'web.external-url' => '',
    'web.listen-address' => ':9090',
    'web.telemetry-path' => '/metrics',
    'web.user-assets' => '',
  }
  legacy_flags['web.use-local-assets'] = false if Gem::Version.new(version) <= Gem::Version.new('0.16.2')
  legacy_flags
}
property :cli_options, Hash, default: lazy {
  {
    'config.file' => config_file,
    'log.level' => 'info',
    'query.max-concurrency' => 20,
    'query.lookback-delta' => '5m',
    'query.timeout' => '2m',
    'storage.tsdb.path' => storage_path,
    'storage.tsdb.retention.time' => '15d',
    'web.listen-address' => ':9090',
    'web.telemetry-path' => '/metrics',
  }
}
property :cli_flags, Array, default: ['web.enable-lifecycle']
