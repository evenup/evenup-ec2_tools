require 'spec_helper'

describe 'ec2_tools', :type => :class do

  it { should create_class('ec2_tools') }

  context "default" do
    it { should contain_package('s3cmd').with_ensure('latest') }
    it { should contain_file('/root/.s3cfg') }
    it { should contain_package('python-awscli').with_ensure('latest') }
    it { should contain_file('/etc/profile.d/ec2_tools.sh').with_ensure('absent') }
    it { should contain_file('/opt/ec2-api-tools').with_ensure('absent') }
    it { should contain_file('/opt/iam-api-tools').with_ensure('absent') }
    it { should contain_file('/opt/ec2-api-tools-1.6.6.1').with_ensure('absent') }
    it { should contain_file('/opt/iamcli-1.5.0').with_ensure('absent') }
  end

  context "java => true" do
    let(:params) { { :java => true } }
    it { should contain_class('java') }
    it { should contain_file('/etc/profile.d/ec2_tools.sh').with_mode('0555') }
    it { should contain_exec('ec2_tools-fetch') }
    it { should contain_exec('iam_tools-fetch') }
    it { should contain_exec('ec2_tools-decompress') }
    it { should contain_exec('iam_tools-decompress') }
    it { should contain_file('/opt/ec2-api-tools').with_ensure('link') }
    it { should contain_file('/opt/iam-api-tools').with_ensure('link') }
  end

  context "python => false" do
    let(:params) { { :python => false } }
    it { should contain_package('python-awscli').with_ensure('absent') }
  end

  context "s3cmd => false" do
    let(:params) { { :s3cmd => false } }
    it { should contain_package('s3cmd').with_ensure('absent') }
  end

end

