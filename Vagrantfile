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