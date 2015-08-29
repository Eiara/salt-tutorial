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
  config.vm.box = "ubuntu/trusty64"

  config.vm.provision "shell", inline: <<eos
if ! [ -e /etc/apt/sources.list.d/saltstack-salt-trusty.list ]; then
  sudo add-apt-repository ppa:saltstack/salt
fi
sudo apt-get update
if ! dpkg -i language-pack-en > /dev/null 2>&1 ; then
  sudo apt-get install language-pack-en -y
fi
  
eos
  ip_base = "192.168.10"
  master_ip = "#{ip_base}.2"
  config.vm.define "controller" do |cont|
    cont.vm.hostname = "salt-controller"
    cont.vm.network "private_network", ip: master_ip
    cont.vm.provision "shell", inline: <<eos
if ! dpkg -i salt-master > /dev/null 2>&1 ; then
  sudo apt-get install -y salt-master
fi
if [ "$(cat /etc/salt/master | md5sum -)" != "$(cat /vagrant/config/master)" ]; then
  cp /vagrant/config/master /etc/salt/master
  service salt-master restart
fi
if ! [ -e /etc/salt/pki/master/minions ]; then
  mkdir -p /etc/salt/pki/master/minions
fi
cp /vagrant/keys/*.pub /etc/salt/pki/master/minions
pushd /etc/salt/pki/master/minions
for file in *.pub; do
  fn=`echo ${file} | sed s/\.pub//`
  mv $file $fn
done
popd
eos
  end

  (1..2).each do |i|
    config.vm.define "test#{i}" do |minion|
      minion.vm.hostname = "test#{i}"
      minion.vm.network "private_network", ip: "#{ip_base}.1#{i}"
      minion.vm.provision "shell", inline: <<eos
if ! [ -e /etc/salt/pki/minion/ ]; then
  mkdir -p /etc/salt/pki/minion/
  cp /vagrant/keys/test#{i}.* /etc/salt/pki/minion/
  pushd /etc/salt/pki/minion/
  for fn in test#{i}.*; do
    ext=`echo $fn | cut -d"." -f2`
    mv $fn minion.$ext
  done
fi
if ! dpkg -i salt-master > /dev/null 2>&1 ; then
  sudo apt-get install -y salt-minion
fi
if ! grep #{master_ip} /etc/hosts; then
  echo "#{master_ip}    salt" >> /etc/hosts
fi
eos
    end
  end
end
