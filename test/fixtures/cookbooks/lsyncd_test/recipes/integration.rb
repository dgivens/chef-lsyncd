include_recipe 'lsyncd::default'

['/tmp/test1_source', '/tmp/test1_target'].each do |dir|
  directory dir do
    mode 0755
  end
end

file '/tmp/test1_source/empty_file' do
  content 'so foo. much bar. wow.'
  mode 0644
  action :create
end

lsyncd_target 'test1' do
  source '/tmp/test1_source'
  target '/tmp/test1_target'
  notifies :restart, 'service[lsyncd]', :delayed
end
