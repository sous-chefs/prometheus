# frozen_string_literal: true

property :version, String, default: '0.32.0'
property :binary, String, default: '/opt/prometheus/alertmanager'
property :architecture, String, equal_to: %w(amd64 arm64), default: lazy {
  node['kernel']['machine'] == 'aarch64' ? 'arm64' : 'amd64'
}
property :binary_url, String, default: lazy { "https://github.com/prometheus/alertmanager/releases/download/v#{version}/alertmanager-#{version}.linux-#{architecture}.tar.gz" }
property :checksum, String, default: lazy {
  {
    'amd64' => 'be72f50f6124ec53d944c0f100f8ec8108d969bade02fcc9f06a3068ff6c726f',
    'arm64' => '7812e12699694974f57ecc0b0400913c6c0d90190630d4332a7994a44982b1ed',
  }[architecture]
}
property :file_extension, String, default: ''
property :source_repository, String, default: 'https://github.com/prometheus/alertmanager.git'
property :source_revision, String, default: lazy { "v#{version}" }
property :config_file, String, default: '/opt/prometheus/alertmanager.yml'
property :storage_path, String, default: '/opt/prometheus/data'
property :external_url, String, default: 'http://127.0.0.1/alert-manager/'
property :log_level, String, default: 'debug'
