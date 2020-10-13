### Vagrantfile

```
# to make sure the jenkins node is created before the other nodes, we
# have to force a --no-parallel execution.
ENV['VAGRANT_NO_PARALLEL'] = 'yes'

config_jenkins_fqdn = 'jenkins.example.com' (1)
config_jenkins_ip   = '10.10.10.100' (2)


Vagrant.configure('2') do |config|
  config.vm.box = 'geerlingguy/ubuntu2004'

  config.vm.provider :virtualbox do |vb|
    vb.linked_clone = true
    vb.memory = 2048
    vb.cpus = 2
    vb.customize ['modifyvm', :id, '--cableconnected1', 'on']
  end

  config.vm.define :jenkins do |config|
    config.vm.hostname = config_jenkins_fqdn
    config.vm.network :private_network, ip: config_jenkins_ip
    config.vm.provision :shell, path: 'provision.sh' (3)
  end

end

```


(1) (2) Vagrantfile is a Ruby script then we can dynamically / programatically define it.

(3) Shell Provisioner

https://www.vagrantup.com/docs/provisioning/shell




### Provision Script

Nothing special here. See details https://www.digitalocean.com/community/tutorials/how-to-install-jenkins-on-ubuntu-18-04


Note: script is extracted from https://github.com/pilgrim2go/jenkins-vagrant/blob/master/provision.sh


### Testing

Access http://10.10.10.100:8080