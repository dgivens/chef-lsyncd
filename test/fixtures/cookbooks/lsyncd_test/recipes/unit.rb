include_recipe 'lsyncd::default'

lsyncd_target 'test1' do
  source '/tmp/test1_source'
  target '/tmp/test1_target'
  notifies :restart, 'service[lsyncd]', :delayed
end

['/tmp/test1_source', '/tmp/test1_target'].each do |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

file '/tmp/test1_source/empty_file' do
  content 'so foo. much bar. wow.'
  mode 0644
  action :create
end

lsyncd_target 'test2' do
  mode 'rsync'
  source '/tmp/test2_source'
  target '/tmp/test2_target'
  host 'test'
  notifies :restart, 'service[lsyncd]', :delayed
end

['/tmp/test2_source'].each do |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

file '/tmp/test2_source/empty_file' do
  content 'so foo. much bar. wow.'
  mode 0644
  action :create
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

['/tmp/test3_source'].each do |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

file '/tmp/test3_source/empty_file' do
  content 'so foo. much bar. wow.'
  mode 0644
  action :create
end

file '/tmp/test_exclude' do
  content '*.tmp'
  mode 0644
  action :create
end

lsyncd_target 'test4' do
  action :delete
  notifies :restart, 'service[lsyncd]', :delayed
end

lsyncd_target "test5" do
  mode 'rsync'
  source '/tmp/test5_source'
  target '/tmp/test5_target'
  user 'lnxuser'
  host 'test'
  notifies :restart, 'service[lsyncd]', :delayed
end

['/tmp/test5_source'].each do |dir|
  directory dir do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
  end
end

file '/tmp/test5_source/empty_file' do
  content 'so foo. much bar. wow.'
  mode 0644
  action :create
end
