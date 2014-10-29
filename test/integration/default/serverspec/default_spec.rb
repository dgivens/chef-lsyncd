require 'serverspec'

describe 'lsyncd' do
  it 'creates directory /tmp/test1_source' do
    expect(file('/tmp/test1_source')).to be_directory
    expect(file('/tmp/test1_source')).to be_mode 755
  end

  it 'creates directory /tmp/test1_target' do
    expect(file('/tmp/test1_target')).to be_directory
    expect(file('/tmp/test1_target')).to be_mode 755
  end

  it 'creates lsyncd_target[test1]' do
    expect(file('/etc/lsyncd/conf.d/test1.lua')).to be_file
    expect(file('/etc/lsyncd/conf.d/test1.lua')).to be_mode 644
  end

  it 'creates test file for syncing' do
    expect(file('/tmp/test1_source/empty_file')).to be_file
    expect(file('/tmp/test1_source/empty_file')).to be_mode 644
  end

  it 'enables service[lsyncd]' do
    expect(service('lsyncd')).to be_enabled
  end

  it 'starts lsyncd' do
    expect(process('lsyncd')).to be_running
  end

  it 'lsyncd replicates the test file' do
    expect(file('/tmp/test1_target/empty_file')).to be_file
    expect(file('/tmp/test1_target/empty_file')).to be_mode 644
  end
end
