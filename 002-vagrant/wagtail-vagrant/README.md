
### References

https://github.com/wagtail/bakerydemo


### Goals

Setup a Django Application Development/Deployment Using Vagrant

### Vagrantfile

from https://github.com/wagtail/bakerydemo/blob/master/Vagrantfile


```
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "wagtail-buster64-v1.1.0" (1)
  config.vm.box_version = "~> 0" (2)
  config.vm.network "forwarded_port", guest: 8000, host: 8000 (3)

  # SHELL
  config.vm.provision :shell, :path => "vagrant/provision.sh", :args => "bakerydemo"

  # Enable agent forwarding over SSH connections.
  config.ssh.forward_agent = true (4)

  if File.exist? "Vagrantfile.local"
    instance_eval File.read("Vagrantfile.local"), "Vagrantfile.local" (5)
  end
end
```

(1)(2)
Custom image built from https://github.com/wagtail/vagrant-wagtail-base

(3) Forwarded Ports 

Vagrant forwarded ports allow you to access a port on your host machine and have all data forwarded to a port on the guest machine, over either TCP or UDP.



https://www.vagrantup.com/docs/networking/forwarded_ports

(4) If true, agent forwarding over SSH connections is enabled

https://www.vagrantup.com/docs/vagrantfile/ssh_settings

(5) Creating a `Vagrantfile.local` file allows you to extend the Vagrant configuration
with options specific to this local machine.