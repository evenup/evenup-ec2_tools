require 'spec_helper'

describe 'ec2_tools', :type => :class do

  it { should create_class('ec2_tools') }
  it { should include_class('java') }
  it { should contain_package('s3cmd') }
  it { should contain_package('python-awscli') }
  it { should create_file('/etc/profile.d/ec2_tools.sh').with_mode('0555') }

  context "when called with default parameters" do
    it { should create_exec('ec2_tools-fetch') }
    it { should create_exec('ec2_tools-decompress') }
    it { should create_file('/opt/ec2-api-tools') }
  end

end

