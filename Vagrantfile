# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# To use, install vagrant at http://vagrantup.com/
#
# And also install the berkshelf plugin:
#   `vagrant plugin install berkshelf-vagrant`

Vagrant.configure("2") do |config|
  config.berkshelf.enabled = true
  config.vm.box = "base-0.3.0"
  config.vm.box_url =
    "http://paasta-boxes.s3.amazonaws.com/base-0.3.0-amd64-20131028-virtualbox.box"

  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 9200, host: 9200

  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "logsanity"

    chef_config = JSON.load(File.read 'config/local.json') rescue {}
    chef_config['elasticsearch'] ||= {}
    chef_config['elasticsearch']['allocated_memory'] = '200m'
    chef.json = chef_config
  end
end
