name             'lsyncd'
maintainer       'Daniel Givens'
maintainer_email 'daniel.givens@rackspace.com'
license          'Apache 2.0'
description      'Installs/Configures lsyncd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
supports         'ubuntu', '>= 12.04'
supports         'debian', '>= 7.0'
supports         'centos', '>= 6.0'
supports         'scientific', '>= 6.0'
supports         'redhat', '>= 6.0'
supports         'amazon'
version          '0.2.1'
depends          'yum', "~> 3.0.0"
