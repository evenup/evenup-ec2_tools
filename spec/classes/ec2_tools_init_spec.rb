require 'spec_helper'
 
describe 'ec2_tools', :type => :class do

  it { should create_class('ec2_tools') }
  it { should include_class('java') }
  it { should create_package('s3cmd') }
  it { should create_file('/etc/profile.d/ec2_tools.sh').with_mode('0555') }  

  context "when called with default parameters" do
    it { should create_exec('ec2_tools-fetch') }
    it { should create_exec('ec2_tools-decompress') }
    it { should create_file('/opt/ec2-api-tools') }
  end
  
  context "when $ec2_tools_version => '1.2.3.4'" do
    let(:params) { { 'ec2_tools_version' => '1.2.3.4' } } 
    
    it { should create_exec('ec2_tools-fetch').with(
      'onlyif'  => "test ! -d /opt/ec2-api-tools-1.2.3.4"
    ) }

    it { should create_exec('ec2_tools-decompress').with(
      'unless'  => "test -l /opt/ec2-api-tools-1.2.3.4"
    ) }

    it { should create_file('/opt/ec2-api-tools').with(
      'ensure'  => 'link',
      'target'  => '/opt/ec2-api-tools-1.2.3.4'
    ) } 
  end
    
end

