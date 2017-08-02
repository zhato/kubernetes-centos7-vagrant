# -*- mode: ruby -*-
# vi: set ft=ruby :

require './vagrant-provision-reboot-plugin'

load 'config.rb'

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vm.synced_folder '.', '/vagrant', disabled: true
  config.vm.synced_folder ".", "/shared"

  masterIp = $clusterIp+"30"
  config.vm.define "master" do |master|
    master.vm.network :private_network, :ip => "#{masterIp}"
    master.vm.hostname = "master"
    master.vm.provider "virtualbox" do |v|
      v.memory = $master_memory
    end
    master.vm.provision :shell, :inline => "sh /vagrant/common.sh"
    master.vm.provision :unix_reboot
    master.vm.provision :shell do |s|
      s.inline = "sh /vagrant/master.sh $1 $2"
      s.args = ["#{masterIp}", "#{$token}"]
    end
  end

  ## NODE
  (1..$node_count).each do |i|
    config.vm.define vm_name = "node-%d" % i do |node|
      nodeIp = $clusterIp+"#{i+30}"
      node.vm.network :private_network, :ip => "#{nodeIp}"
      node.vm.hostname = vm_name
      node.vm.provider "virtualbox" do |v|
        v.memory = $node_memory
      end
      node.vm.provision :shell, :inline => "sh /vagrant/common.sh"
      node.vm.provision :unix_reboot
      node.vm.provision :shell do |s|
        s.inline = "sh /vagrant/node.sh $1 $2 $3 $4"
        s.args = ["#{masterIp}", "#{$token}", "#{nodeIp}", "#{i}"]
      end
      node.vm.provision "shell", inline: <<-SHELL
        if [ "#{i}" == "#{$node_count}" ]; then
          kubectl --kubeconfig /vagrant/admin.conf create -f https://git.io/kube-dashboard
        fi
      SHELL
    end
  end
end
