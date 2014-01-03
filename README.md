# lsyncd Cookbook

The lsyncd cookbook installs lsyncd, creates and basic config, and starts the
service. Additionally, it exposes the lsyncd_target resource easily add sync
configs.

Through some ugly Lua hackery, the main config, `/etc/lsyncd/lsyncd.conf.lua`,
is setup such that it will include all sync configs in `/etc/lsyncd/conf.d/`.
The lsyncd_target resource pretty much just creates the configs in 
`/etc/lsyncd/conf.d/`.

# Requirements

Tested on Debian Wheezy
Chef 11 or greater

# Usage

After loading the lsyncd cookbook you have access to the `lsyncd_target` resource for setting up simple lsyncd layer 4 sync configs. 

__You must include `lsyncd::default` to use the `lsyncd_target` resource.__

### Examples

Sync a directory to another local directory:

```ruby
include_recipe 'lsyncd'

lsyncd_target 'foo' do
  source '/tmp/foo'
  target '/tmp/bar'
  notifies :restart, 'service[lsyncd]', :delayed
end
```

# Attributes

# Recipes

# Author

Author:: Rackspace, Inc. (<daniel.givens@rackspace.com>)
