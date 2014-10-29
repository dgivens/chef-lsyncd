require_relative '../spec_helper'

describe 'lsyncd::default' do
  platforms = {
    'ubuntu' => ['12.04', '14.04'],
    'debian' => ['7.0'],
    'centos' => ['6.5', '7.0'],
    'redhat' => ['6.5', '7.0']
  }

  let(:v2_0_lsyncd_conf) do
    '-- Managed by Chef

settings = {
  logfile = "/var/log/lsyncd.log",
  statusFile = "/var/log/lsyncd-status.log",
  statusInterval = 20
}

-- Hacky way of doing conf.d style configs
package.path = "/etc/lsyncd/conf.d/?.lua;" .. package.path
local f = io.popen("ls /etc/lsyncd/conf.d/*.lua|xargs -n1 basename|sed \'s/.lua//\'") for mod in f:lines() do require(mod) end
'
  end

  let(:v2_1_lsyncd_conf) do
    '-- Managed by Chef; Using lsync 2.1 config sytax

settings {
  logfile = "/var/log/lsyncd.log",
  statusFile = "/var/log/lsyncd-status.log",
  statusInterval = 20
}

-- Hacky way of doing conf.d style configs
package.path = "/etc/lsyncd/conf.d/?.lua;" .. package.path
local f = io.popen("ls /etc/lsyncd/conf.d/*.lua|xargs -n1 basename|sed \'s/.lua//\'") for mod in f:lines() do require(mod) end
'
  end

  platforms.each do |platform, versions|
    versions.each do |version|
      context "On #{platform} #{version}" do
        let(:chef_run) { ChefSpec::SoloRunner.new(platform: platform, version: version).converge(described_recipe) }

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
            expect(chef_run).to render_file('/etc/lsyncd.conf').with_content(v2_1_lsyncd_conf)
          end
        else
          it 'creates base config /etc/lsyncd/lsyncd.conf.lua' do
            expect(chef_run).to create_template('/etc/lsyncd/lsyncd.conf.lua')
            if platform == 'ubuntu' && version == '14.04'
              expect(chef_run).to render_file('/etc/lsyncd/lsyncd.conf.lua').with_content(v2_1_lsyncd_conf)
            else
              expect(chef_run).to render_file('/etc/lsyncd/lsyncd.conf.lua').with_content(v2_0_lsyncd_conf)
            end
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
