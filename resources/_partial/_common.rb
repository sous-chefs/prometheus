# frozen_string_literal: true

property :install_dir, String, default: '/opt/prometheus'
property :log_dir, String, default: '/var/log/prometheus'
property :user, String, default: 'prometheus'
property :group, String, default: 'prometheus'
property :use_existing_user, [true, false], default: false
property :install_method, String, equal_to: %w(binary shell_binary source), default: 'binary'
