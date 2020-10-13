#!/bin/bash
set -eux

domain=$(hostname --fqdn)

# use the local Jenkins user database.
config_authentication='jenkins'
# OR use LDAP.
# NB this assumes you are running the Active Directory from https://github.com/rgl/windows-domain-controller-vagrant.
# NB AND you must manually copy its tmp/ExampleEnterpriseRootCA.der file to this environment tmp/ directory.
#config_authentication='ldap'


echo 'Defaults env_keep += "DEBIAN_FRONTEND"' >/etc/sudoers.d/env_keep_apt
chmod 440 /etc/sudoers.d/env_keep_apt
export DEBIAN_FRONTEND=noninteractive


#
# make sure the package index cache is up-to-date before installing anything.

apt-get update

#
# enable systemd-journald persistent logs.

sed -i -E 's,^#?(Storage=).*,\1persistent,' /etc/systemd/journald.conf
systemctl restart systemd-journald

#
# install dependencies.

apt-get install -y openjdk-8-jre-headless

#
# install Jenkins.

wget -qO- https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add -
echo 'deb http://pkg.jenkins.io/debian-stable binary/' >/etc/apt/sources.list.d/jenkins.list
apt-get update
apt-get install -y --no-install-recommends jenkins

