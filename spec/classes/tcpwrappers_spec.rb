require 'spec_helper'

describe 'tcpwrappers' do
  let(:title) { 'tcpwrappers' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42', :operatingsystem => 'Debian' } }

  describe 'Test minimal installation' do
    it { should contain_package('libwrap0').with_ensure('present') }
    it { should contain_file('allow.file').with_ensure('present') }
    it { should contain_file('deny.file').with_ensure('present') }
  end

  describe 'Test minimal installation - CentOS' do
    let(:facts) { { :operatingsystem => 'Centos' } }
    it { should contain_package('setup').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { { :version => '1.0.42' } }
    it { should contain_package('libwrap0').with_ensure('1.0.42') }
  end

  describe 'Test noops mode' do
    let(:params) { { :noops => true } }
    it { should contain_package('libwrap0').with_noop('true') }
    it { should contain_file('allow.file').with_noop('true') }
  end

  describe 'Test customizations - template' do
    let(:params) do
      {
        :allow_template => 'tcpwrappers/spec.erb',
        :options => { 'opt_b' => 'value_b' }
      }
    end
    it 'should generate a valid template' do
      content = catalogue.resource('file', 'allow.file').send(:parameters)[:content]
      content.should match 'fqdn: rspec.example42.com'
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'allow.file').send(:parameters)[:content]
      content.should match 'value_b'
    end
  end

  describe 'Test customizations - source' do
    let(:params) do
      {
        :allow_source => 'puppet:///modules/tcpwrappers/spec',
        :deny_source => 'puppet:///modules/tcpwrappers/spec'
      }
    end
    it { should contain_file('allow.file').with_source('puppet:///modules/tcpwrappers/spec') }
    it { should contain_file('deny.file').with_source('puppet:///modules/tcpwrappers/spec') }
  end

  describe 'Test customizations - custom class' do
    let(:params) { { :my_class => 'tcpwrappers::spec' } }
    it { should contain_file('allow.file').with_content(/rspec.example42.com/) }
  end
end
