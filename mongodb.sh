#!/bin/sh
sudo bash -c 'cat > /etc/yum.repos.d/mongodb-org-4.2.repo <<EOF
[mongodb-org-4.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/7Server/mongodb-org/4.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.2.as
EOF'
sudo rpm --import https://www.mongodb.org/static/pgp/server-4.2.asc
sudo mkdir -p /var/lib/mongo
sudo mkdir -p /var/log/mongodb
sudo yum -y update
sudo yum install -y mongodb-org
sudo chown -R mongod:mongod /var/lib/mongo
sudo chown -R mongod:mongod /var/log/mongodb
export ip=$(/sbin/ip -o -4 addr list eth0 | awk '{print $4}' | cut -d/ -f1)
sudo sed -i "s/bindIp: 127.0.0.1/bindIp: 127.0.0.1,$ip/" /etc/mongod.conf
sudo systemctl start mongod
sudo systemctl enable mongod

