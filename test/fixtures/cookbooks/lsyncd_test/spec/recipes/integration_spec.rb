require_relative '../spec_helper'

describe 'lsyncd_test::integration' do
  let(:chef_run) { ChefSpec::SoloRunner.new(step_into: ['lsyncd_target']).converge(described_recipe) }

  let(:test1_content) do
    'sync {
    default.rsync,
    source      = "/tmp/test1_source",
    target      = "/tmp/test1_target",
}
'
  end

  it 'includes recipe lsyncd::default' do
    expect(chef_run).to include_recipe('lsyncd::default')
  end

  context "setting up test resources" do
    it 'creates directory[/tmp/test1_source]' do
      expect(chef_run).to create_directory('/tmp/test1_source')
    end

    it 'creates directory[/tmp/test1_target]' do
      expect(chef_run).to create_directory('/tmp/test1_target')
    end

    it 'creates file[/tmp/test1_source/empty_file]' do
      expect(chef_run).to create_file('/tmp/test1_source/empty_file')
    end
  end

  context "creating an lsync_target with minimal parameters" do
    it 'creates lsyncd_target[test1]' do
      expect(chef_run).to create_lsyncd_target('test1')
    end

    it 'steps into lsyncd_target and creates template[/etc/lsyncd/conf.d/test1.lua' do
      expect(chef_run).to render_file('/etc/lsyncd/conf.d/test1.lua').with_content(test1_content)
    end

    it 'notifies service[lsyncd] to restart delayed' do
      resource = chef_run.lsyncd_target('test1')
      expect(resource).to notify('service[lsyncd]').to(:restart).delayed
    end
  end
end
