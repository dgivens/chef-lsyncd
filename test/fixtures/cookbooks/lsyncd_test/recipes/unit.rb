include_recipe 'lsyncd::default'

lsyncd_target 'test1' do
  source '/tmp/test1_source'
  target '/tmp/test1_target'
  notifies :restart, 'service[lsyncd]', :delayed
end

lsyncd_target 'test2' do
  mode 'rsync'
  source '/tmp/test2_source'
  target 'test2_target'
  host 'test'
  notifies :restart, 'service[lsyncd]', :delayed
end

lsyncd_target 'test3' do
  mode 'rsyncssh'
  source '/tmp/test3_source'
  target '/tmp/test3_target'
  host 'test'
  rsync_opts ["-ltus", "--numeric-ids", "--bwlimit=10000"]
  exclude ["foo", "bar"]
  exclude_from "/tmp/test_exclude"
  notifies :restart, 'service[lsyncd]', :delayed
end

lsyncd_target 'test4' do
  action :delete
  notifies :restart, 'service[lsyncd]', :delayed
end
