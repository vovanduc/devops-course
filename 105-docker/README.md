### Virtual Private Cloud Network

In this section a dedicated [Virtual Private Cloud](https://cloud.google.com/compute/docs/networks-and-firewalls#networks) (VPC) network will be setup to host the Kubernetes cluster.

Create the `docker-the-hard-way` custom VPC network:

```
gcloud compute networks create docker-the-hard-way --subnet-mode custom
```

A [subnet](https://cloud.google.com/compute/docs/vpc/#vpc_networks_and_subnets) must be provisioned with an IP address range large enough to assign a private IP address to each node in the Kubernetes cluster.

Create the `docker` subnet in the `docker-the-hard-way` VPC network:

```
gcloud compute networks subnets create docker \
  --network docker-the-hard-way \
  --range 10.240.0.0/24
```

> The `10.240.0.0/24` IP address range can host up to 254 compute instances.


### Firewall Rules

Create a firewall rule that allows internal communication across all protocols:

```
gcloud compute firewall-rules create docker-the-hard-way-allow-internal \
  --allow tcp,udp,icmp \
  --network docker-the-hard-way \
  --source-ranges 10.240.0.0/24,10.200.0.0/16
```

Create a firewall rule that allows external SSH, ICMP, and HTTPS:

```
gcloud compute firewall-rules create docker-the-hard-way-allow-external \
  --allow tcp:22,tcp:8000,icmp \
  --network docker-the-hard-way \
  --source-ranges 0.0.0.0/0
```

List the firewall rules in the `docker-the-hard-way` VPC network:

```
gcloud compute firewall-rules list --filter="network:docker-the-hard-way"
```

> output

```
NAME                                NETWORK              DIRECTION  PRIORITY  ALLOW                 DENY  DISABLED
docker-the-hard-way-allow-external  docker-the-hard-way  INGRESS    1000      tcp:22,tcp:8000,icmp        False
docker-the-hard-way-allow-internal  docker-the-hard-way  INGRESS    1000      tcp,udp,icmp                False
```


## Compute Instances

The compute instances in this lab will be provisioned using [Ubuntu Server](https://www.ubuntu.com/server) 20.04, which has good support for the [containerd container runtime](https://github.com/containerd/containerd). Each compute instance will be provisioned with a fixed private IP address to simplify the Kubernetes bootstrapping process.

### Docker  VM


```
gcloud compute instances create docker-105 \
--boot-disk-size 10GB \
--can-ip-forward \
--image-family ubuntu-2004-lts \
--image-project ubuntu-os-cloud \
--machine-type e2-small \
--scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
--subnet docker \
--tags docker-the-hard-way,controller
```
or
```



### Verification

List the compute instances in your default compute zone:

```
gcloud compute instances list --filter="tags.items=docker-the-hard-way"
```

> output


## Configuring SSH Access

SSH will be used to configure the controller and worker instances. When connecting to compute instances for the first time SSH keys will be generated for you and stored in the project or instance metadata as described in the [connecting to instances](https://cloud.google.com/compute/docs/instances/connecting-to-instance) documentation.

Test SSH access to the `controller-0` compute instances:

```
gcloud compute ssh docker-105
```

If this is your first time connecting to a compute instance SSH keys will be generated for you. Enter a passphrase at the prompt to continue:

```
WARNING: The public SSH key file for gcloud does not exist.
WARNING: The private SSH key file for gcloud does not exist.
WARNING: You do not have an SSH key for gcloud.
WARNING: SSH keygen will be executed to generate a key.
Generating public/private rsa key pair.
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```

At this point the generated SSH keys will be uploaded and stored in your project:

```
Your identification has been saved in /home/$USER/.ssh/google_compute_engine.
Your public key has been saved in /home/$USER/.ssh/google_compute_engine.pub.
The key fingerprint is:
SHA256:nz1i8jHmgQuGt+WscqP5SeIaSy5wyIJeL71MuV+QruE $USER@$HOSTNAME
The key's randomart image is:
+---[RSA 2048]----+
|                 |
|                 |
|                 |
|        .        |
|o.     oS        |
|=... .o .o o     |
|+.+ =+=.+.X o    |
|.+ ==O*B.B = .   |
| .+.=EB++ o      |
+----[SHA256]-----+
Updating project ssh metadata...-Updated [https://www.googleapis.com/compute/v1/projects/$PROJECT_ID].
Updating project ssh metadata...done.
Waiting for SSH key to propagate.
```

After the SSH keys have been updated you'll be logged into the `controller-0` instance:

```
Welcome to Ubuntu 20.04 LTS (GNU/Linux 5.4.0-1019-gcp x86_64)
...
```

Type `exit` at the prompt to exit the `controller-0` compute instance:

```
$USER@controller-0:~$ exit
```
> output

```
logout
Connection to XX.XX.XX.XXX closed



### Setup Ansible


From output of 

```
gcloud compute instances list --filter="tags.items=docker-the-hard-way"
NAME        ZONE               MACHINE_TYPE  PREEMPTIBLE  INTERNAL_IP  EXTERNAL_IP     STATUS
docker-105  asia-southeast1-b  e2-small                   10.240.0.2   35.197.129.132  RUNNING

```

Copy the public ip `35.197.129.132` and create inventory file like this

```
[all]
35.197.129.132 ansible_user=nowhereman ansible_ssh_private_key_file=~/.ssh/google_compute_engine
```

Note: `ansible_user` is depending on your control VM. Mine is `nowhereman`


Copy content of https://github.com/geerlingguy/ansible-for-devops/tree/master/docker-flask to your working folder.


```
.
├── README.md
├── inventory
├── provisioning
│   ├── data
│   │   └── Dockerfile
│   ├── db
│   │   └── Dockerfile
│   ├── docker.yml
│   ├── main.yml
│   ├── setup.yml
│   └── www
│       ├── Dockerfile
│       ├── index.py.j2
│       ├── playbook.yml
│       └── templates
│           └── index.html
└── requirements.yml

```

In original source, ansible is tested agains Vagrant and Vagrant automatically copy files to /vagrant.

We need to do similar thing

Update main.yml

```
---
- hosts: all
  become: true

  vars:
    build_root: /vagrant/provisioning

  pre_tasks:
    - name: Update apt cache if needed.
      apt: update_cache=yes cache_valid_time=3600
    - shell: mkdir -p /vagrant/provisioning
    - name: Copy file with owner and permissions
      copy:
        src: "{{ item }}"
        dest: /vagrant/provisioning
        owner: nowhereman
        group: nowhereman
        mode: '0644'
      with_items:
        - data
        - db
        - www

        
```        



### Run Ansible


`ansible-playbook -i inventory provisioning/main.yml -vvv`




### Testing


Make sure firewall rule is allowed for port 80
```
gcloud compute firewall-rules create docker-the-hard-way-allow-http \
  --allow tcp:80 \
  --network docker-the-hard-way \
  --source-ranges 0.0.0.0/0

```


`curl 35.197.129.132`


> Output

```
<!DOCTYPE html>
<html>
<head>
  <title>Flask + MySQL Docker Example</title>
  <style>* { font-family: Helvetica, Arial, sans-serif }</style>
</head>
<body>
  <h1>Flask + MySQL Docker Example</h1>
  <p>MySQL Connection: <span style="color: green;">PASS</span></p>
</body>
```

