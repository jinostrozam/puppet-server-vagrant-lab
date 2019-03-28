# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.provider :libvirt do |kvm|
    kvm.random model: 'random'
    kvm.cpu_mode  = 'host-passthrough'
    kvm.driver    = 'kvm'
    kvm.memory    = 4096
    kvm.cpus      = 2
  end

  config.ssh.forward_agent = true

  config.vm.define "puppet" do |vm1|

    vm1.vm.box              = "generic/ubuntu1604"
      vm1.vm.hostname         = "puppet"
      vm1.vm.box_check_update = true
 
      vm1.vm.network :private_network,
                      ip: '192.168.200.10',
                      libvirt_netmask: '255.255.255.0',
                      libvirt__network_name: 'puppet-server-vagrant-lab',
                      autostart: true,
                      libvirt__forward_mode: 'route',
                      libvirt__dhcp_enabled: false  
      
      
      #vm1.vm.synced_folder "./control-repo-ppserver", "/etc/puppetlabs/code/environments/production"
    
      vm1.vm.provision "shell", path: "scripts/puppet-server-install.sh"

      vm1.vm.provision "shell", :inline => <<-SHELL
        sudo echo -e 'nameserver 8.8.8.8\nnameserver 8.8.4.4\n' > /etc/resolv.conf
        sudo echo "192.168.200.10 puppet" | sudo tee -a /etc/hosts
        sudo echo "192.168.200.20 agent" | sudo tee -a /etc/hosts
        sudo echo "*" | sudo tee -a /etc/puppetlabs/puppet/autosign.conf
        sudo echo "autosign = true" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
        sudo echo "[main]" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
        sudo echo -e "certname = puppet\nserver = puppet\nenvironment = production\nruninterval = 15m" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
      SHELL

      vm1.vm.provision "shell", :inline => <<-SHELL
        sudo /usr/sbin/adduser --disabled-password --shell /bin/bash --gecos "user" provisioner
        sudo mkdir -p /home/provisioner/.ssh/
        sudo touch /home/provisioner/.ssh/authorized_keys
        sudo echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIKOhhhOhFJnyDCt90PIMElvS1CiIxAW6lyea5K56+pKYt9diY2++6mdnOpN0eBc6/1KBGzbA4k20aTd+XzXqmdeGYH+MdqEZPlu2HwuJof4SB9uOOS6Wp0mBr02LUIuRbBCR0qjZNY0kRit1PRHlMNQXWq8JnpMd/DaBAY9tbLsbASilwmrfmpsJbVOdtJpX1QaRpHZiO4Ybl+tPR1Ys4AeaUOmQ6cjEDa5tTxRzva9F9odxAYTQYxZkMPGSogMABzG2uz6aCY8dAZ9RpsUtPxNsIHn3SN+pGYol89eDH+VbkuDp7gn7LiNkVB0bQvUPshuf0LH+BWbOGN9nRcbuF provisioner" | sudo tee -a /home/provisioner/.ssh/authorized_keys
        sudo touch /etc/sudoers.d/10_provisioner
        sudo echo "provisioner ALL=(ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers.d/10_provisioner
      SHELL

      #vm1.vm.provision "shell", path: "scripts/puppify.sh"

  end


  config.ssh.forward_agent = true

  config.vm.define "agent" do |vm2|

    vm2.vm.box              = "generic/ubuntu1604"
      vm2.vm.hostname         = "agent"
      vm2.vm.box_check_update = true
 
      vm2.vm.network :private_network,
                      ip: '192.168.200.20',
                      libvirt_netmask: '255.255.255.0',
                      libvirt__network_name: 'puppet-server-vagrant-lab',
                      autostart: true,
                      libvirt__forward_mode: 'route',
                      libvirt__dhcp_enabled: false  
      
      
      #vm2.vm.synced_folder "./control-repo-ppserver", "/etc/puppetlabs/code/environments/production"
    
      vm2.vm.provision "shell", path: "scripts/puppet-agent-install.sh"

      vm2.vm.provision "shell", :inline => <<-SHELL
        sudo echo -e 'nameserver 8.8.8.8\nnameserver 8.8.4.4\n' > /etc/resolv.conf
        sudo echo "192.168.200.10 puppet" | sudo tee -a /etc/hosts
        sudo echo "192.168.200.20 agent" | sudo tee -a /etc/hosts
        sudo echo "autosign = true" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
        sudo echo "[main]" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf
        sudo echo -e "certname = agent\nserver = puppet\nenvironment = production\nruninterval = 15m" | sudo tee -a /etc/puppetlabs/puppet/puppet.conf        
      SHELL
  end
end