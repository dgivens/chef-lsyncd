require_relative '../spec_helper'

describe 'lsyncd::default' do
  let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

  it 'installs lsyncd package' do
    expect(chef_run).to install_package('lsyncd')
  end

  it 'creates /etc/lsyncd/conf.d directory' do
    expect(chef_run).to create_directory('/etc/lsyncd/conf.d').with(mode: 0755)
  end

  it 'creates base config /etc/lsyncd/lsyncd.conf.lua' do
    expect(chef_run).to create_template('/etc/lsyncd/lsyncd.conf.lua').with(mode: 0644)
  end

  it 'enables and starts lsyncd' do
    expect(chef_run).to enable_service('lsyncd')
    expect(chef_run).to start_service('lsyncd')
  end
end
