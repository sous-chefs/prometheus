# frozen_string_literal: true

name             'prometheus'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Provides custom resources for installing and configuring Prometheus and Alertmanager'
version          '1.0.0'
source_url       'https://github.com/sous-chefs/prometheus'
issues_url       'https://github.com/sous-chefs/prometheus/issues'
chef_version     '>= 16.0'

depends 'ark'

supports 'almalinux', '>= 8.0'
supports 'amazon', '>= 2023.0'
supports 'centos_stream', '>= 9.0'
supports 'debian', '>= 12.0'
supports 'fedora'
supports 'oracle', '>= 8.0'
supports 'redhat', '>= 8.0'
supports 'rocky', '>= 8.0'
supports 'ubuntu', '>= 20.04'
