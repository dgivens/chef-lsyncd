include_recipe 'lsyncd::default'

lsyncd_target 'test1' do
  source '/tmp/test1_source'
  target '/tmp/test1_target'
  notifies :restart, 'service[lsyncd]', :delayed
end
