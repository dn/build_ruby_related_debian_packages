# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", 2048]
    vb.customize ["modifyvm", :id, "--cpus", "2"]
  end
  #config.vm.customize ["modifyvm", :id, "--ioapic", "on"]

  config.vm.box = "ubuntu/precise64"
  config.vm.provision :shell, :path => "setup.sh"
end
