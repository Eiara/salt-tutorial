# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  # config.vm.box = "ubuntu/trusty64"

  machines = []
(1..2).each { |id|
  machines << "test#{id}"
}
  
  ip_base = "192.168.10"
  master_ip = "#{ip_base}.2"

  config.vm.define "controller" do |cont|
    cont.vm.box = "https://s3-ap-southeast-2.amazonaws.com/salt-tutorial/controller.box"

    cont.vm.hostname = "salt-controller"
    cont.vm.network "private_network", ip: master_ip
  end

  machines.each.with_index do |machine, i|
    config.vm.define machine do |minion|
      minion.vm.box = "https://s3-ap-southeast-2.amazonaws.com/salt-tutorial/test-#{i+1}.box"
      minion.vm.hostname = machine
      minion.vm.network "private_network", ip: "#{ip_base}.1#{i}"
    end
  end
end
