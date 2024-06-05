name             'prometheus'
maintainer       'Sous Chefs'
maintainer_email 'help@sous-chefs.org'
license          'Apache-2.0'
description      'Installs/Configures Prometheus'
version          '0.7.4'
source_url 'https://github.com/sous-chefs/prometheus'
issues_url 'https://github.com/sous-chefs/prometheus/issues'
chef_version     '>= 14.0'

%w(ubuntu debian centos redhat fedora).each do |os|
  supports os
end

depends 'apt'
depends 'yum'
depends 'runit', '>= 1.5'
depends 'ark'
depends 'golang'
