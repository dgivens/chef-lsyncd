#
# Cookbook Name:: lsyncd
# Attributes:: default
#

default['lsyncd']['conf_d'] = '/etc/lsyncd/conf.d'
default['lsyncd']['log_file'] = '/var/log/lsyncd.log'
default['lsyncd']['status_file'] = '/var/log/lsyncd-status.log'
default['lsyncd']['interval'] = 20
