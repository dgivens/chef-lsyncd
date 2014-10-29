#
# Cookbook Name:: lsyncd
# Recipe:: default
#
# Copyright (C) 2014 Rackspace, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#


yum_repository 'epel' do
  description 'Extra Packages for Enterprise Linux'
  mirrorlist 'http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch'
  gpgkey 'http://dl.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-6'
  action :create
  only_if { platform_family?('rhel') }
end

package 'lsyncd'

directory '/etc/lsyncd/conf.d' do
  recursive true
  mode 0755
end

if platform_family?('fedora', 'rhel')
  template '/etc/lsyncd.conf' do
    source 'lsyncd.conf.lua.erb'
    mode 0644
  end
else
  template '/etc/lsyncd/lsyncd.conf.lua' do
    source 'lsyncd.conf.lua.erb'
    mode 0644
  end
end

service 'lsyncd' do
  action [:enable, :start]
  ignore_failure true
end
