# -*- mode: ruby -*-
# vi: set ft=ruby :
# To use, install vagrant at http://vagrantup.com/

require 'berkshelf/vagrant'

def ENV.to_config(keys)
  keys.inject({}) do |hash, key|
    hash[key.downcase] = ENV[key.upcase]
    hash
  end
end

Vagrant::Config.run do |config|
  config.vm.box = "ec2-precise64"
  config.vm.box_url =
    "https://s3.amazonaws.com/mediacore-public/boxes/ec2-precise64.box"

# Used to test the release / install loop
#  config.vm.provision :shell, :path => "script/vagrant-deploy"

  config.vm.forward_port 80, 8080

  # Makes chef availabe on the host
  config.vm.provision :shell, :path => 'script/vagrant-bootstrap'

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "log-service"
    chef.json = {
      log_service: ENV.to_config(%w[AWS_ACCESS_KEY AWS_SECRET_KEY AWS_PRIVATE_KEY GITHUB_CLIENT_ID GITHUB_CLIENT_SECRET])
    }
  end

end
