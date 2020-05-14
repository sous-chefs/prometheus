name             'prometheus'
maintainer       'Elijah Wright'
maintainer_email 'elijah.wright@gmail.com'
license          'Apache-2.0'
description      'Installs/Configures Prometheus'
version          '0.7.0'
source_url 'https://github.com/elijah/chef-prometheus'
issues_url 'https://github.com/elijah/chef-prometheus/issues'
chef_version     '>= 14.0'

%w(ubuntu debian centos redhat fedora).each do |os|
  supports os
end

depends 'apt'
depends 'yum'
depends 'runit', '>= 1.5'
depends 'ark'
depends 'golang'