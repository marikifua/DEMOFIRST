#!/bin/sh
sudo yum install -y epel-release
sudo yum update -y
sudo yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel maven git
sudo bash -c 'cat > /etc/profile.d/java8.sh <<EOF
export JAVA_HOME=$(dirname $(dirname $(readlink $(readlink $(which javac)))))
export PATH=$PATH:$JAVA_HOME/bin
export CLASSPATH=.:$JAVA_HOME/jre/lib:$JAVA_HOME/lib:$JAVA_HOME/lib/tools.jar
EOF'
sudo bash -c 'cat > /etc/profile.d/maven.sh <<EOF
export M2_HOME=/usr/share/maven/
export MAVEN_HOME=/usr/share/maven/
EOF'
source /etc/profile.d/java8.sh
source /etc/profile.d/maven.sh
# sudo useradd jenkins
# sudo mkdir -p /opt/socks
# sudo chown jenkins /opt/socks
# sudo bash -c 'cat > /usr/lib/systemd/system/carts.service <<EOF
# [Unit]
#Description=Socks Carts server
#[Service]
#ExecStart=/usr/bin/java -Ddb:carts-db=mongodb -jar /opt/socks/carts.jar
#User=jenkins
#ExecReload=/bin/kill -HUP $MAINPID
#KillMode=process
#[Install]
#WantedBy=multi-user.target
#EOF
#sudo systemctl start carts
#sudo system enable carts