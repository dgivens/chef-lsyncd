#
# Cookbook Name:: lsyncd
# Provider:: target
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

use_inline_resources

action :create do
  raise "No SSH host provided for lsyncd target" if new_resource.mode == 'rsyncssh' && new_resource.host.nil?

  if new_resource.rsync_opts
    rsync_opts = '{'
    new_resource.rsync_opts.each_with_index do |opt, index|
      rsync_opts << "\"#{opt}\""
      if index < new_resource.rsync_opts.length - 1
        rsync_opts << ', '
      end
    end
    rsync_opts << "}"
  end

  if new_resource.exclude
    exclude = '{'
    new_resource.exclude.each_with_index do |opt, index|
      exclude << "\"#{opt}\""
      if index < new_resource.exclude.length - 1
        exclude << ', '
      end
    end
    exclude << "}"
  end

  t = template "/etc/lsyncd/conf.d/#{new_resource.name}.lua" do
    cookbook new_resource.cookbook
    source 'target.erb'
    mode 0644
    variables({
      :mode => new_resource.mode,
      :source => new_resource.source,
      :target => new_resource.target,
      :user => new_resource.user,
      :host => new_resource.host,
      :rsync_opts => rsync_opts,
      :exclude => exclude,
      :exclude_from => new_resource.exclude_from
    })
    action :create
  end
end

action :delete do
  file "/etc/lsyncd/conf.d/#{new_resource.name}.lua" do
    action :delete
  end
end
