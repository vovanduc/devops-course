


### Vagrantfile


```
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2" (1)

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "geerlingguy/ubuntu2004" (2)
  config.vm.hostname = "vagrant.hello" (3)
  config.vm.network :private_network, ip: "192.168.76.76" (3)
  config.ssh.insert_key = false (4)

  config.vm.provider :virtualbox do |v|
    v.memory = 512 (5)
  end

end


```


(1) Vagrant API Version https://www.vagrantup.com/docs/vagrantfile/version

(2) Boxes are the package format for Vagrant environments. A box can be used by anyone on any platform that Vagrant supports to bring up an identical working environment. 

https://www.vagrantup.com/docs/boxes

(3) A hostname may be defined for a Vagrant VM using the config.vm.hostname setting. By default, this will modify /etc/hosts, adding the hostname on a loopback interface that is not in use. 

https://www.vagrantup.com/docs/networking/basic_usage#setting-hostname

(4) https://www.vagrantup.com/docs/vagrantfile/ssh_settings#config-ssh-insert_key

(5)  The VirtualBox provider exposes some additional configuration options that allow you to more finely control your VirtualBox-powered Vagrant environments. 

https://www.vagrantup.com/docs/providers/virtualbox/configuration



### Scenarios

#### Test SSH

`vagrant ssh`

#### Check Hostname

```

vagrant ssh

cat /etc/hosts

```

expect output

```
vagrant@vagrant:~$ cat /etc/hosts
127.0.0.1	localhost
127.0.1.1	vagrant.hello	vagrant
...
```

#### Test internet access

```
vagrant@vagrant:~$ curl -I google.com
HTTP/1.1 301 Moved Permanently
Location: http://www.google.com/
Content-Type: text/html; charset=UTF-8
Date: Tue, 13 Oct 2020 04:21:07 GMT
Expires: Thu, 12 Nov 2020 04:21:07 GMT
Cache-Control: public, max-age=2592000
Server: gws
Content-Length: 219
X-XSS-Protection: 0
X-Frame-Options: SAMEORIGIN

```


#### Install Nginx


```
sudo apt-get update

sudo apt install nginx
```

#### Test Host Accessible



Remember `config.vm.network ` in `Vagrantfile`?

```
...
  config.vm.network :private_network, ip: "192.168.76.76" 
...
```  

`curl 192.168.76.76`

