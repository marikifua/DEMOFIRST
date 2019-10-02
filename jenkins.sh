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
sudo sleep 60
sudo systemctl enable jenkins
sudo sleep 60
sudo systemctl stop jenkins
sudo sleep 60
sudo systemctl start jenkins
sudo sleep 60
sudo rm -rf /var/lib/jenkins/init.groovy.d

java -jar /var/cache/jenkins/war/WEB-INF/jenkins-cli.jar -auth admin:admin -s "http://localhost:8080/" install-plugin trilead-api `
`jdk-tool workflow-support script-security command-launcher workflow-cps bouncycastle-api handlebars  locale `
`javadoc momentjs structs workflow-step-api scm-api workflow-api junit apache-httpcomponents-client-4-api `
`pipeline-input-step display-url-api mailer credentials ssh-credentials jsch maven-plugin git-server token-macro `
`pipeline-stage-step run-condition matrix-project conditional-buildstep parameterized-trigger git git-client `
`workflow-scm-step cloudbees-folder timestamper pipeline-milestone-step workflow-job jquery-detached jackson2-api `
`branch-api ace-editor pipeline-graph-analysis pipeline-rest-api pipeline-stage-view pipeline-build-step `
`plain-credentials credentials-binding pipeline-model-api pipeline-model-extensions workflow-cps-global-lib `
`workflow-multibranch authentication-tokens docker-commons durable-task workflow-durable-task-step `
`workflow-basic-steps docker-workflow pipeline-stage-tags-metadata pipeline-model-declarative-agent `
`pipeline-model-definition workflow-aggregator lockable-resources -deploy
sudo sleep 60
sudo systemctl stop jenkins
sudo sleep 60
sudo systemctl start jenkins
sudo sleep 60

