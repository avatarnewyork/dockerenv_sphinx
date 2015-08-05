# spec/Dockerfile_spec.rb

require "serverspec"
require "docker"

# Workaround needed for circleCI
if ENV['CIRCLECI']
  class Docker::Container
    def remove(options={}); end
    alias_method :delete, :remove
  end
end

describe "Dockerfile" do
  before(:all) do
    image = Docker::Image.build_from_dir('.')

    set :os, :family => 'redhat'
    set :backend, :docker
    set :docker_image, image.id
  end

  it "installs the right version of Centos" do
    expect(os_version).to include("CentOS release 6")
  end

  it "installs required packages" do
    expect(package("sphinx")).to be_installed
    expect(package("mysql")).to be_installed
  end

  describe 'Sphinx Install' do
    describe command('searchd --help') do
      its(:stdout) { should include('Sphinx 2.0.8') }
    end
  end
  
  def os_version
    command("/bin/cat /etc/redhat-release").stdout
  end
end
