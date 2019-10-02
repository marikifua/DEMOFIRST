#!/bin/sh
sudo yum install -y epel-release
cd /etc/yum.repos.d
sudo curl -O https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
#sudo yum -y update 
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
sudo yum  install -y jenkins
sudo mkdir /var/lib/jenkins/init.groovy.d/
sudo bash -c "cat > /var/lib/jenkins/init.groovy.d/basic-security.groovy <<EOF
#!groovy

import jenkins.model.*
import hudson.security.*

def instance = Jenkins.getInstance()

println \"--> creating local user 'admin' \"

def hudsonRealm = new HudsonPrivateSecurityRealm(false)
hudsonRealm.createAccount('admin','admin1')
instance.setSecurityRealm(hudsonRealm)

def strategy = new FullControlOnceLoggedInAuthorizationStrategy()
instance.setAuthorizationStrategy(strategy)
instance.save()
EOF"
sudo systemctl start jenkins
sudo sleep 120
sudo systemctl enable jenkins
sudo sleep 120
sudo systemctl stop jenkins
sudo sleep 120
sudo systemctl start jenkins
sudo sleep 120
sudo rm -rf /var/lib/jenkins/init.groovy.d

