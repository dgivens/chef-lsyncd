require_relative '../spec_helper'

describe 'lsyncd::default' do
  platforms = {
    'ubuntu' => ['12.04'],
    'debian' => ['7.0'],
    'centos' => ['6.0', '6.2', '6.3'],
    'redhat' => ['6.3']
  }

  platforms.each do |platform, versions|
    versions.each do |version|
      context "On #{platform} #{version}" do
        let(:chef_run) { ChefSpec::Runner.new(platform: platform, version: version).converge(described_recipe) }
            
        if ['centos' ,'redhat'].include?(platform)
          it 'adds EPEL repository' do
            expect(chef_run).to create_yum_repository('epel')
          end
        end
    
        it 'installs lsyncd package' do
          expect(chef_run).to install_package('lsyncd')
        end        
    
        it 'creates /etc/lsyncd/conf.d directory' do
          expect(chef_run).to create_directory('/etc/lsyncd/conf.d').with(mode: 0755)
        end
        
        if ['centos', 'redhat'].include?(platform)
          it 'creates template[/etc/lsyncd.conf]' do
            expect(chef_run).to create_template('/etc/lsyncd.conf')
          end
        else
          it 'creates base config /etc/lsyncd/lsyncd.conf.lua' do
            expect(chef_run).to create_template('/etc/lsyncd/lsyncd.conf.lua')
          end
        end
    
        it 'enables and starts lsyncd' do
          expect(chef_run).to enable_service('lsyncd')
          expect(chef_run).to start_service('lsyncd')
        end
      end
    end
  end
end
