require_relative '../spec_helper'

describe 'lsyncd_test::unit' do
  let(:chef_run) { ChefSpec::Runner.new(step_into: ['lsyncd_target']).converge(described_recipe) }

    let(:test1_content) do
    'sync {
    default.rsync,
    source      = "/tmp/test1_source",
    target      = "/tmp/test1_target",
}
'
  end

  let(:test2_content) do
    'sync {
    default.rsync,
    source      = "/tmp/test2_source",
    target      = "/test/test2_target",
}
'
  end

  case node[:platform]
  when "centos"
    let(:test3_content) do
      'sync {
    default.rsyncssh,
    source      = "/tmp/test3_source",
    targetdir   = "/tmp/test3_target",
    host        = "test",
    rsync = {
      extra = {"-ltus", "--numeric-ids", "--bwlimit=10000"},
    },
    exclude     = {"foo", "bar"},
    excludeFrom = "/tmp/test_exclude",
}
'
    end
  when "debian"
    let(:test3_content) do
      'sync {
    default.rsyncssh,
    source      = "/tmp/test3_source",
    targetdir   = "/tmp/test3_target",
    host        = "test",
    rsyncOpts   = {"-ltus", "--numeric-ids", "--bwlimit=10000"},
    exclude     = {"foo", "bar"},
    excludeFrom = "/tmp/test_exclude",
}
'
    end
  else
    let(:test3_content) do
      'sync {
    default.rsyncssh,
    source      = "/tmp/test3_source",
    targetdir   = "/tmp/test3_target",
    host        = "test",
    rsyncOps   = {"-ltus", "--numeric-ids", "--bwlimit=10000"},
    exclude     = {"foo", "bar"},
    excludeFrom = "/tmp/test_exclude",
}
'
    end
  end

  let(:test5_content) do
    'sync {
    default.rsync,
    source      = "/tmp/test5_source",
    target      = "lnxuser@test:/tmp/test5_target",
}
'
  end

  it 'includes recipe lsyncd::default' do
    expect(chef_run).to include_recipe('lsyncd::default')
  end

  context 'creating an lsync_target with minimal parameters' do
    it 'creates lsyncd_target[test1]' do
      expect(chef_run).to create_lsyncd_target('test1')
    end

    it 'steps into lsyncd_target and creates template[/etc/lsyncd/conf.d/test1.lua]' do
      expect(chef_run).to render_file('/etc/lsyncd/conf.d/test1.lua').with_content(test1_content)
    end

    it 'notifies service[lsyncd] to restart delayed' do
      resource = chef_run.lsyncd_target('test1')
      expect(resource).to notify('service[lsyncd]').to(:restart).delayed
    end
  end

  context 'creating an lsync_target with rsync mode and host defined' do
    it 'creates lsyncd_target[test2]' do
      expect(chef_run).to create_lsyncd_target('test2')
    end

    it 'steps into lsyncd_target and creates template[/etc/lsyncd/conf.d/test2.lua]' do
      expect(chef_run).to render_file('/etc/lsyncd/conf.d/test2.lua').with_content(test2_content)
    end

    it 'notifies service[lsyncd] to restart delayed' do
      resource = chef_run.lsyncd_target('test2')
      expect(resource).to notify('service[lsyncd]').to(:restart).delayed
    end
  end

  context 'creating an lsync_target with rsyncssh mode and all attributes exercised' do
    it 'creates lsyncd_target[test3]' do
      expect(chef_run).to create_lsyncd_target('test3')
    end

    it 'steps into lsyncd_target and creates template[/etc/lsyncd/conf.d/test3.lua]' do
      expect(chef_run).to render_file('/etc/lsyncd/conf.d/test3.lua').with_content(test3_content)
    end

    it 'notifies service[lsyncd] to restart delayed' do
      resource = chef_run.lsyncd_target('test3')
      expect(resource).to notify('service[lsyncd]').to(:restart).delayed
    end
  end

  context 'deleting an lsync_target' do
    it 'deletes lsyncd_target[test4]' do
      expect(chef_run).to delete_lsyncd_target('test4')
    end

    it 'steps into lsyncd_target and deletes file[/etc/lsyncd/conf.d/test4.lua]' do
      expect(chef_run).to delete_file('/etc/lsyncd/conf.d/test4.lua')
    end

    it 'notifies service[lsyncd] to restart delayed' do
      resource = chef_run.lsyncd_target('test4')
      expect(resource).to notify('service[lsyncd]').to(:restart).delayed
    end
  end

  context 'creating an lsync_target with rsync and defining a user' do
    it 'creates lsyncd_target[test5]' do
      expect(chef_run).to create_lsyncd_target('test5')
    end

    it 'steps into lsyncd_target and creates template[/etc/lsyncd/conf.d/test5.lua]' do
      expect(chef_run).to render_file('/etc/lsyncd/conf.d/test5.lua').with_content(test5_content)
    end

    it 'notifies service[lsyncd] to restart delayed' do
      resource = chef_run.lsyncd_target('test5')
      expect(resource).to notify('service[lsyncd]').to(:restart).delayed
    end
  end
end
