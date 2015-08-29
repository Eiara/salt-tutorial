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

  machines = []
(1..2).each { |id|
  machines << "test#{id}"
}
  

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
pushd /vagrant/keys
for machine in #{ machines.join(" ") }; do
  if ! [ -e $machine.pub ]; then
    salt-key --gen-keys=$machine --gen-keys-dir .
  fi
done
cp /vagrant/keys/*.pub /etc/salt/pki/master/minions
pushd /etc/salt/pki/master/minions
for file in *.pub; do
  fn=`echo ${file} | sed s/\.pub//`
  mv $file $fn
done
popd
eos
  end

  machines.each.with_index do |machine, i|
    config.vm.define machine do |minion|
      minion.vm.hostname = machine
      minion.vm.network "private_network", ip: "#{ip_base}.1#{i}"
      minion.vm.provision "shell", inline: <<eos
echo "Machine name is #{machine}"
if ! [ -e "/etc/salt/pki/minion/#{machine}.pem" ]; then
  echo "No keys on machine"
  mkdir -p /etc/salt/pki/minion/
  cp /vagrant/keys/#{machine}.* /etc/salt/pki/minion/
  pushd /etc/salt/pki/minion/
  for fn in #{machine}.*; do
    echo "${fn}"
    ext=`echo $fn | cut -d"." -f2`
    mv $fn minion.$ext
  done
  popd
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
