# lsyncd Cookbook

The lsyncd cookbook installs lsyncd, creates a basic config, and starts the
service. Additionally, it exposes the lsyncd_target resource to easily add sync
configs.

Through some ugly Lua hackery, the main config, `/etc/lsyncd/lsyncd.conf.lua`,
is setup such that it will include all sync configs in `/etc/lsyncd/conf.d/`.
The lsyncd_target resource pretty much just creates the configs in 
`/etc/lsyncd/conf.d/`.

The basis for this cookbook came from 
[bflad's lsyncd cookbook](https://github.com/bflad/chef-lsyncd).

## Requirements

- Chef 11 or greater

Tested on:

- Debian 7.4 (Wheezy)
- Ubuntu 12.04
- CentOS 6.5

## Resources/Providers

### lsyncd_target

#### Actions

- `:create` - creates a sync config
- `:delete` - deletes the sync config

#### Parameters

- `mode` - lsyncd sync mode. Defaults to `rsync`
- `source` - source directory. Required
- `target` - target directory to sync files to. Required
- `user` - User name to use when syncing content. Optional, will assume root if a user name is not provided.
- `host` - IP or hostname of remote host. Required for remote syncing with the `rsync` or `rsyncssh` modes.
- `rsync_opts` - list of rsync options
- `exclude` - list of [exclusions](https://github.com/axkibe/lsyncd/wiki/Lsyncd%202.1.x%20%E2%80%96%20Layer%204%20Config%20%E2%80%96%20Default%20Behavior#exclusions)
- `exclude_from` - path to file containing exclusions

#### Example

Sync a directory to another local directory:

```ruby
include_recipe 'lsyncd'

lsyncd_target 'foo' do
  source '/tmp/foo'
  target '/tmp/bar'
  notifies :restart, 'service[lsyncd]', :delayed
end
```

You can also do remote rsync by specifying `rsync` or `rsyncssh` for the mode:

```ruby
include_recipe 'lsyncd'

lsyncd_target 'foo' do
  host 'test'
  source '/tmp/foo'
  target '/tmp/bar'
  notifies :restart, 'service[lsyncd]', :delayed
end
```

## Recipes

### default.rb

Installs lsyncd, creates `/etc/lsyncd/conf.d`, sets up base config, and starts
lsyncd service. Note that the service will not actually start until you have a sync config in place.

## Attributes

```ruby
default[:lsyncd][:conf_d] = '/etc/lsyncd/conf.d'
default[:lsyncd][:log_file] = '/var/log/lsyncd.log'
default[:lsyncd][:status_file] = '/var/log/lsyncd-status.log'
default[:lsyncd][:interval] = 20
```

## Testing

This cookbook includes chefspec unit tests and integration tests via test-kitchen and serverspec.
There is a test cookbook to exercise the lsync_target LWRP included. 

I've included a custom matcher for chefspec. The methods available are:

- `create_lsyncd_target`
- `delete_lsyncd_target`

There is also an `lsyncd_target` chef_runner method, so you can do things like:

```ruby
resource = chef_run.lsyncd_target('test1')
expect(resource).to notify('service[lsyncd]').to(:restart).delayed
```

## License & Authors

Authors:: Daniel Givens (<daniel.givens@rackspace.com>)
Authors:: Brian Flad (<bflad417@gmail.com>)

```text
Copyright 2014, Rackspace, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
